const sql = require("mssql");
require("dotenv").config();

// Connection configuration using environment variables
const config = {
  server: "NPM-SASS",
  // database: "btl2connect",
  database: process.env.DB_NAME || "",
  user: process.env.DB_USER || "bang",
  password: process.env.DB_PASSWORD || "123456",
  options: {
    encrypt: false,
    trustServerCertificate: false,
  },
};

// Function to connect to SQL Server
const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then((pool) => {
    console.log("Connected to SQL Server successfully!");
    return pool;
  })
  .catch((err) => console.error("SQL Server connection failed!", err));

module.exports = { sql, poolPromise };
