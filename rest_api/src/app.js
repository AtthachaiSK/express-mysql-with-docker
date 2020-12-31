const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const newsRoutes = require('./routes/newsRoutes');
const app = express();
app.use(cors());
app.use(helmet());
const limiter = rateLimit({
    max: 150,
    windowMs: 60 * 60 * 1000,
    message: 'Too Many Request from this IP, please try again in an hour'
});
app.use("/api",newsRoutes);
app.get("/", (req, res) => {
    res.send("Applocation Version 1.0.0")
});
app.use('*', (req, res, next) => {
    // const err = new AppError(404, 'fail', 'undefined route');
    next(null, req, res, next);
})
module.exports = app;