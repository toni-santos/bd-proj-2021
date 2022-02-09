.mode columns
.headers on
.nullvalue NULL

DROP VIEW IF EXISTS [wins];

CREATE VIEW [wins] AS 
    SELECT
        Content.name as Name,
        count(CASE WHEN ContentContributorCategoryCeremony.winner = "True" THEN 1 ELSE NULL END) as Num_Wins,
        Content.contentID as contentID
    FROM
        ContentContributorCategoryCeremony JOIN 
        Content ON ContentContributorCategoryCeremony.contentID = Content.contentID JOIN
        Movie ON Content.contentID = Movie.contentID
    WHERE 
        (ContentContributorCategoryCeremony.contributorID IS NULL)
    GROUP BY 
        ContentContributorCategoryCeremony.contentID;

SELECT
    min_wins.Name,
    max(box_off.boxoffice) as Boxoffice
FROM 
    (
        SELECT
            *
        FROM
            wins
        WHERE
            Num_Wins = (
                SELECT
                    min(Num_Wins)
                FROM 
                    wins
                )
    ) min_wins
    JOIN 
        (
            SELECT 
                Content.name,
                Movie.boxoffice, 
                Content.contentID as contentID
            FROM
                Content JOIN
                Movie ON Content.contentID = Movie.contentID
            WHERE
                (Movie.boxoffice NOT NULL)
        ) box_off
    ON min_wins.contentID = box_off.contentID;