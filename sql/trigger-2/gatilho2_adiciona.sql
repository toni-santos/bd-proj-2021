CREATE TRIGGER IF NOT EXISTS T2
AFTER INSERT ON Episode
FOR EACH ROW
BEGIN
    UPDATE Season
    SET numEpisode = numEpisode + 1
    WHERE seasonID = NEW.seasonID;
    UPDATE TVSeries
    SET numEpisode = numEpisode + 1
    WHERE (SELECT numEpisode FROM Season WHERE TVSeries.tvID = Season.tvID AND Season.seasonID = NEW.seasonID);
END;
