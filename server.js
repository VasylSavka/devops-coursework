const express = require("express");
const cors = require("cors");
const path = require("path");
const fs = require("fs");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());

app.use(express.static(path.join(__dirname, "public")));

const rawData = fs.readFileSync("data.json");
const jsonData = JSON.parse(rawData);

app.get("/health", (req, res) => {
  res.json({ status: "OK", uptime: process.uptime() });
});

app.get("/data", (req, res) => {
  res.json(jsonData);
});

app.get("/:id", (req, res) => {
  const idx = parseInt(req.params.id);
  if (!isNaN(idx) && idx >= 0 && idx < jsonData.length) {
    res.json(jsonData[idx]);
  } else {
    res.status(404).json({ error: "Not found" });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
});
