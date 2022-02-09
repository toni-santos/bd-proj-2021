.mode columns
.headers on
.nullvalue NULL

SELECT 
    Content.name as Content,
    Episode.title as Title,
    max(ReviewEp.score) as Score
FROM 
    Content LEFT NATURAL JOIN
    ReviewCon JOIN
    TVSeries ON Content.contentID = TVSeries.contentID JOIN
    Season ON TVSeries.tvID = Season.tvID JOIN
    Episode ON Episode.seasonID = Season.seasonID JOIN
    ReviewEp ON ReviewEp.episodeID = Episode.episodeID;