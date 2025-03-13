<?php
$servidor = "localhost"; // No cambies esto
$usuario = "root"; // Usuario por defecto de XAMPP
$contraseña = ""; // Deja vacío si no estableciste una contraseña
$nombre_base_datos = "proyecto-pasteleria"; // Cambia esto al nombre de tu base de datos

// Crear conexión
$conn = new mysqli($servidor, $usuario, $contraseña, $nombre_base_datos);

// Verificar conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
} else {
    echo "Conexión exitosa a la base de datos.";
}
?>
