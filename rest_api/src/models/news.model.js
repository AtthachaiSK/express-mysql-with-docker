const connection = require("./connection");

const News = function (news) {
    this.titleTh = news.titleTh;
    this.titleEn = news.titleEn;
};

News.findNewsIdByUserId = (id) => {
    return new Promise(function (resolve, reject) {
        const _sql = `SELECT id , title_th  FROM NEWS WHERE id IN   (SELECT news_id FROM NEWS_USERS where users_id = ?); `;
        connection.query({ sql: _sql, timeout: 40000 }, [id], function (err, res) {
            if (err) {
                console.error("error: ", err);
                reject(err);
                return;
            }
            if (res) {
                resolve(res);
                return;
            }

        })
    });
}

News.findDetailNewsByNewsId = (userId, newsId) => {
    return new Promise(function (resolve, reject) {
        const _sql = `SELECT title_th,title_en, detail_th, detail_en ,start_date, stop_date FROM NEWS WHERE id IN   (SELECT news_id FROM NEWS_USERS where users_id = ? and news_id = ?)`;
        connection.query({ sql: _sql, timeout: 40000 }, [userId, newsId], function (err, res) {
            if (err) {
                console.error("error: ", err);
                reject(err);
                return;
            }
            if (res) {
                resolve(res);
                return;
            }

        })
    });
}

News.findDetailNewsByNewsIdAndLang = (userId, newsId, lang) => {
    return new Promise(function (resolve, reject) {
        let _sql;
        if (lang == "th") {
            _sql = `SELECT title_th, detail_th ,start_date, stop_date FROM NEWS WHERE id IN   (SELECT news_id FROM NEWS_USERS where users_id = ? and news_id = ?)`;
        } else {
            _sql = `SELECT title_en, detail_en ,start_date, stop_date FROM NEWS WHERE id IN   (SELECT news_id FROM NEWS_USERS where users_id = ? and news_id = ?)`;
        }
        connection.query({ sql: _sql, timeout: 40000 }, [userId, newsId], function (err, res) {
            if (err) {
                console.error("error: ", err);
                reject(err);
                return;
            }
            if (res) {
                resolve(res);
                return;
            }

        })
    });
}

module.exports = News;