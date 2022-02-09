.mode columns
.headers on
.nullvalue NULL

SELECT
    scores.name as Name,
    scores.s1 as "First Season",
    scores.fs as "Final Season", 
    (CASE WHEN scores.fs NOT NULL THEN scores.fs-scores.s1 ELSE 'TBD' END) as "Diff"
FROM
    (
        SELECT 
            s.name as Name,
            sum(CASE WHEN s.orderNum = 1 THEN s_avg.score END) as s1,
            sum(CASE WHEN s.orderNum = s.numSeason THEN s_avg.score END) as fs
        FROM
            (
                SELECT
                    tvs.tvID,
                    Season.orderNum,
                    Season.seasonID,
                    tvs.contentID,
                    tvs.name,
                    tvs.numSeason
                FROM 
                    (
                        SELECT
                            Content.name as name,
                            Content.contentID,
                            TVSeries.tvID,
                            TVSeries.numSeason
                        FROM
                            Content JOIN
                            TVSeries ON Content.contentID = TVSeries.contentID
                        WHERE
                            (TVSeries.numSeason != '1')
                        GROUP BY
                            Content.contentID
                    ) tvs
                    JOIN Season ON Season.tvID = tvs.tvID
                WHERE
                    (Season.orderNum = 1 OR Season.orderNum = tvs.numSeason)
            ) s
            JOIN
            (
                SELECT
                    Season.seasonID,
                    avg(ReviewEp.score) as score,
                    Season.orderNum
                FROM
                    Season JOIN Episode ON Season.seasonID = Episode.seasonID 
                    JOIN ReviewEp ON Episode.episodeID = ReviewEp.episodeID
                GROUP BY
                    Season.seasonID
            ) s_avg
            ON s_avg.seasonID = s.seasonID
        GROUP BY
            s.tvID
    ) scores;