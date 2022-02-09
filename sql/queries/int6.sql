.mode columns
.headers on
.nullvalue NULL

DROP VIEW IF EXISTS [tvs];

CREATE VIEW [tvs] AS 
    SELECT
        Content.name as name,
        Content.contentID,
        TVSeries.tvID
    FROM 
        Content JOIN
        TVSeries ON Content.contentID = TVSeries.contentID
    GROUP BY
        Content.contentID;

SELECT
    tvs.name as "Name",
    conRating.score as "General Rating",
    epsRating.score as "Episodes Rating",
    conRating.score - epsRating.score as "Diff"
FROM 
    tvs JOIN 
        (
            SELECT
                tvs.name,
                tvs.contentID,
                avg(ReviewCon.score) as score
            FROM
                tvs JOIN
                ReviewCon ON ReviewCon.contentID = tvs.contentID
            GROUP BY 
                tvs.contentID
            ORDER BY
                ReviewCon.score DESC
        ) conRating
    ON tvs.contentID = epsRating.contentID JOIN
        (
            SELECT
                avg(ReviewEp.score) as score,
                tvs.contentID
            FROM
                tvs JOIN
                Season ON tvs.tvID = Season.tvID JOIN
                Episode ON Season.seasonID = Episode.seasonID JOIN
                ReviewEp ON ReviewEp.episodeID = Episode.episodeID
            GROUP BY
                tvs.contentID
        ) epsRating 
    ON tvs.contentID = conRating.contentID
ORDER BY DIFF DESC;