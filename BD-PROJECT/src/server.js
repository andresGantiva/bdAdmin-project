
const path = require('path');
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const db = require('./db');

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '../public')));

const isMySQL = () => db.getDriver() === 'mysql';
const isDemo = () => db.getDriver() === 'demo';

// --- Helpers DEMO ---
function nextId(arr) {
  return arr.length ? Math.max(...arr.map(x => x.id)) + 1 : 1;
}

// --- EMPRESAS ---
app.get('/api/companies', async (req, res) => {
  try {
    if (isDemo()) {
      return res.json(db.getDemo().companies);
    } else if (isMySQL()) {
      const [rows] = await db.getPool().query('SELECT id, name FROM companies ORDER BY name');
      return res.json(rows);
    } else {
      const conn = await db.getPool().getConnection();
      const result = await conn.execute('SELECT id, name FROM companies ORDER BY name');
      await conn.close();
      return res.json(result.rows);
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/companies', async (req, res) => {
  const { name, nit, contact_email, phone } = req.body;
  try {
    if (isDemo()) {
      const arr = db.getDemo().companies;
      const id = nextId(arr);
      arr.push({ id, name, nit, contact_email, phone });
      return res.json({ id, name });
    } else if (isMySQL()) {
      const [r] = await db.getPool().execute(
        'INSERT INTO companies(name, nit, contact_email, phone) VALUES (?,?,?,?)',
        [name, nit, contact_email, phone]
      );
      return res.json({ id: r.insertId, name });
    } else {
      const oracledb = require('oracledb');
      const conn = await db.getPool().getConnection();
      const r = await conn.execute(
        'INSERT INTO companies(name, nit, contact_email, phone) VALUES (:name, :nit, :contact_email, :phone) RETURNING id INTO :id',
        { name, nit, contact_email, phone, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
        { autoCommit: true }
      );
      await conn.close();
      return res.json({ id: r.outBinds.id[0], name });
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// --- EMPLEADOS ---
app.get('/api/employees', async (req, res) => {
  try {
    const sql = `SELECT e.id, e.first_name, e.last_name, e.document, e.role, e.status, e.company_id,
                        c.name AS company_name
                 FROM employees e LEFT JOIN companies c ON e.company_id = c.id
                 ORDER BY e.id DESC`;
    if (isDemo()) {
      const { employees, companies } = db.getDemo();
      const rows = employees.slice().sort((a,b)=>b.id-a.id).map(e => ({
        ...e,
        company_name: companies.find(c => c.id === e.company_id)?.name || null
      }));
      return res.json(rows);
    } else if (isMySQL()) {
      const [rows] = await db.getPool().query(sql.replace("(e.first_name || ' ' || e.last_name)", "CONCAT(e.first_name, ' ', e.last_name)"));
      return res.json(rows);
    } else {
      const conn = await db.getPool().getConnection();
      const result = await conn.execute(sql);
      await conn.close();
      return res.json(result.rows);
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/employees', async (req, res) => {
  const { company_id, first_name, last_name, document, role, status } = req.body;
  try {
    if (isDemo()) {
      const arr = db.getDemo().employees;
      const id = nextId(arr);
      arr.push({ id, company_id, first_name, last_name, document, role, status: status || 'ACTIVO' });
      return res.json({ id });
    } else if (isMySQL()) {
      const [r] = await db.getPool().execute(
        'INSERT INTO employees(company_id, first_name, last_name, document, role, status) VALUES (?,?,?,?,?,?)',
        [company_id, first_name, last_name, document, role, status || 'ACTIVO']
      );
      return res.json({ id: r.insertId });
    } else {
      const oracledb = require('oracledb');
      const conn = await db.getPool().getConnection();
      const r = await conn.execute(
        'INSERT INTO employees(company_id, first_name, last_name, document, role, status) VALUES (:company_id,:first_name,:last_name,:document,:role,:status) RETURNING id INTO :id',
        { company_id, first_name, last_name, document, role, status: status || 'ACTIVO', id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
        { autoCommit: true }
      );
      await conn.close();
      return res.json({ id: r.outBinds.id[0] });
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.delete('/api/employees/:id', async (req, res) => {
  const { id } = req.params;
  try {
    if (isDemo()) {
      const arr = db.getDemo().employees;
      const idx = arr.findIndex(e => e.id === Number(id));
      if (idx >= 0) arr.splice(idx, 1);
      return res.json({ ok: true });
    } else if (isMySQL()) {
      await db.getPool().execute('DELETE FROM employees WHERE id=?', [id]);
      return res.json({ ok: true });
    } else {
      const conn = await db.getPool().getConnection();
      await conn.execute('DELETE FROM employees WHERE id=:id', { id: Number(id) }, { autoCommit: true });
      await conn.close();
      return res.json({ ok: true });
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// --- PUNTOS DE ACCESO ---
app.get('/api/access-points', async (req, res) => {
  try {
    const sql = 'SELECT id, name, location FROM access_points ORDER BY name';
    if (isDemo()) {
      return res.json(db.getDemo().access_points);
    } else if (isMySQL()) {
      const [rows] = await db.getPool().query(sql);
      return res.json(rows);
    } else {
      const conn = await db.getPool().getConnection();
      const r = await conn.execute(sql);
      await conn.close();
      return res.json(r.rows);
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/access-points', async (req, res) => {
  const { name, location } = req.body;
  try {
    if (isDemo()) {
      const arr = db.getDemo().access_points;
      const id = nextId(arr);
      arr.push({ id, name, location });
      return res.json({ id, name });
    } else if (isMySQL()) {
      const [r] = await db.getPool().execute('INSERT INTO access_points(name, location) VALUES(?,?)', [name, location]);
      return res.json({ id: r.insertId, name });
    } else {
      const oracledb = require('oracledb');
      const conn = await db.getPool().getConnection();
      const r = await conn.execute(
        'INSERT INTO access_points(name, location) VALUES(:name, :location) RETURNING id INTO :id',
        { name, location, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
        { autoCommit: true }
      );
      await conn.close();
      return res.json({ id: r.outBinds.id[0], name });
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// --- LOGS DE ACCESO ---
app.get('/api/access-logs', async (req, res) => {
  try {
    const limit = Math.min(Number(req.query.limit || 100), 500);
    const sql = `SELECT l.id, l.employee_id, l.access_point_id, l.direction, l.occurred_at,
                        (e.first_name || ' ' || e.last_name) AS employee_name,
                        ap.name AS access_point
                 FROM access_logs l
                 LEFT JOIN employees e ON l.employee_id = e.id
                 LEFT JOIN access_points ap ON l.access_point_id = ap.id
                 ORDER BY l.id DESC`;
    if (isDemo()) {
      const { access_logs, employees, access_points } = db.getDemo();
      const rows = access_logs.slice().sort((a,b)=>b.id-a.id).slice(0, limit).map(l => ({
        id: l.id,
        employee_id: l.employee_id,
        access_point_id: l.access_point_id,
        direction: l.direction,
        occurred_at: l.occurred_at,
        employee_name: (() => {
          const e = employees.find(x => x.id === l.employee_id);
          return e ? `${e.first_name} ${e.last_name}` : null;
        })(),
        access_point: access_points.find(x => x.id === l.access_point_id)?.name || null
      }));
      return res.json(rows);
    } else if (isMySQL()) {
      const mysqlSql = sql.replace("(e.first_name || ' ' || e.last_name)", "CONCAT(e.first_name, ' ', e.last_name)") + ` LIMIT ${limit}`;
      const [rows] = await db.getPool().query(mysqlSql);
      return res.json(rows);
    } else {
      const conn = await db.getPool().getConnection();
      const r = await conn.execute(sql + ` FETCH FIRST ${limit} ROWS ONLY`);
      await conn.close();
      return res.json(r.rows);
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/access-logs', async (req, res) => {
  const { employee_id, access_point_id, direction } = req.body;
  try {
    if (isDemo()) {
      const arr = db.getDemo().access_logs;
      const id = nextId(arr);
      arr.push({ id, employee_id, access_point_id, direction, occurred_at: new Date().toISOString() });
      return res.json({ ok: true });
    } else if (isMySQL()) {
      await db.getPool().execute(
        'INSERT INTO access_logs(employee_id, access_point_id, direction) VALUES (?,?,?)',
        [employee_id, access_point_id, direction]
      );
      return res.json({ ok: true });
    } else {
      const conn = await db.getPool().getConnection();
      await conn.execute(
        'INSERT INTO access_logs(employee_id, access_point_id, direction) VALUES (:employee_id,:access_point_id,:direction)',
        { employee_id, access_point_id, direction },
        { autoCommit: true }
      );
      await conn.close();
      return res.json({ ok: true });
    }
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// Arranque del servidor + DB
(async () => {
  await db.init();
  const port = Number(process.env.PORT || 3000);
  app.listen(port, () => console.log(`🚀 SGDB server en http://localhost:${port}`));
})();
