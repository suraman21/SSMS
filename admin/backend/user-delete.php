<?php
if (session_status() === PHP_SESSION_NONE) session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../users.php');
    exit;
}

if (!isset($_SESSION['admin_logged_in']) || $_SESSION['admin_logged_in'] !== true) {
    header('Location: ../index.php');
    exit;
}

if (($_SESSION['admin_role'] ?? '') !== 'super_admin') {
    header('Location: ../users.php?error=' . urlencode('Access denied.'));
    exit;
}

require __DIR__ . '/config.php';

$deleteUserId       = isset($_POST['delete_user_id']) ? (int)$_POST['delete_user_id'] : 0;
$superadminPassword = isset($_POST['superadmin_password']) ? $_POST['superadmin_password'] : '';

if ($deleteUserId <= 0 || $superadminPassword === '') {
    header('Location: ../users.php?error=' . urlencode('Invalid delete request.'));
    exit;
}

// don't allow deleting self
$currentAdminId = (int)($_SESSION['admin_id'] ?? 0);
if ($deleteUserId === $currentAdminId) {
    header('Location: ../users.php?error=' . urlencode('You cannot delete your own account.'));
    exit;
}

try {
    // verify super admin password
    $stmt = $pdo->prepare("SELECT password_hash FROM users WHERE id = :id LIMIT 1");
    $stmt->execute([':id' => $currentAdminId]);
    $admin = $stmt->fetch();

    if (!$admin || !password_verify($superadminPassword, $admin['password_hash'])) {
        header('Location: ../users.php?error=' . urlencode('Incorrect password. User not deleted.') . '&delete_id=' . $deleteUserId);
        exit;
    }

    // delete target user
    $stmt = $pdo->prepare("DELETE FROM users WHERE id = :id LIMIT 1");
    $stmt->execute([':id' => $deleteUserId]);

    header('Location: ../users.php?success=' . urlencode('User deleted successfully.'));
    exit;

} catch (Exception $e) {
    header('Location: ../users.php?error=' . urlencode('Error deleting user. Please try again.') . '&delete_id=' . $deleteUserId);
    exit;
}
