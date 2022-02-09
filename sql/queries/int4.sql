.mode columns
.headers on
.nullvalue NULL

DROP VIEW IF EXISTS [n_noms];

CREATE VIEW [n_noms] AS
    SELECT 
        Contributor.name as Name,
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
        Number_Nominations DESC;

SELECT 
    n_noms.Name,
    n_noms.Number_Nominations
FROM
    n_noms
WHERE 
    n_noms.Number_Nominations = (SELECT max(n_noms.Number_Nominations) FROM n_noms);