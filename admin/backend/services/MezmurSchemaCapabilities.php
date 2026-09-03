<?php
/**
 * Read-only capability probes for the Mezmur schema.
 *
 * The Mezmur module is deployed independently from its numbered SQL
 * migrations in some supported installations.  Callers must therefore never
 * infer a feature from the presence of a parent table alone.  This class is
 * the single, allow-listed probe surface for optional tables and columns.
 *
 * Probes are prepared against information_schema and cached per mysqli
 * connection for the lifetime of the request.  Missing objects, restricted
 * metadata permissions, and old MariaDB behaviour all fail closed to false;
 * they are not allowed to become a raw SQL error in a catalogue read.
 */

namespace App\Services;

final class MezmurSchemaCapabilities
{
    /** Only identifiers owned by this module may reach the metadata queries. */
    private const TABLES = [
        'mezmur_hymns' => true,
        'mezmur_categories' => true,
        'mezmur_hymn_categories' => true,
        'mezmur_zemarians' => true,
        'mezmur_hymn_zemarians' => true,
        'mezmur_hymn_words' => true,
    ];

    /** Column allow-list also prevents accidental identifier injection. */
    private const COLUMNS = [
        'mezmur_hymns' => [
            'id' => true,
            'title' => true,
            'category' => true,
            'lyrics' => true,
            'status' => true,
            'length' => true,
            'language' => true,
            'revision' => true,
            'created_by' => true,
            'updated_by' => true,
            'created_at' => true,
            'updated_at' => true,
        ],
        'mezmur_categories' => [
            'id' => true,
            'name' => true,
            'parent_id' => true,
            'image_path' => true,
            'gradient_start' => true,
            'gradient_end' => true,
            'sort_order' => true,
            'is_active' => true,
            'created_by' => true,
            'updated_at' => true,
        ],
        'mezmur_hymn_categories' => [
            'hymn_id' => true,
            'category_id' => true,
        ],
        'mezmur_zemarians' => [
            'id' => true,
            'name' => true,
            'name_am' => true,
            'image_path' => true,
            'sort_order' => true,
            'is_active' => true,
            'created_by' => true,
            'updated_at' => true,
        ],
        'mezmur_hymn_zemarians' => [
            'hymn_id' => true,
            'zemarian_id' => true,
        ],
        'mezmur_hymn_words' => [
            'word' => true,
            'hymn_id' => true,
        ],
    ];

    /** @var array<string,array<string,bool>> */
    private static array $tableCache = [];

    /** @var array<string,array<string,bool>> */
    private static array $columnCache = [];

    /** @var array<string,array<string,bool>> */
    private static array $lengthCache = [];

    private static function connectionKey(\mysqli $conn): string
    {
        return spl_object_hash($conn);
    }

    public static function hasTable(\mysqli $conn, string $table): bool
    {
        if (!isset(self::TABLES[$table])) {
            return false;
        }

        $key = self::connectionKey($conn);
        if (array_key_exists($table, self::$tableCache[$key] ?? [])) {
            return self::$tableCache[$key][$table];
        }

        $exists = false;
        try {
            $stmt = $conn->prepare(
                'SELECT 1 FROM information_schema.TABLES '
                . 'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? LIMIT 1'
            );
            if ($stmt) {
                $stmt->bind_param('s', $table);
                $stmt->execute();
                $stmt->store_result();
                $exists = $stmt->num_rows > 0;
                $stmt->close();
            }
        } catch (\Throwable $e) {
            // A capability probe is deliberately fail-closed.  The caller
            // will return a compatibility response instead of leaking SQL.
            $exists = false;
        }

        if (!isset(self::$tableCache[$key])) {
            self::$tableCache[$key] = [];
        }
        self::$tableCache[$key][$table] = $exists;
        return $exists;
    }

    public static function hasColumn(\mysqli $conn, string $table, string $column): bool
    {
        if (!isset(self::COLUMNS[$table][$column])) {
            return false;
        }

        $key = self::connectionKey($conn);
        $cacheKey = $table . '.' . $column;
        if (array_key_exists($cacheKey, self::$columnCache[$key] ?? [])) {
            return self::$columnCache[$key][$cacheKey];
        }

        $exists = false;
        try {
            $stmt = $conn->prepare(
                'SELECT 1 FROM information_schema.COLUMNS '
                . 'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? '
                . 'AND COLUMN_NAME = ? LIMIT 1'
            );
            if ($stmt) {
                $stmt->bind_param('ss', $table, $column);
                $stmt->execute();
                $stmt->store_result();
                $exists = $stmt->num_rows > 0;
                $stmt->close();
            }
        } catch (\Throwable $e) {
            $exists = false;
        }

        if (!isset(self::$columnCache[$key])) {
            self::$columnCache[$key] = [];
        }
        self::$columnCache[$key][$cacheKey] = $exists;
        return $exists;
    }

    /**
     * DDL changes made by the explicit admin reconciler must be visible to
     * later probes in the same request.
     */
    /** True when a character column is wide enough for the advertised value. */
    public static function columnLengthAtLeast(\mysqli $conn, string $table, string $column, int $minimum): bool
    {
        if (!isset(self::COLUMNS[$table][$column]) || $minimum < 0) return false;
        $key = self::connectionKey($conn);
        $cacheKey = $table . '.' . $column . '>=' . $minimum;
        if (array_key_exists($cacheKey, self::$lengthCache[$key] ?? [])) {
            return self::$lengthCache[$key][$cacheKey];
        }
        $ok = false;
        try {
            $stmt = $conn->prepare(
                'SELECT CHARACTER_MAXIMUM_LENGTH FROM information_schema.COLUMNS '
                . 'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? '
                . 'AND COLUMN_NAME = ? LIMIT 1'
            );
            if ($stmt) {
                $stmt->bind_param('ss', $table, $column);
                $stmt->execute();
                $stmt->bind_result($length);
                if ($stmt->fetch() && $length !== null) $ok = (int)$length >= $minimum;
                $stmt->close();
            }
        } catch (\Throwable $e) {
            $ok = false;
        }
        if (!isset(self::$lengthCache[$key])) self::$lengthCache[$key] = [];
        self::$lengthCache[$key][$cacheKey] = $ok;
        return $ok;
    }

    public static function reset(\mysqli $conn): void
    {
        $key = self::connectionKey($conn);
        unset(self::$tableCache[$key], self::$columnCache[$key], self::$lengthCache[$key]);
    }
}
