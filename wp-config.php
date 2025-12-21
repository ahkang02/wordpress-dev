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
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'root' );

/** Database password */
define( 'DB_PASSWORD', '' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
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
define( 'AUTH_KEY',         '6$aI%l)WrOm3t_fwuDkxpt8[+8$F12I.w,o*h..!w^GEB zq+xe8j7b;>d1/he@%' );
define( 'SECURE_AUTH_KEY',  ',H>=X)2,N+Kd&(Z@t/GC5B,Z-NA kOwE4x7:ZJK66lLvyOMDEvAJQrQVsUC}I!;>' );
define( 'LOGGED_IN_KEY',    '0nci63CAa}JQz6VD@+zT  `8lXDr$Z,6wFtR.PFf-KWV5t48Aq50dd/;]Cs&!b(L' );
define( 'NONCE_KEY',        '2Fg7_-S8@7OtE>IU~va4D14lGmuRF6_W2 eEBll|`fprcTG0Zqk<_i,`@P@)jCUQ' );
define( 'AUTH_SALT',        'tD?+geWP;|V0xG~;.I8`%R:P~?i:SdV^Uvcq5<QKD=.:*>)[~i.o}WNMLj{vm06w' );
define( 'SECURE_AUTH_SALT', 'VA<OfU!+9Bimir~NkTdEi-5ocK,LC!MXGLA}iFlN,38WhH|GQv(Kd_(S#hSTs?/j' );
define( 'LOGGED_IN_SALT',   '1rz5YKSxl{}O3PMro?Tu_M&!,~.Mx#:HhJbq:eQ`:roWbUt3>*RUl{MN5kg/Po7k' );
define( 'NONCE_SALT',       '|,Vsb;Owj&Wy4*YXS[5dedl$k?CH|4,uWJKB#%Hi@CwioAvPAk&W/bA!D%hJ@znu' );

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

