const connection = require("./connection");



const Activity = function (activity) {
    this.userId = activity.userId;
};

Activity.updateActivityById = (userId, newsId) => {
    return new Promise(function (resolve, reject) {
        const _sql = `call update_or_insert_activity(?,?);`;
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

Activity.findReadById = (userId, newsId) => {
    return new Promise(function (resolve, reject) {
        const _sql = `select readed , DATE_FORMAT(first_read_date, "%M %e, %Y %H:%i") as first_date ,DATE_FORMAT(last_read_date, "%M %e, %Y %H:%i") as last_date from ACTIVITY where user_id = ? and news_id = ?`;
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

module.exports = Activity;
