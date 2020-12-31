const News = require("../models/news.model");
const Activity = require("../models/activity.model");
exports.getNews = async (req, res, next) => {
    try {
        let { userId } = req.query;
        if (!userId) res.json({ news: [] });
        let userIdInt = parseInt(userId);
        if (isNaN(userIdInt) == true) throw "Error: invalid userId";
        let result = await News.findNewsIdByUserId(userIdInt);
        res.json({
            news: result
        });
    } catch (err) {
        console.log("err :", err);
        next(err);
    }
};

exports.getDetail = async (req, res, next) => {
    try {
        let { newsId, userId, lang } = req.query;
        if (!newsId || !userId) res.json({ detail: {} });
        let userIdInt = parseInt(userId);
        let newsIdInt = parseInt(newsId);
        if (isNaN(newsIdInt) == true || isNaN(userIdInt) == true) throw "Error: invalid  userid or newsid";
        let result = [];
        if (lang) {
            result = await News.findDetailNewsByNewsIdAndLang(userIdInt, newsIdInt, lang);
        } else {
            result = await News.findDetailNewsByNewsId(userIdInt, newsIdInt);
        }
       
        if (result.length) Activity.updateActivityById(userIdInt, newsIdInt);

        res.json({
            detail: result.length ? result[0] : {}
        });
    } catch (err) {
        console.log("err :", err);
        next(err);
    }
};

exports.getReadNews = async (req, res, next) => {
    try {
        let { userId, newsId } = req.query;
        if (!newsId || !userId) res.json({ read: {} });
        let userIdInt = parseInt(userId);
        let newsIdInt = parseInt(newsId);
        if (isNaN(newsIdInt) == true || isNaN(userIdInt) == true) throw "Error: invalid  userid or newsid";
        let result = await Activity.findReadById(userIdInt, newsIdInt);
        res.json({
            read: result.length ? result[0] : {
                "readed": "N",
                "first_date": null,
                "last_date": null
            }
        });
    } catch (err) {
        console.log("err :", err);
        next(err);
    }
};