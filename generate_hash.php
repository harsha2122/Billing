<?php

require __DIR__.'/vendor/autoload.php';

$password = '12345678';
$hash = password_hash($password, PASSWORD_BCRYPT);

echo "Password: $password\n";
echo "Hash: $hash\n";
