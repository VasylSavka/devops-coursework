const express = require("express");
const cors = require("cors");
const path = require("path");
const fs = require("fs");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors()); // CORS ДО static

// Serve frontend
app.use(express.static(path.join(__dirname, "public")));

// Serve data from data.json
const rawData = fs.readFileSync("data.json");
const jsonData = JSON.parse(rawData);

// Healthcheck
app.get("/health", (req, res) => {
  res.json({ status: "OK", uptime: process.uptime() });
});

// Get all data
app.get("/data", (req, res) => {
  res.json(jsonData);
});

// Get item by index
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
