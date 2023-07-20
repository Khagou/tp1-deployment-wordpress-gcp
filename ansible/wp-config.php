<?php
define( 'DB_NAME', '{{ wordpress_db_name }}' );
define( 'DB_USER', '{{ wordpress_db_user }}' );
define( 'DB_PASSWORD', '{{ wordpress_db_password }}' );
define( 'DB_HOST', '{{ mariadb_instance_ip }}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// define( 'AUTH_KEY',         'put your unique phrase here' );
// define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
// define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
// define( 'NONCE_KEY',        'put your unique phrase here' );
// define( 'AUTH_SALT',        'put your unique phrase here' );
// define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
// define( 'LOGGED_IN_SALT',   'put your unique phrase here' );

$table_prefix = 'wp_';

define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
