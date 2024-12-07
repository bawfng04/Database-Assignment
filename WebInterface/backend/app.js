const express = require("express");
const bodyParser = require("body-parser");
const { poolPromise, sql } = require("./db");

const app = express();

// Configure EJS as the view engine
app.set("view engine", "ejs");
app.set("views", "./views");
app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: false }));

// Main route: Display list of tables
app.get("/", (req, res) => {
  res.render("index");
});

// Route for Courses table
app.get("/courses", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Course");
    res.render("courses", { courses: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Users table
app.get("/users", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Users");
    res.render("users", { users: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Admin table
app.get("/admin", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Admin");
    res.render("admin", { admin: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Teacher table
app.get("/teacher", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Teacher");
    res.render("teacher", { teacher: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Category table
app.get("/category", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Category");
    res.render("category", { category: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Cart table
app.get("/cart", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Cart");
    res.render("cart", { cart: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Student table
app.get("/student", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Student");
    res.render("student", { student: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for CourseStudent table
app.get("/coursestudent", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM CourseStudent");
    res.render("courseStudent", { courseStudent: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Orders table
app.get("/orders", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Orders");
    res.render("orders", { orders: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for PaymentMethod table
app.get("/paymentmethod", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM PaymentMethod");
    res.render("paymentMethod", { paymentMethods: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Coupon table
app.get("/coupon", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Coupon");
    res.render("coupon", { coupons: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Chapter table
app.get("/chapter", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Chapter");
    res.render("chapter", { chapters: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Document table
app.get("/document", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Document");
    res.render("document", { documents: result.recordset });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

// Route for Lesson table
app.get("/lesson", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query("SELECT * FROM Lesson");
    res.render("lesson", { lessons: result.recordset });
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
