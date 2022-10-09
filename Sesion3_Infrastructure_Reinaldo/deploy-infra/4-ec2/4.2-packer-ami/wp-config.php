<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'master' );

/** MySQL database username */
define( 'DB_USER', 'admin' );

/** MySQL database password */
define( 'DB_PASSWORD', 'RDSPASSWD' );

/** MySQL hostname */
define( 'DB_HOST', 'RDSHOST' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in 
again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'x.ceH)(L4zBc;mBm#ZMQ<ZJo)s)WD]rQ8z!Q|YSA`<#rCi(n&x1vNx<8b<9[7YrZ' );
define( 'SECURE_AUTH_KEY',  'B|UVi<6|S>Xu`EN37?Cn=~j.u*^nwyJC<_0x#|`PiHSI!;{Aw-tHwm-ut*?:~N.P' );
define( 'LOGGED_IN_KEY',    '^K/P;:!J/<,d ,{wKs?k7q7m88]6p~1ik.1`;l[X]gAhd`W[>4Kh1-E{ycfU/v}L' );
define( 'NONCE_KEY',        'Hg;<E{#m&+,PsAwW:|,1~0&$q)f>cm_z g:_N3/$ve**Q?JM#u}g0|}>3du>-S8h' );
define( 'AUTH_SALT',        'VLQ|!sV2OZ~XBLG{Xsb/QY4xo2^C}a:D^$U<_<t^MkqxyaD `+m6E~Sm0CQtbAz7' );
define( 'SECURE_AUTH_SALT', '*Uu!<M(1RbzJPuJnGuc<]CLgy8so9./0eQACMO`%HMr]QJ7ZewXKOXNBw3ssEV t' );
define( 'LOGGED_IN_SALT',   'N1rbx]P1j_i+GB!%N)|}47j[0_z;C0J4 y*sA}BPI/cl,FJLgFPT{098iG}_pepH' );
define( 'NONCE_SALT',       '1R/,3T-rW5M&|[(Oa!R+jU9NVM$XBMp;4(h+HaDfpGuYP 0de xy=YSIK_JRU1N]' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
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
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
$_SERVER['HTTPS'] = 'on';