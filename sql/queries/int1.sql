.mode columns
.headers on
.nullvalue NULL

.print ''
.print 'Example filtering with Action'
.print ''


SELECT
    Content.name as Title,
    Genre.name as Genre,
    max(ReviewCon.score) as Score
FROM 
    Content JOIN 
    ReviewCon ON ReviewCon.contentID = Content.contentID JOIN
    Genre ON Genre.genreID = PartOfGenre.genreID JOIN
    PartOfGenre ON Content.contentID = PartOfGenre.contentID
WHERE (Genre.name = "Action");

.print ''
.print 'Example filtering with Fantasy'
.print ''

SELECT 
    Content.name as Title,
    Genre.name as Genre,
    max(ReviewCon.score) as Score
FROM
    Content JOIN
    ReviewCon ON ReviewCon.contentID = Content.contentID JOIN
    Genre ON Genre.genreID = PartOfGenre.genreID JOIN
    PartOfGenre ON Content.contentID = PartOfGenre.contentID
WHERE (Genre.name = "Fantasy");