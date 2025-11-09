<?php
require_once 'config.php';

$error_message = '';
$success_message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $conn = getConnection();
    
    $nombre = $_POST['nombre'];
    $apellido = $_POST['apellido'];
    $email = $_POST['email'];
    $telefono = $_POST['telefono'];
    $tipo_miembro = $_POST['tipo_miembro'];
    $estado = $_POST['estado'];
    
    $sql = "INSERT INTO miembros (nombre, apellido, email, telefono, tipo_miembro, estado) 
            VALUES (:nombre, :apellido, :email, :telefono, :tipo_miembro, :estado)";
    
    $stmt = oci_parse($conn, $sql);
    
    oci_bind_by_name($stmt, ':nombre', $nombre);
    oci_bind_by_name($stmt, ':apellido', $apellido);
    oci_bind_by_name($stmt, ':email', $email);
    oci_bind_by_name($stmt, ':telefono', $telefono);
    oci_bind_by_name($stmt, ':tipo_miembro', $tipo_miembro);
    oci_bind_by_name($stmt, ':estado', $estado);
    
    if (oci_execute($stmt)) {
        oci_commit($conn);
        $success_message = "Miembro creado exitosamente";
        // Redirigir después de 2 segundos
        header("refresh:2;url=index.php");
    } else {
        $error = oci_error($stmt);
        $error_message = "Error al crear miembro: " . $error['message'];
    }
    
    oci_free_statement($stmt);
    closeConnection($conn);
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Nuevo Miembro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-primary">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">
                <i class="bi bi-building"></i> Sistema Coworking
            </span>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <?php if ($success_message): ?>
                    <div class="alert alert-success">
                        <i class="bi bi-check-circle"></i> <?php echo $success_message; ?>
                        <p class="mb-0 mt-2">Redirigiendo a la lista de miembros...</p>
                    </div>
                <?php endif; ?>
                
                <?php if ($error_message): ?>
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle"></i> <?php echo $error_message; ?>
                    </div>
                <?php endif; ?>

                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="bi bi-person-plus"></i> Crear Nuevo Miembro</h4>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nombre" class="form-label">
                                        <i class="bi bi-person"></i> Nombre *
                                    </label>
                                    <input type="text" class="form-control" id="nombre" 
                                           name="nombre" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="apellido" class="form-label">
                                        <i class="bi bi-person"></i> Apellido *
                                    </label>
                                    <input type="text" class="form-control" id="apellido" 
                                           name="apellido" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">
                                        <i class="bi bi-envelope"></i> Email *
                                    </label>
                                    <input type="email" class="form-control" id="email" 
                                           name="email" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="telefono" class="form-label">
                                        <i class="bi bi-telephone"></i> Teléfono
                                    </label>
                                    <input type="text" class="form-control" id="telefono" 
                                           name="telefono">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="tipo_miembro" class="form-label">
                                        <i class="bi bi-tag"></i> Tipo de Miembro *
                                    </label>
                                    <select class="form-select" id="tipo_miembro" 
                                            name="tipo_miembro" required>
                                        <option value="">Seleccione...</option>
                                        <option value="individual">Individual</option>
                                        <option value="empresa">Empresa</option>
                                        <option value="freelancer">Freelancer</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="estado" class="form-label">
                                        <i class="bi bi-check-circle"></i> Estado *
                                    </label>
                                    <select class="form-select" id="estado" name="estado" required>
                                        <option value="activo" selected>Activo</option>
                                        <option value="inactivo">Inactivo</option>
                                        <option value="suspendido">Suspendido</option>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="index.php" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Volver
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save"></i> Guardar Miembro
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
