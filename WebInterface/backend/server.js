const express = require("express");
const cors = require("cors");
const sql = require("mssql");

const app = express();
app.use(cors());

const config = {
  server: "NPM-SASS",
  database: "master", // Change to the desired database
  options: {
    encrypt: true,
    trustServerCertificate: true,
    connectTimeout: 30000,
  },
  authentication: {
    type: "ntlm",
    options: {
      domain: "NPM-SASS", // Replace with your domain
      userName: "nguye", // Replace with your Windows username
      password: "", // Leave empty for Windows Authentication
    },
  },
};

sql
  .connect(config)
  .then(() => {
    console.log("Connected to the database");
  })
  .catch((err) => {
    console.error("Database connection error:", err);
  });

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});

sql
  .connect(config)
  .then(() => {
    console.log("Connected to the database");
    const port = 5000;
    app.listen(port, () => console.log(`Server running on port ${port}`));
  })
  .catch((err) => {
    console.log("Database connection error:", err);
  });
