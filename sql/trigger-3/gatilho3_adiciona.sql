CREATE TRIGGER IF NOT EXISTS T3
BEFORE INSERT ON ContentContributorCategoryCeremony
FOR EACH ROW
WHEN NOT EXISTS (SELECT * FROM ContentRoleContributor WHERE contentID = NEW.contentID AND contributorID = NEW.contributorID) 
BEGIN
    SELECT RAISE(ABORT, 'This contributor has not participated in this movie!');
END;
