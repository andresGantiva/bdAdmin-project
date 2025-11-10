# SGDB Coworking — Starter (Visual + API)

Este paquete está listo para abrir en **Visual Studio Code**. Trae una interfaz **Bootstrap 5** y un backend **Express**. Por defecto corre en **modo DEMO** (sin base de datos) para que veas el apartado visual de inmediato.

## Requisitos
- Node.js 18+
- (Opcional) XAMPP con MySQL/MariaDB
- (Opcional) Oracle + Instant Client

## Pasos rápidos (visual inmediato)
1. Abre una terminal en la carpeta del proyecto.
2. Instala dependencias:
   ```bash
   npm install
   ```
3. Copia `.env.example` a `.env` (ya viene `DB_TYPE=demo`).
4. Ejecuta:
   ```bash
   npm start
   ```
5. Abre `http://localhost:3000` y prueba la UI (crear empleados, registrar accesos, etc.).

## Conectar a MySQL (XAMPP)
1. Enciende **MySQL** en XAMPP.
2. Entra a **phpMyAdmin** y ejecuta `src/sql/mysql_schema.sql` (crea BD y tablas).
3. En `.env` usa:
   ```ini
   DB_TYPE=mysql
   MYSQL_HOST=127.0.0.1
   MYSQL_PORT=3306
   MYSQL_USER=root
   MYSQL_PASSWORD=
   MYSQL_DATABASE=coworking
   ```
4. `npm start` y entra a `http://localhost:3000`.

## Conectar a Oracle
1. Instala **Oracle Instant Client** y agrégalo al `PATH`.
2. En tu esquema ejecuta `src/sql/oracle_schema.sql`.
3. En `.env` usa:
   ```ini
   DB_TYPE=oracle
   ORACLE_USER=system
   ORACLE_PASSWORD=YourPassword
   ORACLE_CONNECT_STRING=localhost:1521/XEPDB1
   ```
4. Instala el driver si no está:
   ```bash
   npm i oracledb
   ```
5. `npm start` y abre `http://localhost:3000`.

## Estructura
```
coworking-sgdb/
├─ package.json
├─ .env.example
├─ src/
│  ├─ server.js        # API Express (demo/mysql/oracle)
│  ├─ db.js            # Conexión y datos DEMO
│  └─ sql/             # Scripts SQL
└─ public/             # Apartado visual (Bootstrap)
   ├─ index.html
   ├─ script.js
   └─ styles.css
```
