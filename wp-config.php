<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
require_once __DIR__ . '/vendor/autoload.php';

use Aws\SecretsManager\SecretsManagerClient;
use Aws\Exception\AwsException;

$client = new SecretsManagerClient([
    'version' => '2017-10-17',
    'region'  => 'us-east-1',
]);

$secret_name = 'prod/wordpress/rds';

try {
    $result = $client->getSecretValue([
        'SecretId' => $secret_name,
    ]);

    if (!isset($result['SecretString'])) {
        throw new Exception('SecretString is empty');
    }

    $credentials = json_decode($result['SecretString'], true);

    define('DB_NAME',     $credentials['database_name']);
    define('DB_USER',     $credentials['database_username']);
    define('DB_PASSWORD', $credentials['database_password']);
    define('DB_HOST',     $credentials['database_host']);

} catch (AwsException $e) {
    die('Error retrieving secret: ' . $e->getAwsErrorMessage());
}

define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'l^e:r9Yu/0o~jC6jm,m*bbrd8$l [H1HaT*WV6ZeX;hD9RZgR;:g~~Ovg[Id&;Oz' );
define( 'SECURE_AUTH_KEY',  '8Cu_LfJg_a~Z-/X)n2y c35^CY5{h%{8hy%8a}W#Rw4TBuE(IBVoo?h#3!D`t9|w' );
define( 'LOGGED_IN_KEY',    '7L|h6gTTK2cYl9waWkv=/$%R43WrrK.$cRrY^x_/~~ohtQQA<b<<xGW&u-%5#qF;' );
define( 'NONCE_KEY',        '=j7VD~#-pe5_mY7X=+S)UWyM!.B{BX+UK-{#`UE+1FFL0$R^U6:UaIP`2HbTd~~}' );
define( 'AUTH_SALT',        '-gk?0!CThM R5d?r>xbBzl#{aF75d!Ni0>zou x`TUk7hYEor.~;>R,n1ysH*{8B' );
define( 'SECURE_AUTH_SALT', 'k B9Bo5Vvc+N-o>Z<!*G);A1;GCCjKj?(LFi:Ei*et|H96GL~5/9`{L-uY1Wj;#r' );
define( 'LOGGED_IN_SALT',   '}S<xda-:H}8,&U6jf1nY5{pvn%On6&v9K2? xDv93f`5+}rm$n8Sw3M,@%v~xX!>' );
define( 'NONCE_SALT',       '#O#PB3*]MCFw/HP]b0p14G*N>8wNb,[jrBn=Tqqy2V?-Vm}?F??TCt0|%X$xh&4N' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
