const mysql = require("mysql2/promise");

const pool = mysql.createPool({
  host: process.env.DB_HOST || "db",
  port: Number(process.env.DB_PORT || 3306),
  database: process.env.DB_NAME || "lab_db",
  user: process.env.DB_USER || "lab_user",
  password: process.env.DB_PASSWORD || "lab_password",
  waitForConnections: true,
  connectionLimit: 10,
});

async function getDatabaseStatus() {
  const [rows] = await pool.query(
    "SELECT DATABASE() AS databaseName, NOW() AS serverTime"
  );

  return rows[0];
}

module.exports = {
  getDatabaseStatus,
};
