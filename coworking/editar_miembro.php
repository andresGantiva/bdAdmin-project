<?php
require_once 'config.php';

$error_message = '';
$success_message = '';
$miembro = null;

// Obtener datos del miembro
if (isset($_GET['id'])) {
    $conn = getConnection();
    $id = $_GET['id'];
    
    $sql = "SELECT * FROM miembros WHERE id_miembro = :id";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ':id', $id);
    oci_execute($stmt);
    
    $miembro = oci_fetch_array($stmt, OCI_ASSOC+OCI_RETURN_NULLS);
    
    oci_free_statement($stmt);
    closeConnection($conn);
    
    if (!$miembro) {
        header("Location: index.php");
        exit;
    }
}

// Actualizar datos
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $conn = getConnection();
    
    $id = $_POST['id_miembro'];
    $nombre = $_POST['nombre'];
    $apellido = $_POST['apellido'];
    $email = $_POST['email'];
    $telefono = $_POST['telefono'];
    $tipo_miembro = $_POST['tipo_miembro'];
    $estado = $_POST['estado'];
    
    $sql = "UPDATE miembros SET 
            nombre = :nombre, 
            apellido = :apellido, 
            email = :email, 
            telefono = :telefono, 
            tipo_miembro = :tipo_miembro, 
            estado = :estado 
            WHERE id_miembro = :id";
    
    $stmt = oci_parse($conn, $sql);
    
    oci_bind_by_name($stmt, ':id', $id);
    oci_bind_by_name($stmt, ':nombre', $nombre);
    oci_bind_by_name($stmt, ':apellido', $apellido);
    oci_bind_by_name($stmt, ':email', $email);
    oci_bind_by_name($stmt, ':telefono', $telefono);
    oci_bind_by_name($stmt, ':tipo_miembro', $tipo_miembro);
    oci_bind_by_name($stmt, ':estado', $estado);
    
    if (oci_execute($stmt)) {
        oci_commit($conn);
        $success_message = "Miembro actualizado exitosamente";
        header("refresh:2;url=index.php");
    } else {
        $error = oci_error($stmt);
        $error_message = "Error al actualizar: " . $error['message'];
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
    <title>Editar Miembro</title>
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
                        <p class="mb-0 mt-2">Redirigiendo...</p>
                    </div>
                <?php endif; ?>
                
                <?php if ($error_message): ?>
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle"></i> <?php echo $error_message; ?>
                    </div>
                <?php endif; ?>

                <div class="card shadow">
                    <div class="card-header bg-warning">
                        <h4 class="mb-0"><i class="bi bi-pencil"></i> Editar Miembro</h4>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="">
                            <input type="hidden" name="id_miembro" value="<?php echo $miembro['ID_MIEMBRO']; ?>">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nombre" class="form-label">
                                        <i class="bi bi-person"></i> Nombre *
                                    </label>
                                    <input type="text" class="form-control" id="nombre" 
                                           name="nombre" value="<?php echo htmlspecialchars($miembro['NOMBRE']); ?>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="apellido" class="form-label">
                                        <i class="bi bi-person"></i> Apellido *
                                    </label>
                                    <input type="text" class="form-control" id="apellido" 
                                           name="apellido" value="<?php echo htmlspecialchars($miembro['APELLIDO']); ?>" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">
                                        <i class="bi bi-envelope"></i> Email *
                                    </label>
                                    <input type="email" class="form-control" id="email" 
                                           name="email" value="<?php echo htmlspecialchars($miembro['EMAIL']); ?>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="telefono" class="form-label">
                                        <i class="bi bi-telephone"></i> Teléfono
                                    </label>
                                    <input type="text" class="form-control" id="telefono" 
                                           name="telefono" value="<?php echo htmlspecialchars($miembro['TELEFONO']); ?>">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="tipo_miembro" class="form-label">
                                        <i class="bi bi-tag"></i> Tipo de Miembro *
                                    </label>
                                    <select class="form-select" id="tipo_miembro" name="tipo_miembro" required>
                                        <option value="individual" <?php echo $miembro['TIPO_MIEMBRO'] == 'individual' ? 'selected' : ''; ?>>Individual</option>
                                        <option value="empresa" <?php echo $miembro['TIPO_MIEMBRO'] == 'empresa' ? 'selected' : ''; ?>>Empresa</option>
                                        <option value="freelancer" <?php echo $miembro['TIPO_MIEMBRO'] == 'freelancer' ? 'selected' : ''; ?>>Freelancer</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="estado" class="form-label">
                                        <i class="bi bi-check-circle"></i> Estado *
                                    </label>
                                    <select class="form-select" id="estado" name="estado" required>
                                        <option value="activo" <?php echo $miembro['ESTADO'] == 'activo' ? 'selected' : ''; ?>>Activo</option>
                                        <option value="inactivo" <?php echo $miembro['ESTADO'] == 'inactivo' ? 'selected' : ''; ?>>Inactivo</option>
                                        <option value="suspendido" <?php echo $miembro['ESTADO'] == 'suspendido' ? 'selected' : ''; ?>>Suspendido</option>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="index.php" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancelar
                                </a>
                                <button type="submit" class="btn btn-warning">
                                    <i class="bi bi-save"></i> Actualizar Miembro
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
