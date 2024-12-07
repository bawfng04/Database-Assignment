const express = require("express");
const bodyParser = require("body-parser");
const { poolPromise, sql } = require("./db");

const app = express();

// Cấu hình EJS làm view engine
app.set("view engine", "ejs");
app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: false }));

// Route chính: Hiển thị dữ liệu
app.get("/", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Course"); // Thay "Course" bằng bảng trong database
    res.render("index", { courses: result.recordset });
  } catch (err) {
    console.error("Lỗi khi lấy dữ liệu:", err);
    res.status(500).send("Lỗi khi lấy dữ liệu từ database.");
  }
});

// Khởi động server
const PORT = 3500;
app.listen(PORT, () => console.log(`Server chạy tại http://localhost:${PORT}`));
