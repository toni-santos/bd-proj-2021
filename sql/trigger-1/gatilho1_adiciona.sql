CREATE TRIGGER IF NOT EXISTS T1
BEFORE INSERT ON ContentContributorCategoryCeremony
FOR EACH ROW
WHEN EXISTS (SELECT * FROM TVSeries WHERE contentID = NEW.contentID) AND EXISTS (SELECT * FROM Category WHERE categoryID = NEW.categoryID AND Category.type = "Movie")
BEGIN
    SELECT RAISE(ABORT, "A TV Series cannot be nominated for a prize concerning movies!");
END;
