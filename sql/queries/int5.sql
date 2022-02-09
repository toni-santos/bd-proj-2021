.mode columns
.headers on
.nullvalue NULL

SELECT 
	title as Name,
	max(cnt) as 'No. Winning Contributors'
FROM (
	SELECT 
		count(*) as cnt,
		ids.title as title
	FROM (
		SELECT
			Contributor.contributorID as personID,
			Content.contentID as contentID,
			Contributor.name as name, 
			Content.name as title
        FROM 
			ContentContributorCategoryCeremony NATURAL LEFT JOIN
			Contributor NATURAL LEFT JOIN
			ContentRoleContributor LEFT JOIN Content ON ContentRoleContributor.contentID = Content.contentID
        WHERE
			(ContentContributorCategoryCeremony.contributorID NOT NULL AND ContentContributorCategoryCeremony.winner="True")
		GROUP BY
			ContentContributorCategoryCeremony.contributorID
	) ids
	GROUP BY ids.contentID
);