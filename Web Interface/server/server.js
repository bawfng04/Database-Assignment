const express = require("express");
const sql = require("mssql");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(bodyParser.json());
app.use(cors());

const config = {
  user: "NPM-SASS\\nguye",
  password: "",
  server: "NPM-SASS",
  database: "OnlineCourse",
  options: {
    encrypt: true,
    trustServerCertificate: true,
    enableArithAbort: true,
  },
};

sql.connect(config, (err) => {
  if (err) console.log(err);
  else console.log("Connected to SQL Server");
});

app.get("/courses", async (req, res) => {
  try {
    const result = await sql.query`SELECT * FROM Course`;
    res.json(result.recordset);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.get("/chapters", async (req, res) => {
  try {
    const result = await sql.query`SELECT * FROM Chapter`;
    res.json(result.recordset);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.get("/tests", async (req, res) => {
  try {
    const result = await sql.query`SELECT * FROM Test`;
    res.json(result.recordset);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.get("/calculateTestScore", async (req, res) => {
  const { courseId, chapterName, testOrder } = req.query;
  try {
    const result =
      await sql.query`SELECT dbo.CalculateTestScore(${courseId}, ${chapterName}, ${testOrder}) as Score`;
    res.json(result.recordset[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

const port = 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));
