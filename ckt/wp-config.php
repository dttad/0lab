<?php
// Database
define('DB_NAME',     getenv('DB_NAME')     ?: 'ckt_wordpress');
define('DB_USER',     getenv('DB_USER')     ?: 'wordpress');
define('DB_PASSWORD', getenv('DB_PASSWORD') ?: 'wordpress');
define('DB_HOST',     getenv('DB_HOST')     ?: 'db');
define('DB_CHARSET',  'utf8mb4');
define('DB_COLLATE',  '');

$table_prefix = 'ReQR4QjtN_';

// URLs
define('WP_HOME',    getenv('WP_HOME')    ?: 'https://ckt.d4t0.com');
define('WP_SITEURL', getenv('WP_HOME')    ?: 'https://ckt.d4t0.com');

// Trust Cloudflare HTTPS header
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

// Environment
define('WP_ENVIRONMENT_TYPE', getenv('WP_ENV') ?: 'staging');
define('WP_DEBUG',     getenv('WP_DEBUG') === 'true');
define('WP_DEBUG_LOG', WP_DEBUG);

// Auth keys & salts
define('AUTH_KEY',         getenv('AUTH_KEY'));
define('SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY'));
define('LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY'));
define('NONCE_KEY',        getenv('NONCE_KEY'));
define('AUTH_SALT',        getenv('AUTH_SALT'));
define('SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT'));
define('LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT'));
define('NONCE_SALT',       getenv('NONCE_SALT'));

// Paths
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';
