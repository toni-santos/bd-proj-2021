.mode columns
.headers on
.nullvalue NULL

.print ''
.print '1 standard deviation above the average'
.print ''

SELECT
    Content.name as Content, Episode.title as Episode, ReviewEp.score-(deviation.Deviation + deviation.avg_score) as Deviation
FROM
    Content JOIN
    TVSeries ON Content.contentID = TVSeries.contentID JOIN
    Season ON Season.tvID = TVSeries.tvID JOIN
    Episode ON Episode.seasonID = Season.seasonID JOIN
    ReviewEp ON ReviewEp.episodeID = Episode.episodeID JOIN
    (
        SELECT 
            sqrt(sum(pow(ReviewEp.score - eps_score.avg_score, 2))/eps_score.cnt) as Deviation, Content.contentID as contentID, eps_score.avg_score
        FROM
            Content JOIN
            TVSeries ON Content.contentID = TVSeries.contentID JOIN
            Season ON Season.tvID = TVSeries.tvID JOIN
            Episode ON Episode.seasonID = Season.seasonID JOIN
            ReviewEp ON ReviewEp.episodeID = Episode.episodeID LEFT JOIN
            (
                SELECT 
                    avg(ReviewEp.score) as avg_score, Content.contentID as cID, count(ReviewEp.score) as cnt
                FROM 
                    Content JOIN
                    TVSeries ON Content.contentID = TVSeries.contentID JOIN
                    Season ON Season.tvID = TVSeries.tvID JOIN
                    Episode ON Episode.seasonID = Season.seasonID JOIN
                    ReviewEp ON ReviewEp.episodeID = Episode.episodeID 
                WHERE
                    (ReviewEp.score NOT NULL)
                GROUP BY 
                    Content.contentID
            ) eps_score
            ON eps_score.cID = Content.contentID
        WHERE
            (ReviewEp.score NOT NULL)
        GROUP BY 
            Content.contentID
        LIMIT (25)
    ) deviation
    ON Content.contentID = deviation.contentID
WHERE
    ReviewEp.score-(deviation.Deviation + deviation.avg_score) > 0
;

.print ''
.print '1 standard deviation below the average'
.print ''

SELECT
    Content.name as Content, Episode.title as Episode, ReviewEp.score-(deviation.Deviation + deviation.avg_score) as Deviation
FROM
    Content JOIN
    TVSeries ON Content.contentID = TVSeries.contentID JOIN
    Season ON Season.tvID = TVSeries.tvID JOIN
    Episode ON Episode.seasonID = Season.seasonID JOIN
    ReviewEp ON ReviewEp.episodeID = Episode.episodeID JOIN
    (
        SELECT 
            sqrt(sum(pow(ReviewEp.score - eps_score.avg_score, 2))/eps_score.cnt) as Deviation, Content.contentID as contentID, eps_score.avg_score
        FROM
            Content JOIN
            TVSeries ON Content.contentID = TVSeries.contentID JOIN
            Season ON Season.tvID = TVSeries.tvID JOIN
            Episode ON Episode.seasonID = Season.seasonID JOIN
            ReviewEp ON ReviewEp.episodeID = Episode.episodeID LEFT JOIN
            (
                SELECT 
                    avg(ReviewEp.score) as avg_score, Content.contentID as cID, count(ReviewEp.score) as cnt
                FROM 
                    Content JOIN
                    TVSeries ON Content.contentID = TVSeries.contentID JOIN
                    Season ON Season.tvID = TVSeries.tvID JOIN
                    Episode ON Episode.seasonID = Season.seasonID JOIN
                    ReviewEp ON ReviewEp.episodeID = Episode.episodeID 
                WHERE
                    (ReviewEp.score NOT NULL)
                GROUP BY 
                    Content.contentID
            ) eps_score
            ON eps_score.cID = Content.contentID
        WHERE
            (ReviewEp.score NOT NULL)
        GROUP BY 
            Content.contentID
        LIMIT (25)
    ) deviation
    ON Content.contentID = deviation.contentID
WHERE
    ReviewEp.score-(deviation.Deviation + deviation.avg_score) < 0
;