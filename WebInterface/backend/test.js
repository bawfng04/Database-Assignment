const sql = require("mssql");

const config = {
  user: "your_username",
  password: "your_password",
  server: "NPM-SASS",
  database: "OnlineCourse",
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

async function testConnection() {
  try {
    const pool = await sql.connect(config);
    console.log("Kết nối thành công!");
    await pool.close();
  } catch (err) {
    console.error("Kết nối thất bại:", err);
  }
}

testConnection();
