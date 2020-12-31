const express = require('express');
const router = express.Router();
const newsController = require('../controllers/newsController');

router.get('/news', newsController.getNews);
router.get('/news/detail', newsController.getDetail);
router.get('/news/read', newsController.getReadNews);
module.exports = router;