CREATE DATABASE SocialNetwork
USE SocialNetwork

CREATE TABLE Posts
(
	Id INT PRIMARY KEY IDENTITY,
	Content NVARCHAR(200),
	SharedDate DATETIME DEFAULT GETDATE(),
	UserId INT references Users(Id),
	IsDeleted BIT DEFAULT 0
)

ALTER TABLE Posts
ADD LikeCount INT

CREATE TABLE Users
(
	Id INT IDENTITY PRIMARY KEY,
	Login VARCHAR(30),
	Password NVARCHAR(50),
	Email NVARCHAR(50),
)

ALTER TABLE Users
ALTER COLUMN Email VARCHAR(50)

CREATE TABLE Comments 
(	
	Id INT IDENTITY PRIMARY KEY,
	UserId INT references Users(Id),
	PostId INT references Posts(Id),
	LikeCount INT,
	IsDeleted BIT DEFAULT 0
)

CREATE TABLE People
(
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50),
	Surname NVARCHAR(50),
	Age INT,
	UserId INT references Users(Id)
)

INSERT INTO Users
VALUES
('a1iiko', 'ali123', 'alim@gmail.com'),
('raminsafarli', 'ramin123', 'raminas@gmail.com'),
('seyfinafjafli', 'seyfi123', 'seyfin@gmail.com')


INSERT INTO People
VALUES
('Ali', 'Mammadov', 20, 1), ('Ramin', 'Safarli', 20, 2),
('Seyfi', 'Nadjafli', 20, 3)

INSERT INTO Posts (Content, UserId, IsDeleted, LikeCount)
VALUES
('Learning English Phrases', 1, 0, 50),
('HTML tags', 1, 0, 70),
('CSS flexbox', 1, 0, 90),
('CSS animations', 2, 0, 60),
('JS objects', 2, 0, 80),
('JS functions', 2, 0, 100),
('jQuery', 2, 0, 120),
('How to install Bootstrap', 2, 0, 140),
('SASS, SCSS', 3, 0, 40),
('How to create responsive nav bar', 3, 0, 65),
('Advanced JS', 3, 0, 88),
('SQL Constraints', 3, 0, 125)


SELECT * FROM Comments

INSERT INTO Comments
VALUES
(2, 1, 15, 0), (3, 2, 10, 0), (2, 3, 5, 0), (3, 3, 7, 0),
(1, 4, 10, 0), (3, 5, 8, 0), (1, 6, 18, 0), (3, 6, 20, 0), (3, 7, 3, 0), (1, 8, 25, 0), (2, 8, 12, 0), (3, 8, 14, 0),
(1, 9, 6, 0), (2, 10, 7, 0), (1, 11, 38, 0), (2, 11, 45, 0), (1, 12, 56, 0), (2, 12, 74, 0), (3, 12, 27, 0) 

--Task 1
SELECT p.Content AS 'Post content', COUNT(c.Id) AS 'Comment number' FROM Posts AS p
JOIN Comments AS c
ON p.Id = c.PostId
GROUP BY p.Content

--Task 2
CREATE VIEW allData AS
SELECT (p.Name + ' ' + p.Surname) AS Fullname, 
p.Age AS Age,
u.Login AS 'User login',
u.Email AS 'User Email',
po.Content AS 'Post Content',
po.SharedDate AS 'Shared date', 
po.LikeCount AS 'Like count' FROM People AS p
JOIN Users AS u
ON p.UserId = u.Id
JOIN Posts AS po
ON po.UserId = u.Id
JOIN Comments AS c
ON c.PostId = po.Id

SELECT * FROM allData

-- Task 3
CREATE TRIGGER UpdateInsteadOfDelete
ON Comments
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Id INT
	SELECT @Id = Id FROM deleted
	UPDATE Comments SET IsDeleted = 1 WHERE Id = @Id
END

DELETE Comments
WHERE Id = 3

CREATE TRIGGER UpdateInsteadOfDeleteLike
ON Posts
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Id INT
	SELECT @Id = Id FROM  deleted
	UPDATE Posts SET IsDeleted = 1 WHERE Id = @Id
END


DELETE Posts
WHERE Id = 3



-- Task 4
CREATE PROCEDURE usp_LikePost (@PostId INT)
AS
BEGIN
	UPDATE Posts SET Posts.LikeCount = Posts.LikeCount + 1 WHERE Posts.Id = @PostId
END

EXEC usp_LikePost @PostId = 2

-- Task 5
CREATE PROCEDURE usp_ResetPassword (@loginOrEmail VARCHAR(50), @newPassword NVARCHAR(100))
AS 
BEGIN
	UPDATE Users SET Users.Password = @newPassword WHERE Users.Email = @loginOrEmail or Users.Login = @loginOrEmail
END

EXEC usp_ResetPassword 'a1iiko', 'ali321'
EXEC usp_ResetPassword 'raminas@gmail.com', 'ramin321'







