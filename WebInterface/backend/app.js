const express = require("express");
const bodyParser = require("body-parser");
const { poolPromise, sql } = require("./db");
require("dotenv").config();

const app = express();

app.set("view engine", "ejs");
app.set("views", "./views");
app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: false }));

app.get("/", (req, res) => {
  const dbName = process.env.DB_NAME || "NULL";
  res.render("index", { dbName });
});

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

// app.get("/cart", async (req, res) => {
//   const search = req.query.search || "";
//   const sort = req.query.sort || "CartID";
//   try {
//     const pool = await poolPromise;
//     const query = `
//       SELECT * FROM Cart
//       WHERE CartID LIKE @search
//       ORDER BY ${sort}
//     `;
//     const result = await pool
//       .request()
//       .input("search", sql.NVarChar, `%${search}%`)
//       .query(query);
//     res.render("cart", { cart: result.recordset, search, sort });
//   } catch (err) {
//     console.error("Error fetching data:", err);
//     res.status(500).send("Error fetching data from database.");
//   }
// });

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

//=======================================================================================================
app.get("/coupon", async (req, res) => {
  const search = req.query.search || "";
  const sort = req.query.sort || "CouponID";
  const message = req.query.message;
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
    res.render("coupon", { coupons: result.recordset, search, sort, message });
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).send("Error fetching data from database.");
  }
});

app.get("/coupon/new", (req, res) => {
  res.render("newCoupon");
});


// Update the get route to handle the message
app.get("/coupon/edit/:id", async (req, res) => {
  const { id } = req.params;
  const message = req.query.message;
  try {
    const pool = await poolPromise;
    const query = `SELECT * FROM Coupon WHERE CouponID = @id`;
    const result = await pool.request().input("id", sql.Int, id).query(query);
    res.render("editCoupon", {
      coupon: result.recordset[0],
      message: message,
    });
  } catch (err) {
    console.error("Error fetching coupon:", err);
    res.status(500).send("Error fetching coupon.");
  }
});


//dùng procedure create coupon để tạo coupon
// Use the InsertCoupon procedure to create coupon
app.post("/coupon", async (req, res) => {
  const {
    CouponTitle,
    CouponValue,
    CouponType,
    CouponStartDate,
    CouponExpire,
    CouponMaxDiscount,
  } = req.body;
  try {
    const pool = await poolPromise;
    await pool
      .request()
      .input("CouponTitle", sql.NVarChar, CouponTitle)
      .input("CouponValue", sql.Int, CouponValue)
      .input("CouponType", sql.NVarChar, CouponType)
      .input("CouponStartDate", sql.Date, CouponStartDate)
      .input("CouponExpire", sql.Date, CouponExpire)
      .input("CouponMaxDiscount", sql.Int, CouponMaxDiscount)
      .execute("InsertCoupon"); // Call the stored procedure

    res.redirect("/coupon");
  } catch (err) {
    console.error("Error creating coupon:", err);
    res.status(500).send("Error creating coupon.");
  }
});


//dùng procedure update coupon để sửa coupon
// Use the UpdateCoupon procedure to update coupon
app.post("/coupon/edit/:id", async (req, res) => {
  const { id } = req.params;
  const {
    CouponTitle,
    CouponValue,
    CouponType,
    CouponStartDate,
    CouponExpire,
    CouponMaxDiscount,
  } = req.body;
  try {
    const pool = await poolPromise;
    await pool
      .request()
      .input("CouponID", sql.Int, id)
      .input("CouponTitle", sql.NVarChar, CouponTitle)
      .input("CouponValue", sql.Int, CouponValue)
      .input("CouponType", sql.NVarChar, CouponType)
      .input("CouponStartDate", sql.Date, CouponStartDate)
      .input("CouponExpire", sql.Date, CouponExpire)
      .input("CouponMaxDiscount", sql.Int, CouponMaxDiscount)
      .execute("UpdateCoupon"); // Call the stored procedure

    res.redirect("/coupon");
  } catch (err) {
    console.error("Error updating coupon:", err);
    res.status(500).send("Error updating coupon.");
  }
});




//dùng procedure delete coupon để xóa coupon
app.post("/coupon/delete/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("CouponID", sql.Int, id)
      .execute("DeleteCoupon");

    const message = result.output.message || "Coupon deleted successfully.";
    // res.render("coupon", { message });
    res.redirect("/coupon");
  } catch (err) {
    console.error("Error deleting coupon:", err);
    res.status(500).send("Error deleting coupon.");
  }
});

// ========================================
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

const PORT = 3500;
app.listen(PORT, () =>
  console.log(`Server is running at http://localhost:${PORT}`)
);








// app.post("/coupon", async (req, res) => {
//   const {
//     CouponTitle,
//     CouponValue,
//     CouponType,
//     CouponStartDate,
//     CouponExpire,
//     CouponMaxDiscount,
//   } = req.body;
//   try {
//     const pool = await poolPromise;
//     const query = `
//       INSERT INTO Coupon (CouponTitle, CouponValue, CouponType, CouponStartDate, CouponExpire, CouponMaxDiscount)
//       VALUES (@CouponTitle, @CouponValue, @CouponType, @CouponStartDate, @CouponExpire, @CouponMaxDiscount)
//     `;
//     await pool
//       .request()
//       .input("CouponTitle", sql.NVarChar, CouponTitle)
//       .input("CouponValue", sql.Int, CouponValue)
//       .input("CouponType", sql.NVarChar, CouponType)
//       .input("CouponStartDate", sql.Date, CouponStartDate)
//       .input("CouponExpire", sql.Date, CouponExpire)
//       .input("CouponMaxDiscount", sql.Int, CouponMaxDiscount)
//       .query(query);
//     res.redirect("/coupon");
//   } catch (err) {
//     console.error("Error creating coupon:", err);
//     res.status(500).send("Error creating coupon.");
//   }
// });



// app.post("/coupon/edit/:id", async (req, res) => {
//   const { id } = req.params;
//   const {
//     CouponTitle,
//     CouponValue,
//     CouponType,
//     CouponStartDate,
//     CouponExpire,
//     CouponMaxDiscount,
//   } = req.body;
//   try {
//     const pool = await poolPromise;
//     const query = `
//       UPDATE Coupon
//       SET CouponTitle = @CouponTitle, CouponValue = @CouponValue, CouponType = @CouponType, CouponMaxDiscount = @CouponMaxDiscount,
//           CouponStartDate = @CouponStartDate, CouponExpire = @CouponExpire
//       WHERE CouponID = @id
//     `;
//     await pool
//       .request()
//       .input("CouponTitle", sql.NVarChar, CouponTitle)
//       .input("CouponValue", sql.Int, CouponValue)
//       .input("CouponType", sql.NVarChar, CouponType)
//       .input("CouponStartDate", sql.Date, CouponStartDate)
//       .input("CouponExpire", sql.Date, CouponExpire)
//       .input("CouponMaxDiscount", sql.Int, CouponMaxDiscount)
//       .input("id", sql.Int, id)
//       .query(query);
//     res.redirect("/coupon");
//   } catch (err) {
//     console.error("Error updating coupon:", err);
//     res.status(500).send("Error updating coupon.");
//   }
// });



// app.post("/coupon/delete/:id", async (req, res) => {
//   const { id } = req.params;
//   try {
//     const pool = await poolPromise;
//     const query = `DELETE FROM Coupon WHERE CouponID = @id`;
//     await pool.request().input("id", sql.Int, id).query(query);
//     res.redirect("/coupon");
//   } catch (err) {
//     console.error("Error deleting coupon:", err);
//     res.status(500).send("Error deleting coupon.");
//   }
// });