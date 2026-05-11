const express = require("express");

const app = express();

app.get("/", (req, res) => {
    res.send("App is running successfully!");
});

app.get("/health", (req, res) => {
    res.status(500).send("App is Running without any issues");
});

app.listen(3000, () => {
    console.log("Server running on port 3000 wich is mapped to 80");
});
