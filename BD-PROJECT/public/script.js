// ============================================
// DATOS QUEMADOS EN MEMORIA
// ============================================

// Mapa de empresas (para obtener nombre por ID)
const companies = {
  1: 'TechCorp SAS',
  2: 'InnovaSoft Ltda',
  3: 'DataSolutions Co',
  4: 'CloudServices Inc'
};

// Mapa de puntos de acceso
const accessPoints = {
  1: 'Puerta Principal',
  2: 'Zona Coworking',
  3: 'Sala de Reuniones A',
  4: 'Cafetería',
  5: 'Terraza'
};

// Array de empleados (datos iniciales)
let employees = [
  { id: 1, company_id: 1, first_name: 'Carlos', last_name: 'Rodríguez', document: '1023456789', role: 'Desarrollador', status: 'ACTIVO' },
  { id: 2, company_id: 1, first_name: 'Ana', last_name: 'Martínez', document: '1034567890', role: 'Project Manager', status: 'ACTIVO' },
  { id: 3, company_id: 2, first_name: 'Luis', last_name: 'Gómez', document: '1045678901', role: 'DevOps', status: 'ACTIVO' },
  { id: 4, company_id: 3, first_name: 'María', last_name: 'Pérez', document: '1056789012', role: 'Analista de Datos', status: 'INACTIVO' },
  { id: 5, company_id: 2, first_name: 'Pedro', last_name: 'López', document: '1067890123', role: 'Diseñador UX', status: 'ACTIVO' }
];

// Array de logs de acceso (datos iniciales)
let accessLogs = [
  { id: 1, employee_id: 1, access_point_id: 1, direction: 'IN', occurred_at: '2025-11-09T08:30:00' },
  { id: 2, employee_id: 2, access_point_id: 1, direction: 'IN', occurred_at: '2025-11-09T09:15:00' },
  { id: 3, employee_id: 3, access_point_id: 2, direction: 'IN', occurred_at: '2025-11-09T10:00:00' },
  { id: 4, employee_id: 1, access_point_id: 4, direction: 'IN', occurred_at: '2025-11-09T11:30:00' },
  { id: 5, employee_id: 1, access_point_id: 4, direction: 'OUT', occurred_at: '2025-11-09T11:45:00' }
];

let nextEmployeeId = 6;
let nextAccessLogId = 6;


// ============================================
// RENDERIZAR TABLA DE EMPLEADOS
// ============================================
function renderEmployees() {
  const tbody = document.getElementById('employees-table');
  const selectEmployee = document.getElementById('access_employee');
  
  // Renderizar tabla
  tbody.innerHTML = employees.map(emp => `
    <tr>
      <td>${emp.id}</td>
      <td>${emp.first_name} ${emp.last_name}</td>
      <td>${companies[emp.company_id]}</td>
      <td>${emp.document}</td>
      <td>${emp.role}</td>
      <td><span class="badge ${emp.status === 'ACTIVO' ? 'text-bg-success' : 'text-bg-secondary'}">${emp.status}</span></td>
      <td class="text-end">
        <button class="btn btn-sm btn-outline-danger" onclick="deleteEmployee(${emp.id})">Eliminar</button>
      </td>
    </tr>
  `).join('');
  
  // Actualizar select de empleados (solo activos)
  const activeEmployees = employees.filter(e => e.status === 'ACTIVO');
  selectEmployee.innerHTML = '<option value="">-- Seleccionar empleado --</option>' + 
    activeEmployees.map(emp => `
      <option value="${emp.id}">${emp.first_name} ${emp.last_name} - ${companies[emp.company_id]}</option>
    `).join('');
}


// ============================================
// RENDERIZAR LOGS DE ACCESO
// ============================================
function renderAccessLogs() {
  const tbody = document.getElementById('access-logs-table');
  
  // Ordenar por fecha descendente
  const sortedLogs = [...accessLogs].sort((a, b) => 
    new Date(b.occurred_at) - new Date(a.occurred_at)
  );
  
  tbody.innerHTML = sortedLogs.map(log => {
    const employee = employees.find(e => e.id === log.employee_id);
    const employeeName = employee ? `${employee.first_name} ${employee.last_name}` : 'Desconocido';
    
    return `
      <tr>
        <td>${new Date(log.occurred_at).toLocaleString('es-CO')}</td>
        <td>${employeeName}</td>
        <td>${accessPoints[log.access_point_id]}</td>
        <td><span class="badge ${log.direction === 'IN' ? 'text-bg-primary' : 'text-bg-dark'}">${log.direction}</span></td>
      </tr>
    `;
  }).join('');
}


// ============================================
// AGREGAR EMPLEADO
// ============================================
document.getElementById('employee-form').addEventListener('submit', function(e) {
  e.preventDefault();
  
  const newEmployee = {
    id: nextEmployeeId++,
    company_id: parseInt(document.getElementById('company_id').value),
    first_name: document.getElementById('first_name').value.trim(),
    last_name: document.getElementById('last_name').value.trim(),
    document: document.getElementById('document').value.trim(),
    role: document.getElementById('role').value.trim(),
    status: document.getElementById('status').value
  };
  
  employees.push(newEmployee);
  renderEmployees();
  
  // Limpiar formulario
  this.reset();
  
  console.log('✅ Empleado agregado:', newEmployee);
});


// ============================================
// LIMPIAR FORMULARIO
// ============================================
document.getElementById('reset-form').addEventListener('click', function() {
  document.getElementById('employee-form').reset();
});


// ============================================
// ELIMINAR EMPLEADO
// ============================================
function deleteEmployee(id) {
  if (!confirm('¿Eliminar empleado?')) return;
  
  const index = employees.findIndex(e => e.id === id);
  if (index !== -1) {
    employees.splice(index, 1);
    renderEmployees();
    console.log('✅ Empleado eliminado ID:', id);
  }
}


// ============================================
// REGISTRAR ACCESO
// ============================================
document.getElementById('access-form').addEventListener('submit', function(e) {
  e.preventDefault();
  
  const employeeId = parseInt(document.getElementById('access_employee').value);
  
  if (!employeeId) {
    alert('Selecciona un empleado');
    return;
  }
  
  const newLog = {
    id: nextAccessLogId++,
    employee_id: employeeId,
    access_point_id: parseInt(document.getElementById('access_point_id').value),
    direction: document.getElementById('direction').value,
    occurred_at: new Date().toISOString()
  };
  
  accessLogs.push(newLog);
  renderAccessLogs();
  
  console.log('✅ Acceso registrado:', newLog);
});


// ============================================
// INICIALIZAR AL CARGAR LA PÁGINA
// ============================================
document.addEventListener('DOMContentLoaded', function() {
  console.log('🚀 Aplicación iniciada');
  renderEmployees();
  renderAccessLogs();
  console.log('✅ Datos cargados correctamente');
});
