const express = require("express");
const bodyParser = require("body-parser");
const { poolPromise, sql } = require("./db");
require("dotenv").config();

const app = express();

// Configure EJS as the view engine
app.set("view engine", "ejs");
app.set("views", "./views");
app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: false }));

// Main route: Display list of tables
app.get("/", (req, res) => {
  const dbName = process.env.DB_NAME || "NULL";
  res.render("index", { dbName });
});

// Route for Courses table
app.get("/courses", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "CourseID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Course
      WHERE CourseName LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("courses", { courses: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Users table
app.get("/users", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "UsernameID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Users
      WHERE Username LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("users", { users: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Admin table
app.get("/admin", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "AdminID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Admin
      WHERE AdminID LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("admin", { admin: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Teacher table
app.get("/teacher", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "TeacherID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Teacher
      WHERE TeacherID LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("teacher", { teacher: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Category table
app.get("/category", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "CategoryID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Category
      WHERE CategoryName LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("category", { category: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Cart table
app.get("/cart", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "CartID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Cart
      WHERE CartID LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("cart", { cart: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Student table
app.get("/student", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "StudentID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Student
      WHERE StudentID LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("student", { student: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for CourseStudent table
app.get("/coursestudent", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "CourseID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM CourseStudent
      WHERE CourseID LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("courseStudent", {
      courseStudent: result.recordset,
      search,
      sort,
    });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Orders table
app.get("/orders", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "OrderID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Orders
      WHERE OrderID LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("orders", { orders: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for PaymentMethod table
app.get("/paymentmethod", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "PaymentCode";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM PaymentMethod
      WHERE PaymentCode LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("paymentMethod", {
      paymentMethods: result.recordset,
      search,
      sort,
    });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Coupon table
app.get("/coupon", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "CouponID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Coupon
      WHERE CouponTitle LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("coupon", { coupons: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Chapter table
app.get("/chapter", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "ChapterName";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Chapter
      WHERE ChapterName LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("chapter", { chapters: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Document table
app.get("/document", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "DocumentID";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Document
      WHERE DocumentTitle LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("document", { documents: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Lesson table
app.get("/lesson", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "LessonOrder";
  try {
    const pool = await poolPromise;
    const query = `
      SELECT * FROM Lesson
      WHERE LessonTitle LIKE @search
      ORDER BY ${sort}
    `;
    const result = await pool
      .request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(query);
    res.render("lesson", { lessons: result.recordset, search, sort });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Start the server
const PORT = 3500;
app.listen(PORT, () =>
  console.log(`Server is running at http://localhost:${PORT}`)
);
