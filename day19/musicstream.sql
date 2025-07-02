CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Songs (
    SongID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    Artist VARCHAR(100) NOT NULL,
    PlayCount INT DEFAULT 0
);

CREATE TABLE Playlists (
    PlaylistID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    PlaylistName VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE PlaylistSongs (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    PlaylistID INT,
    SongID INT,
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID)
);


-- Insert Users
INSERT INTO Users (UserName, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666');

-- Insert Songs
INSERT INTO Songs (Title, Artist, PlayCount)
VALUES
('Shape of You', 'Ed Sheeran', 50),
('Blinding Lights', 'The Weeknd', 70),
('Believer', 'Imagine Dragons', 60);

-- Insert Playlists
INSERT INTO Playlists (UserID, PlaylistName)
VALUES
(1, 'Workout Mix'),
(1, 'Chill Vibes'),
(2, 'Morning Boost'),
(2, 'Study Session'),
(2, 'Evening Relax');

-- Insert PlaylistSongs
INSERT INTO PlaylistSongs (PlaylistID, SongID)
VALUES
(1, 1), -- Shape of You in Workout Mix
(1, 2), -- Blinding Lights in Workout Mix
(2, 3), -- Believer in Chill Vibes
(3, 1), -- Shape of You in Morning Boost
(4, 2), -- Blinding Lights in Study Session
(5, 3); -- Believer in Evening Relax


SELECT SongID, Title, Artist, PlayCount
FROM Songs
ORDER BY PlayCount DESC
LIMIT 5;  -- Top 5 songs


SELECT u.UserID, u.UserName, COUNT(p.PlaylistID) AS PlaylistCount
FROM Users u
JOIN Playlists p ON u.UserID = p.UserID
GROUP BY u.UserID, u.UserName
HAVING COUNT(p.PlaylistID) > 2;
