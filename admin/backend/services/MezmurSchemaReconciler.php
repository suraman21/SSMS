<?php
/**
 * Mezmur schema reconciliation (schema-drift killer).
 *
 * WHY: production repeatedly broke because deployed code expected a
 * newer schema than the database had:
 *   - legacy tables created before the repo existed are never upgraded
 *     by CREATE TABLE IF NOT EXISTS,
 *   - code updates arrive (cron git reset) while SQL migrations lag.
 *
 * This service knows the exact column contract every mezmur query
 * relies on. report() lists the drift; apply() closes it with guarded,
 * idempotent ALTER/CREATE statements (safe to run any number of times).
 * Exposed via action=schema (GET, report) and action=migrate
 * (POST + CSRF, apply) in admin/api_mezmur.php, and via ?diag=2.
 */

namespace App\Services;

require_once __DIR__ . '/MezmurSchemaCapabilities.php';

final class MezmurSchemaReconciler
{
    /** table => column => column DDL (the contract the queries rely on) */
    public const COLUMNS = [
        'mezmur_hymns' => [
            'title'      => "VARCHAR(255) NOT NULL DEFAULT ''",
            'category'   => "VARCHAR(50) NOT NULL DEFAULT 'general'",
            'lyrics'     => "LONGTEXT DEFAULT NULL",
            'status'     => "ENUM('active','archived') NOT NULL DEFAULT 'active'",
            // 030: fields used by the taxonomy filters.  These are listed
            // here so a legacy table cannot make a list request fail.
            'length'     => "ENUM('long','short') NOT NULL DEFAULT 'long'",
            'language'   => "ENUM('geez','amharic') NOT NULL DEFAULT 'amharic'",
            'created_by' => "INT UNSIGNED DEFAULT NULL",
            'updated_by' => "INT UNSIGNED DEFAULT NULL",
            'created_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP",
            'updated_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP",
            // 025: offline-first sync — monotonic row version + delta index.
            'revision'   => "INT UNSIGNED NOT NULL DEFAULT 1",
        ],
        'mezmur_categories' => [
            'name'       => "VARCHAR(50) NOT NULL",
            'parent_id'  => "INT UNSIGNED NULL DEFAULT NULL",
            'image_path' => "VARCHAR(255) NULL DEFAULT NULL",
            'gradient_start' => "CHAR(9) NULL DEFAULT NULL",
            'gradient_end' => "CHAR(9) NULL DEFAULT NULL",
            'sort_order' => "INT NOT NULL DEFAULT 0",
            'is_active'  => "TINYINT(1) NOT NULL DEFAULT 1",
            'created_by' => "INT UNSIGNED DEFAULT NULL",
            'created_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP",
            'updated_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP",
        ],
        // 030/037 taxonomy capabilities.  Keeping the join tables in the
        // same reconciler prevents the classic table-present/column-missing
        // split-brain deployment.
        'mezmur_hymn_categories' => [
            'hymn_id' => "BIGINT UNSIGNED NOT NULL",
            'category_id' => "INT UNSIGNED NOT NULL",
        ],
        'mezmur_zemarians' => [
            'name' => "VARCHAR(100) NOT NULL",
            'name_am' => "VARCHAR(100) DEFAULT NULL",
            'image_path' => "VARCHAR(255) NULL DEFAULT NULL",
            'sort_order' => "INT NOT NULL DEFAULT 0",
            'is_active' => "TINYINT(1) NOT NULL DEFAULT 1",
            'created_by' => "INT UNSIGNED DEFAULT NULL",
            'created_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP",
            'updated_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP",
        ],
        'mezmur_hymn_zemarians' => [
            'hymn_id' => "BIGINT UNSIGNED NOT NULL",
            'zemarian_id' => "INT UNSIGNED NOT NULL",
        ],
        'mezmur_days' => [
            'attendance_date' => "DATE DEFAULT NULL",
            'program_type'    => "VARCHAR(50) NOT NULL DEFAULT 'rehearsal'",
            'title'           => "VARCHAR(255) DEFAULT NULL",
            'notes'           => "VARCHAR(500) DEFAULT NULL",
            'created_by'      => "INT UNSIGNED DEFAULT NULL",
            'created_at'      => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP",
        ],
        'mezmur_attendance' => [
            'session_id'      => "BIGINT UNSIGNED DEFAULT NULL",
            'attendance_date' => "DATE DEFAULT NULL",
            'member_id'       => "INT UNSIGNED NOT NULL",
            'status'          => "ENUM('present','late','absent','excused') NOT NULL DEFAULT 'present'",
            'notes'           => "VARCHAR(500) DEFAULT NULL",
            'marked_by'       => "INT UNSIGNED DEFAULT NULL",
            'marked_at'       => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP",
        ],
        'mezmur_attendance_audit' => [
            'session_id' => "BIGINT UNSIGNED DEFAULT NULL",
            'actor_id'   => "INT UNSIGNED DEFAULT NULL",
            'action'     => "VARCHAR(40) NOT NULL",
            'details'    => "VARCHAR(500) DEFAULT NULL",
            'created_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP",
        ],
        'mezmur_submissions' => [
            'attendance_date' => "DATE NOT NULL",
            'section'         => "VARCHAR(64) NOT NULL",
            'taker_id'        => "INT UNSIGNED DEFAULT NULL",
            'status'          => "VARCHAR(20) NOT NULL DEFAULT 'draft'",
            'member_count'    => "INT NOT NULL DEFAULT 0",
            'present_count'   => "INT NOT NULL DEFAULT 0",
            'late_count'      => "INT NOT NULL DEFAULT 0",
            'absent_count'    => "INT NOT NULL DEFAULT 0",
            'excused_count'   => "INT NOT NULL DEFAULT 0",
            'client_op_id'    => "VARCHAR(64) DEFAULT NULL",
            'submitted_at'    => "DATETIME DEFAULT NULL",
            'reviewed_by'     => "INT UNSIGNED DEFAULT NULL",
            'reviewed_at'     => "DATETIME DEFAULT NULL",
            'review_notes'    => "VARCHAR(500) DEFAULT NULL",
        ],
    ];

    /**
     * P25: FULLTEXT indexes are deliberately NO LONGER created — MariaDB
     * InnoDB FULLTEXT cannot tokenize Ge'ez script and one observed
     * CREATE FULLTEXT INDEX build returned 0 matches silently. Search
     * uses the mezmur_hymn_words inverted index instead (sql/032,
     * maintained by MezmurHymnService::reindexHymnWords on every save
     * and backfilled by apply()). Existing FT indexes are left in place
     * (harmless) but nothing reads them anymore.
     */
    public const INDEXES = [];

    /** Operator-facing source hints for the drift report. */
    public const MIGRATION_HINTS = [
        'mezmur_hymns' => 'sql/021_mezmur_department.sql + sql/025_mezmur_hymn_offline.sql + sql/030_mezmur_taxonomy.sql',
        'mezmur_categories' => 'sql/025_mezmur_hymn_offline.sql + sql/034_mezmur_subcategories.sql + sql/035_mezmur_category_gradient.sql',
        'mezmur_hymn_categories' => 'sql/030_mezmur_taxonomy.sql',
        'mezmur_zemarians' => 'sql/030_mezmur_taxonomy.sql',
        'mezmur_zemarians.image_path' => 'sql/037_zemarian_images.sql',
        'mezmur_hymn_zemarians' => 'sql/030_mezmur_taxonomy.sql',
        'mezmur_days' => 'sql/022_mezmur_attendance.sql + sql/023_mezmur_date_attendance.sql',
        'mezmur_attendance' => 'sql/022_mezmur_attendance.sql + sql/023_mezmur_date_attendance.sql',
        'mezmur_attendance_audit' => 'sql/023_mezmur_date_attendance.sql',
        'mezmur_submissions' => 'sql/024_mezmur_submissions.sql',
    ];

    public static function migrationHint(string $table, ?string $column = null): string
    {
        $key = $column === null ? $table : $table . '.' . $column;
        return self::MIGRATION_HINTS[$key] ?? self::MIGRATION_HINTS[$table] ?? 'the numbered Mezmur SQL migrations';
    }

    /** Minimal CREATE for tables that do not exist at all. */
    private const CREATE = [
        'mezmur_hymns' => "CREATE TABLE `mezmur_hymns` (
            `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            `title` VARCHAR(255) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_hymn_words' => "CREATE TABLE `mezmur_hymn_words` (
            `word` VARBINARY(80) NOT NULL,
            `hymn_id` BIGINT UNSIGNED NOT NULL,
            PRIMARY KEY (`word`, `hymn_id`),
            KEY `idx_mhw_hymn` (`hymn_id`)
        ) ENGINE=InnoDB",
        'mezmur_days' => "CREATE TABLE `mezmur_days` (
            `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_attendance' => "CREATE TABLE `mezmur_attendance` (
            `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_attendance_audit' => "CREATE TABLE `mezmur_attendance_audit` (
            `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_submissions' => "CREATE TABLE `mezmur_submissions` (
            `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_categories' => "CREATE TABLE `mezmur_categories` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(50) NOT NULL,
            `parent_id` INT UNSIGNED NULL DEFAULT NULL,
            `image_path` VARCHAR(255) NULL DEFAULT NULL,
            `gradient_start` CHAR(9) NULL DEFAULT NULL,
            `gradient_end` CHAR(9) NULL DEFAULT NULL,
            `sort_order` INT NOT NULL DEFAULT 0,
            `is_active` TINYINT(1) NOT NULL DEFAULT 1,
            `created_by` INT UNSIGNED DEFAULT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uq_mc_parent_name` (`parent_id`, `name`),
            KEY `idx_mc_parent` (`parent_id`),
            CONSTRAINT `fk_mc_parent` FOREIGN KEY (`parent_id`) REFERENCES `mezmur_categories` (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_hymn_categories' => "CREATE TABLE `mezmur_hymn_categories` (
            `hymn_id` BIGINT UNSIGNED NOT NULL,
            `category_id` INT UNSIGNED NOT NULL,
            PRIMARY KEY (`hymn_id`, `category_id`),
            KEY `idx_mhc_category` (`category_id`),
            CONSTRAINT `fk_mhc_hymn` FOREIGN KEY (`hymn_id`) REFERENCES `mezmur_hymns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `fk_mhc_category` FOREIGN KEY (`category_id`) REFERENCES `mezmur_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_zemarians' => "CREATE TABLE `mezmur_zemarians` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(100) NOT NULL,
            `name_am` VARCHAR(100) DEFAULT NULL,
            `image_path` VARCHAR(255) NULL DEFAULT NULL,
            `sort_order` INT NOT NULL DEFAULT 0,
            `is_active` TINYINT(1) NOT NULL DEFAULT 1,
            `created_by` INT UNSIGNED DEFAULT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uq_mezmur_zemarians_name` (`name`),
            KEY `idx_mezmur_zemarians_active` (`is_active`, `sort_order`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
        'mezmur_hymn_zemarians' => "CREATE TABLE `mezmur_hymn_zemarians` (
            `hymn_id` BIGINT UNSIGNED NOT NULL,
            `zemarian_id` INT UNSIGNED NOT NULL,
            PRIMARY KEY (`hymn_id`, `zemarian_id`),
            KEY `idx_mhz_zemarian` (`zemarian_id`),
            CONSTRAINT `fk_mhz_hymn` FOREIGN KEY (`hymn_id`) REFERENCES `mezmur_hymns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `fk_mhz_zemarian` FOREIGN KEY (`zemarian_id`) REFERENCES `mezmur_zemarians` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
    ];

    /**
     * Describe the drift: missing tables and missing columns.
     * @return array{missing_tables:array<string,bool>,missing_columns:array<string,list<string>>}
     */
    public static function report(\mysqli $conn): array
    {
        $missingTables = [];
        $missingColumns = [];
        foreach (self::COLUMNS as $table => $columns) {
            try {
                $r = $conn->query("SELECT 1 FROM `$table` LIMIT 0");
                if ($r === false) { $missingTables[$table] = true; continue; }
                $r->close();
            } catch (\Throwable $e) {
                $missingTables[$table] = true;
                continue;
            }
            try {
                $r = $conn->query("SHOW COLUMNS FROM `$table`");
                $have = [];
                if ($r) {
                    while ($row = $r->fetch_assoc()) { $have[strtolower((string)$row['Field'])] = true; }
                    $r->close();
                }
            } catch (\Throwable $e) {
                $missingTables[$table] = true;
                continue;
            }
            $missing = [];
            foreach ($columns as $col => $_ddl) {
                if (!isset($have[strtolower($col)])) { $missing[] = $col; }
            }
            if ($missing) { $missingColumns[$table] = $missing; }
        }
        $missingIndexes = [];
        foreach (self::INDEXES as $table => $indexes) {
            if (isset($missingTables[$table])) { continue; }
            foreach ($indexes as $name => $_cols) {
                try {
                    $r = $conn->query("SHOW INDEX FROM `$table` WHERE Key_name = '" . $conn->real_escape_string($name) . "'");
                    $has = $r ? (bool)$r->fetch_assoc() : false;
                    if ($r) { $r->close(); }
                    if (!$has) { $missingIndexes[$table][] = $name; }
                } catch (\Throwable $e) {
                    // unreadable -> treat as missing
                    $missingIndexes[$table][] = $name;
                }
            }
        }
        $migrationHints = [];
        foreach ($missingTables as $table => $_missing) {
            $migrationHints[$table] = self::migrationHint($table);
        }
        foreach ($missingColumns as $table => $columns) {
            foreach ($columns as $column) {
                $migrationHints[$table . '.' . $column] = self::migrationHint($table, $column);
            }
        }
        return [
            'missing_tables' => $missingTables,
            'missing_columns' => $missingColumns,
            'missing_indexes' => $missingIndexes,
            'migration_hints' => $migrationHints,
        ];
    }

    /**
     * Close the drift. Every statement is guarded; failures are
     * collected, never thrown. Idempotent by construction.
     * @return array{applied:list<string>,failed:array<string,string>}
     */
    public static function apply(\mysqli $conn): array
    {
        $applied = [];
        $failed = [];
        foreach (self::CREATE as $table => $ddl) {
            try {
                $exists = $conn->query("SELECT 1 FROM `$table` LIMIT 0");
                if ($exists !== false) { $exists->close(); continue; }
            } catch (\Throwable $e) {
                // table missing -> create below
            }
            try {
                if ($conn->query($ddl) === false) {
                    $failed["create:$table"] = (string)$conn->error;
                } else {
                    $applied[] = "created $table";
                }
            } catch (\Throwable $e) {
                $failed["create:$table"] = $e->getMessage();
            }
        }
        foreach (self::COLUMNS as $table => $columns) {
            foreach ($columns as $col => $ddl) {
                try {
                    $r = $conn->query("SHOW COLUMNS FROM `$table` LIKE '" . $conn->real_escape_string($col) . "'");
                    if ($r && $r->fetch_assoc()) { $r->close(); continue; }
                    if ($r) { $r->close(); }
                } catch (\Throwable $e) {
                    continue; // table absent or unreadable -> nothing to do
                }
                $sql = "ALTER TABLE `$table` ADD COLUMN `$col` $ddl";
                try {
                    if ($conn->query($sql) === false) {
                        $failed["alter:$table.$col"] = (string)$conn->error;
                    } else {
                        $applied[] = "added $table.$col";
                    }
                } catch (\Throwable $e) {
                    $failed["alter:$table.$col"] = $e->getMessage();
                }
            }
        }
        // 025's delta-sync cursor index (BTREE, guarded) — keeps
        // change-token pulls index-only on legacy DBs at scale.
        try {
            $r = $conn->query("SHOW INDEX FROM mezmur_hymns WHERE Key_name = 'idx_mezmur_hymns_updated'");
            $has = $r ? (bool)$r->fetch_assoc() : false;
            if ($r) { $r->close(); }
            if (!$has) {
                $sql = "ALTER TABLE mezmur_hymns ADD KEY `idx_mezmur_hymns_updated` (`updated_at`, `id`)";
                if ($conn->query($sql) === false) {
                    $failed['index:idx_mezmur_hymns_updated'] = (string)$conn->error;
                } else {
                    $applied[] = 'added index idx_mezmur_hymns_updated';
                }
            }
        } catch (\Throwable $e) {
            // table absent -> nothing to do
        }
        // 031's storage-level title uniqueness (MZ-6): the SELECT-then-
        // INSERT dup check loses under concurrency; a real UNIQUE key
        // settles it. Skipped (and reported) when legacy duplicates exist.
        try {
            $r = $conn->query("SHOW INDEX FROM mezmur_hymns WHERE Key_name = 'uq_mezmur_hymns_title'");
            $has = $r ? (bool)$r->fetch_assoc() : false;
            if ($r) { $r->close(); }
            if (!$has) {
                $d = $conn->query(
                    "SELECT LOWER(title) AS t, COUNT(*) AS c FROM mezmur_hymns GROUP BY LOWER(title) HAVING c > 1 LIMIT 5"
                );
                $dupes = [];
                if ($d) {
                    while ($row = $d->fetch_assoc()) { $dupes[] = $row['t'] . '×' . $row['c']; }
                    $d->close();
                }
                if ($dupes) {
                    $failed['index:uq_mezmur_hymns_title'] =
                        'duplicate hymn titles must be merged first: ' . implode(', ', $dupes);
                } elseif ($conn->query("ALTER TABLE mezmur_hymns ADD UNIQUE KEY `uq_mezmur_hymns_title` (`title`)") === false) {
                    $failed['index:uq_mezmur_hymns_title'] = (string)$conn->error;
                } else {
                    $applied[] = 'added unique index uq_mezmur_hymns_title (title)';
                }
            }
        } catch (\Throwable $e) {
            // table absent -> nothing to do
        }
        // 024's excused-status guarantee: extend the enum if missing
        try {
            $r = $conn->query("SHOW COLUMNS FROM mezmur_attendance LIKE 'status'");
            $col = $r ? $r->fetch_assoc() : null;
            if ($r) { $r->close(); }
            if ($col && strpos((string)($col['Type'] ?? ''), 'excused') === false) {
                $sql = "ALTER TABLE mezmur_attendance MODIFY COLUMN status ENUM('present','late','absent','excused') NOT NULL DEFAULT 'present'";
                if ($conn->query($sql) === false) {
                    $failed['enum:status'] = (string)$conn->error;
                } else {
                    $applied[] = 'mezmur_attendance.status now includes excused';
                }
            }
        } catch (\Throwable $e) {
            // table absent -> nothing to do
        }
        // 024's nullable-session_id guarantee (guarded, same intent)
        try {
            $r = $conn->query("SHOW COLUMNS FROM mezmur_attendance LIKE 'session_id'");
            $col = $r ? $r->fetch_assoc() : null;
            if ($r) { $r->close(); }
            if ($col && ($col['Null'] ?? '') !== 'YES') {
                if ($conn->query("ALTER TABLE mezmur_attendance MODIFY COLUMN session_id BIGINT UNSIGNED DEFAULT NULL") === false) {
                    $failed['nullable:session_id'] = (string)$conn->error;
                } else {
                    $applied[] = 'mezmur_attendance.session_id now nullable';
                }
            }
        } catch (\Throwable $e) {
            // table absent -> nothing to do
        }
        // 025's canonical categories: UNIQUE(name) + idempotent seed.
        // Legacy tables created before the unique key existed may hold
        // duplicate seed rows — dedupe first, then add the key, then
        // INSERT IGNORE the canonical three.
        try {
            $r = $conn->query("SHOW INDEX FROM mezmur_categories WHERE Key_name = 'uq_mezmur_categories_name'");
            $hasUnique = $r ? (bool)$r->fetch_assoc() : false;
            if ($r) { $r->close(); }
            if (!$hasUnique) {
                // Keep the lowest id per name; drop later duplicates.
                $conn->query(
                    "DELETE c1 FROM mezmur_categories c1
                     JOIN mezmur_categories c2
                       ON c2.name = c1.name AND c2.id < c1.id"
                );
                if ($conn->query("ALTER TABLE mezmur_categories ADD UNIQUE KEY `uq_mezmur_categories_name` (`name`)") === false) {
                    $failed['index:uq_mezmur_categories_name'] = (string)$conn->error;
                } else {
                    $applied[] = 'mezmur_categories.name now unique (duplicates removed)';
                }
            }
            $seed = [
                ['ህናት', 1],
                ['ማዕከዊያን', 2],
                ['ጣቶች', 3],
            ];
            $stmt = $conn->prepare("INSERT IGNORE INTO mezmur_categories (name, sort_order) VALUES (?, ?)");
            if ($stmt) {
                $added = 0;
                foreach ($seed as [$name, $order]) {
                    $stmt->bind_param('si', $name, $order);
                    if ($stmt->execute() && $stmt->affected_rows > 0) {
                        $added++;
                    }
                }
                $stmt->close();
                if ($added > 0) {
                    $applied[] = "seeded $added canonical mezmur categor(y/ies)";
                }
            }
        } catch (\Throwable $e) {
            // table absent or seed already present -> nothing to do
        }
        // P25: keep the word index warm — backfill every hymn that has no
        // word rows yet (bounded rounds, idempotent).
        try {
            $done = 0;
            $rounds = 0;
            $n = MezmurHymnService::backfillHymnWords($conn, 1000);
            while ($n > 0 && $rounds < 200) {
                $done += $n;
                $rounds++;
                $n = MezmurHymnService::backfillHymnWords($conn, 1000);
            }
            if ($done > 0) {
                $applied[] = "word index backfilled for $done hymn(s)";
            }
        } catch (\Throwable $e) {
            $failed['words:backfill'] = $e->getMessage();
        }

        // DDL may have created a previously absent optional table/column.
        // Invalidate the per-connection capability snapshot before the
        // response computes drift_now.
        MezmurSchemaCapabilities::reset($conn);
        return ['applied' => $applied, 'failed' => $failed];
    }
}
