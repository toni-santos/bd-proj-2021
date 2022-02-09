DROP TABLE IF EXISTS Content;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS TVSeries;
DROP TABLE IF EXISTS Season;
DROP TABLE IF EXISTS Episode;
DROP TABLE IF EXISTS Reviewer;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Contributor;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Ceremony;
DROP TABLE IF EXISTS ReviewEp;
DROP TABLE IF EXISTS ReviewCon;
DROP TABLE IF EXISTS PartOfGenre;
DROP TABLE IF EXISTS ContentRoleContributor;
DROP TABLE IF EXISTS ContentContributorCategoryCeremony;

CREATE TABLE Content (
    contentID INTEGER UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL, 
    parentalRating VARCHAR(255), 
    poster TEXT, 
    plot TEXT, 
    PRIMARY KEY(contentID)
);

CREATE TABLE Movie (
    movieID INTEGER UNIQUE NOT NULL, 
    contentID INTEGER NOT NULL,
    runtime INTEGER CHECK (runtime>0), 
    year INTEGER CHECK (year>0), 
    boxoffice VARCHAR(255), 
    PRIMARY KEY (movieID), 
    FOREIGN KEY (contentID) REFERENCES Content(contentID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE TVSeries (
    tvID INTEGER UNIQUE NOT NULL, 
    contentID INTEGER NOT NULL, 
    startDate DATE,
    endDate DATE CHECK (endDate>=startDate),
    numSeason INTEGER,
    numEpisode INTEGER, 
    PRIMARY KEY (tvID), 
    FOREIGN KEY (contentID) REFERENCES Content(contentID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Season (
    seasonID INTEGER UNIQUE NOT NULL, 
    tvID INTEGER NOT NULL, 
    startDate DATE,
    endDate DATE CHECK (endDate>=startDate),
    orderNum INTEGER CHECK (orderNum>0),
    numEpisode INTEGER CHECK (numEpisode>0), 
    PRIMARY KEY (seasonID), 
    FOREIGN KEY (tvID) REFERENCES TVSeries(tvID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Episode (
    episodeID INTEGER UNIQUE NOT NULL, 
    seasonID INTEGER NOT NULL, 
    title VARCHAR(255) NOT NULL,
    PRIMARY KEY (episodeID), 
    FOREIGN KEY (seasonID) REFERENCES Season(seasonID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Reviewer (
    reviewerID INTEGER UNIQUE NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    PRIMARY KEY (reviewerID)
);

CREATE TABLE Genre (
    genreID INTEGER UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL, 
    PRIMARY KEY (genreID)
);

CREATE TABLE Role (
    roleID INTEGER UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL, 
    PRIMARY KEY (roleID)
);

CREATE TABLE Contributor (
    contributorID INTEGER UNIQUE NOT NULL, 
    name VARCHAR(255) NOT NULL,
    yob INTEGER CHECK (yob>0),
    knownFor TEXT, 
    PRIMARY KEY (contributorID)
);

CREATE TABLE Category (
    categoryID INTEGER UNIQUE NOT NULL,
    name TEXT UNIQUE NOT NULL,
    type TEXT NOT NULL,
    PRIMARY KEY (categoryID)
);

CREATE TABLE Ceremony (
    year INTEGER NOT NULL, 
    name TEXT NOT NULL,
    ceremonyID INTEGER NOT NULL,
    PRIMARY KEY (ceremonyID)
);

CREATE TABLE ReviewEp (
    reviewerID INTEGER NOT NULL,
    episodeID INTEGER NOT NULL,
    score REAL CHECK (score>=0),
    comment TEXT,
    PRIMARY KEY (reviewerID, episodeID),
    FOREIGN KEY (reviewerID) REFERENCES Reviewer (reviewerID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (episodeID) REFERENCES Episode (episodeID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ReviewCon (
    reviewerID INTEGER,
    contentID INTEGER NOT NULL,
    score REAL CHECK (score>=0),
    comment TEXT,
    PRIMARY KEY (reviewerID, contentID),
    FOREIGN KEY (reviewerID) REFERENCES Reviewer (reviewerID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (contentID) REFERENCES Content (contentID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE PartOfGenre (
    genreID INTEGER NOT NULL,
    contentID INTEGER NOT NULL,
    PRIMARY KEY (genreID, contentID),
    FOREIGN KEY (genreID) REFERENCES Genre (genreID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (contentID) REFERENCES Content (contentID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ContentRoleContributor (
    contentID INTEGER NOT NULL,
    roleID INTEGER NOT NULL,
    contributorID INTEGER NOT NULL,
    PRIMARY KEY (roleID, contentID, contributorID),
    FOREIGN KEY (contentID) REFERENCES Content (contentID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (roleID) REFERENCES Role (roleID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (contributorID) REFERENCES Contributor (contributorID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ContentContributorCategoryCeremony (
    nominationID INTEGER NOT NULL,
    contentID INTEGER NOT NULL,
    categoryID INTEGER NOT NULL,
    contributorID INTEGER,
    ceremonyID INTEGER,
    winner BOOLEAN NOT NULL,
    PRIMARY KEY (nominationID),
    FOREIGN KEY (contentID) REFERENCES Content (contentID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (categoryID) REFERENCES Category (categoryID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (contributorID) REFERENCES Contributor (contributorID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ceremonyID) REFERENCES Ceremony (ceremonyID) ON DELETE RESTRICT ON UPDATE CASCADE
);