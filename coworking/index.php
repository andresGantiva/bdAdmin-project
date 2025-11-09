<?php
require_once 'config.php';

// Manejar eliminación
if (isset($_GET['delete'])) {
    $conn = getConnection();
    $id = $_GET['delete'];
    
    $sql = "DELETE FROM miembros WHERE id_miembro = :id";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ':id', $id);
    
    if (oci_execute($stmt)) {
        $success_message = "Miembro eliminado exitosamente";
    } else {
        $error = oci_error($stmt);
        $error_message = "Error al eliminar: " . $error['message'];
    }
    
    oci_free_statement($stmt);
    closeConnection($conn);
}

// Obtener lista de miembros
$conn = getConnection();
$sql = "SELECT id_miembro, nombre, apellido, email, telefono, tipo_miembro, estado, 
        TO_CHAR(fecha_registro, 'DD/MM/YYYY') as fecha_registro 
        FROM miembros 
        ORDER BY id_miembro DESC";

$stmt = oci_parse($conn, $sql);
oci_execute($stmt);
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema Coworking - Gestión de Miembros</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { margin-top: 30px; }
        .card { box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .badge { font-size: 0.85em; }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark bg-primary">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">
                <i class="bi bi-building"></i> Sistema Coworking - Gestión Centralizada
            </span>
        </div>
    </nav>

    <div class="container">
        <?php if (isset($success_message)): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> <?php echo $success_message; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>
        
        <?php if (isset($error_message)): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> <?php echo $error_message; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <div class="card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0"><i class="bi bi-people"></i> Gestión de Miembros</h4>
                <a href="crear_miembro.php" class="btn btn-light btn-sm">
                    <i class="bi bi-plus-circle"></i> Nuevo Miembro
                </a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-striped">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Nombre Completo</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Tipo</th>
                                <th>Estado</th>
                                <th>Fecha Registro</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php while ($row = oci_fetch_array($stmt, OCI_ASSOC+OCI_RETURN_NULLS)): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($row['ID_MIEMBRO']); ?></td>
                                <td>
                                    <strong><?php echo htmlspecialchars($row['NOMBRE'] . ' ' . $row['APELLIDO']); ?></strong>
                                </td>
                                <td><i class="bi bi-envelope"></i> <?php echo htmlspecialchars($row['EMAIL']); ?></td>
                                <td><i class="bi bi-telephone"></i> <?php echo htmlspecialchars($row['TELEFONO']); ?></td>
                                <td>
                                    <?php 
                                    $badges = [
                                        'individual' => 'bg-info',
                                        'empresa' => 'bg-success',
                                        'freelancer' => 'bg-warning'
                                    ];
                                    $badge_class = $badges[$row['TIPO_MIEMBRO']] ?? 'bg-secondary';
                                    ?>
                                    <span class="badge <?php echo $badge_class; ?>">
                                        <?php echo htmlspecialchars(ucfirst($row['TIPO_MIEMBRO'])); ?>
                                    </span>
                                </td>
                                <td>
                                    <?php 
                                    $estado_class = $row['ESTADO'] == 'activo' ? 'bg-success' : 'bg-danger';
                                    ?>
                                    <span class="badge <?php echo $estado_class; ?>">
                                        <?php echo htmlspecialchars(ucfirst($row['ESTADO'])); ?>
                                    </span>
                                </td>
                                <td><?php echo htmlspecialchars($row['FECHA_REGISTRO']); ?></td>
                                <td>
                                    <a href="editar_miembro.php?id=<?php echo $row['ID_MIEMBRO']; ?>" 
                                       class="btn btn-sm btn-warning" title="Editar">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="?delete=<?php echo $row['ID_MIEMBRO']; ?>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('¿Está seguro de eliminar este miembro?')"
                                       title="Eliminar">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <?php endwhile; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php
oci_free_statement($stmt);
closeConnection($conn);
?>
