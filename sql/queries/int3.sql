.mode columns
.headers on
.nullvalue NULL

SELECT 
    Contributor.name as Name,
    Role.name as Role,
    Content.name as Content,
    ReviewCon.score as Score
FROM 
    ContentRoleContributor JOIN 
    Contributor ON ContentRoleContributor.contributorID = Contributor.contributorID JOIN
    Content ON ContentRoleContributor.contentID = Content.contentID JOIN
    Role ON ContentRoleContributor.roleID = Role.roleID JOIN
    ReviewCon ON Content.contentID = ReviewCon.contentID
WHERE 
    (ReviewCon.score >= 90)
GROUP BY Contributor.name
ORDER BY Content.name;