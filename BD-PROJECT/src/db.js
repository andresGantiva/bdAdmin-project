
const dotenv = require('dotenv');
dotenv.config();

const dbType = (process.env.DB_TYPE || 'demo').toLowerCase();
let pool = null;
let driver = null;

// --- DEMO data ---
const demoData = {
  companies: [
    { id: 1, name: 'Empresa Demo', nit: '900123456', contact_email: 'info@demo.co', phone: '3000000000' }
  ],
  employees: [
    { id: 1, company_id: 1, first_name: 'Ana', last_name: 'López', document: '10223344', role: 'Residente', status: 'ACTIVO' },
    { id: 2, company_id: 1, first_name: 'Carlos', last_name: 'Gómez', document: '9876543', role: 'Administrador', status: 'ACTIVO' }
  ],
  access_points: [
    { id: 1, name: 'Torno Principal', location: 'Lobby' },
    { id: 2, name: 'Garaje', location: 'Sótano 1' }
  ],
  access_logs: [
    { id: 1, employee_id: 1, access_point_id: 1, direction: 'IN',  occurred_at: new Date().toISOString() }
  ]
}

async function init() {
  if (dbType === 'mysql') {
    const mysql = require('mysql2/promise');
    pool = await mysql.createPool({
      host: process.env.MYSQL_HOST,
      port: Number(process.env.MYSQL_PORT || 3306),
      user: process.env.MYSQL_USER,
      password: process.env.MYSQL_PASSWORD,
      database: process.env.MYSQL_DATABASE,
      waitForConnections: true,
      connectionLimit: 10
    });
    driver = 'mysql';
    console.log('✅ Conectado a MySQL');
  } else if (dbType === 'oracle') {
    const oracledb = require('oracledb');
    oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
    pool = await oracledb.createPool({
      user: process.env.ORACLE_USER,
      password: process.env.ORACLE_PASSWORD,
      connectString: process.env.ORACLE_CONNECT_STRING,
      poolIncrement: 1,
      poolMax: 4
    });
    driver = 'oracle';
    console.log('✅ Conectado a Oracle');
  } else {
    driver = 'demo';
    console.log('✅ Modo DEMO (datos en memoria)');
  }
}

function getPool() { return pool; }
function getDriver() { return driver; }
function getDemo() { return demoData; }

module.exports = { init, getPool, getDriver, getDemo };
