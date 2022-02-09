.mode columns
.headers on
.nullvalue NULL

SELECT 
    numNoms.Name as Name,
    numNoms.Number_Nominations as Nominations,
    numWins.Number_Wins as Wins,
    numWins.Number_Wins*100.0/numNoms.Number_Nominations as Ratio
FROM 
        (
            SELECT
                Contributor.name as Name,
                Contributor.contributorID as contributorID,
                count(ContentContributorCategoryCeremony.contributorID = Contributor.contributorID) as Number_Nominations
            FROM
                ContentContributorCategoryCeremony LEFT JOIN
                Contributor ON ContentContributorCategoryCeremony.contributorID = Contributor.contributorID LEFT JOIN
                Content ON ContentContributorCategoryCeremony.contentID = Content.contentID
            WHERE
                (ContentContributorCategoryCeremony.contributorID NOT NULL)
            GROUP BY 
                Contributor.contributorID
            ORDER BY 
                Number_Nominations DESC
        ) numNoms
    JOIN 
        (
            SELECT 
                Contributor.name as Name,
                Contributor.contributorID,
                count(CASE WHEN ContentContributorCategoryCeremony.winner = "True" THEN 1 ELSE NULL END) as Number_Wins
            FROM 
                ContentContributorCategoryCeremony LEFT JOIN
                Contributor ON ContentContributorCategoryCeremony.contributorID = Contributor.contributorID LEFT JOIN
                Content ON ContentContributorCategoryCeremony.contentID = Content.contentID
            WHERE
                (ContentContributorCategoryCeremony.contributorID NOT NULL)
            GROUP BY 
                Contributor.contributorID
            ORDER BY
                Number_Wins DESC
        ) numWins
    ON numNoms.contributorID = numWins.contributorID
ORDER BY Ratio DESC;