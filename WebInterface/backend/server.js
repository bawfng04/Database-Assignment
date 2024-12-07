const express = require("express");
const sql = require("mssql");

const app = express();

// Cấu hình kết nối
const config = {
  server: "NPM-SASS",
  database: "Online Course",
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
  authentication: {
    type: "ntlm",
    options: {
      domain: "NPM-SASS",
    },
  },
};

// Kết nối đến SQL Server
sql
  .connect(config)
  .then((pool) => {
    if (pool.connecting) {
      console.log("Đang kết nối đến SQL Server...");
    }
    if (pool.connected) {
      console.log("Kết nối thành công đến SQL Server.");
    }

    // Thiết lập route chính
    app.get("/", async (req, res) => {
      try {
        const result = await pool.request().query("SELECT * FROM Courses");
        res.send(result.recordset);
      } catch (err) {
        console.error("Lỗi truy vấn:", err);
        res.status(500).send("Lỗi server");
      }
    });

    // Lắng nghe cổng 3000
    app.listen(3000, () => {
      console.log("Server đang chạy tại http://localhost:3000");
    });
  })
  .catch((err) => {
    console.error("Lỗi kết nối SQL Server:", err);
  });
