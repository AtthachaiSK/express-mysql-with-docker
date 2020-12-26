exports.getNews = async (req, res, next) => {
    try {
        res.json({
            news: "wwww"
        });
    } catch (err) {
        next(err);
    }
};