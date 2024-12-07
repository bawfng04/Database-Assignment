const express = require("express");
const bodyParser = require("body-parser");
const { poolPromise, sql } = require("./db");

const app = express();

// Cấu hình EJS làm view engine
app.set("view engine", "ejs");
app.set("views", "./views"); // Ensure the views directory is correctly set
app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: false }));

// Route chính: Hiển thị dữ liệu từ bảng Course
app.get("/", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Course");
    res.render("index", { courses: result.recordset });
  } catch (err) {
    console.error("Lỗi khi lấy dữ liệu:", err);
    res.status(500).send("Lỗi khi lấy dữ liệu từ database.");
  }
});

// Route để hiển thị dữ liệu từ bảng khác (ví dụ: Users)
app.get("/users", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Users");
    res.render("users", { users: result.recordset });
  } catch (err) {
    console.error("Lỗi khi lấy dữ liệu:", err);
    res.status(500).send("Lỗi khi lấy dữ liệu từ database.");
  }
});

// Khởi động server
const PORT = 3500;
app.listen(PORT, () => console.log(`Server chạy tại http://localhost:${PORT}`));
