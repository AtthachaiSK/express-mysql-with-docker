
const mysql = require("mysql");
const HOST = process.env.DATABASE_HOST;

const database = process.env.DATABASE_SCHEMA;
const username = process.env.DATABASE_USERNAME;
const password = process.env.DATABASE_PASSWORD;
var connection = mysql.createPool({
    host: HOST,
    user: username,
    password: password,
    database: database
});
console.log(" HOST:" + HOST)
module.exports = connection;