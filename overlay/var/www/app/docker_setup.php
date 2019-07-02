<?php

// Based on https://git.tt-rss.org/fox/tt-rss/src/master/install/index.php
// For the case $op == 'installschema'

function sanity_check($db_type) {
	$errors = array();

	if (version_compare(PHP_VERSION, '5.6.0', '<')) {
		array_push($errors, "PHP version 5.6.0 or newer required. You're using " . PHP_VERSION . ".");
	}

	if (!function_exists("curl_init") && !ini_get("allow_url_fopen")) {
		array_push($errors, "PHP configuration option allow_url_fopen is disabled, and CURL functions are not present. Either enable allow_url_fopen or install PHP extension for CURL.");
	}

	if (!function_exists("json_encode")) {
		array_push($errors, "PHP support for JSON is required, but was not found.");
	}

	if (!class_exists("PDO")) {
		array_push($errors, "PHP support for PDO is required but was not found.");
	}

	if (!function_exists("mb_strlen")) {
		array_push($errors, "PHP support for mbstring functions is required but was not found.");
	}

	if (!function_exists("hash")) {
		array_push($errors, "PHP support for hash() function is required but was not found.");
	}

	if (!function_exists("iconv")) {
		array_push($errors, "PHP support for iconv is required to handle multiple charsets.");
	}

	if (ini_get("safe_mode")) {
		array_push($errors, "PHP safe mode setting is obsolete and not supported by tt-rss.");
	}

	if (!class_exists("DOMDocument")) {
		array_push($errors, "PHP support for DOMDocument is required, but was not found.");
	}

	return $errors;
}

function pdo_connect($host, $user, $pass, $db, $type, $port = false) {

    $db_port = $port ? ';port=' . $port : '';
    $db_host = $host ? ';host=' . $host : '';

    try {
        $pdo = new PDO($type . ':dbname=' . $db . $db_host . $db_port,
            $user,
            $pass);

        return $pdo;
    } catch (Exception $e) {
        echo "Unable to connect to database using specified parameters : " .  $e->getMessage() . PHP_EOL;
        return null;
    }
}

if (file_exists("/var/www/app/config.php")) {
    echo "Loading config.php" . PHP_EOL;
    require_once "/var/www/app/config.php";

    $pdo = pdo_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_TYPE, DB_PORT);
    if (!$pdo) {
        exit(2);
    }
    
    echo "Running sanity check.";
    $errors = sanity_check(DB_TYPE);
    if (count($errors) > 0) {
			foreach ($errors as $error) {
  			echo "$error";
			}
		}

    echo "Connected to the database" . PHP_EOL;

    $res = $pdo->query("SELECT true FROM ttrss_feeds");
    if ($res && $res->fetch()) {
        echo "Some tt-rss data already exists in this database, skipping database installation" . PHP_EOL;
        exit(0);
    }
    echo "tt-rss data not found, initializing the database" . PHP_EOL;

    $lines = explode(";", preg_replace("/[\r\n]/", "",
        file_get_contents("/var/www/app/schema/ttrss_schema_".basename(DB_TYPE).".sql")));

    $dbInitError = 0;
    foreach ($lines as $line) {
        if (strpos($line, "--") !== 0 && $line) {
            $res = $pdo->query($line);

            if (!$res) {
                echo "Query: $line" . PHP_EOL;
                echo "Error: " . implode(", ", $this->pdo->errorInfo()) . PHP_EOL;
                $dbInitError++;
            }
        }
    }

    if($dbInitError == 0) {
        echo "Database initialization completed." . PHP_EOL;
        exit(0);
    } else {
        echo "Database initialization failed." . PHP_EOL;
        exit(1);
    }
}
