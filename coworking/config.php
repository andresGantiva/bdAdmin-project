<?php
// Configuración de conexión a Oracle Database
define('DB_USERNAME', 'sys');  // Cambia por tu usuario de Oracle
define('DB_PASSWORD', 'sys'); // Cambia por tu contraseña
define('DB_CONNECTION_STRING', 'localhost/db-project'); // localhost/nombre_servicio

// Función para conectar a la base de datos
function getConnection() {
    $conn = oci_connect(DB_USERNAME, DB_PASSWORD, DB_CONNECTION_STRING, 'AL32UTF8');
    
    if (!$conn) {
        $error = oci_error();
        die("Error de conexión a Oracle: " . $error['message']);
    }
    
    return $conn;
}

// Función para cerrar conexión
function closeConnection($conn) {
    if ($conn) {
        oci_close($conn);
    }
}

// Función para ejecutar consultas con manejo de errores
function executeQuery($conn, $sql, $params = []) {
    $stmt = oci_parse($conn, $sql);
    
    if (!$stmt) {
        $error = oci_error($conn);
        return ['success' => false, 'error' => $error['message']];
    }
    
    // Bind de parámetros si existen
    foreach ($params as $key => $value) {
        oci_bind_by_name($stmt, $key, $params[$key]);
    }
    
    $result = oci_execute($stmt);
    
    if (!$result) {
        $error = oci_error($stmt);
        oci_free_statement($stmt);
        return ['success' => false, 'error' => $error['message']];
    }
    
    return ['success' => true, 'statement' => $stmt];
}
?>
