USE master;
DROP DATABASE IF EXISTS Travels;
CREATE DATABASE Travels;
USE Travels;

CREATE TABLE Travelers (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100)
) AS NODE;

CREATE TABLE Cities (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Country NVARCHAR(100)
) AS NODE;

CREATE TABLE Attractions (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Type NVARCHAR(50)
) AS NODE;

INSERT INTO Travelers(ID, Name) VALUES 
(1, 'Alexey'),
(2, 'Maria'),
(3, 'Olga'),
(4, 'Dmitry'),
(5, 'Irina'),
(6, 'Nikolay'),
(7, 'Anna'),
(8, 'Vladimir'),
(9, 'Tatyana'),
(10, 'Elena');

INSERT INTO Attractions (ID, Name, Type) VALUES 
(1, 'Eiffel Tower', 'Monument'),
(2, 'Colosseum', 'Historical Building'),
(3, 'Brandenburg Gate', 'Historical Site'),
(4, 'Big Ben', 'Clock'),
(5, 'Sagrada Familia', 'Cathedral'),
(6, 'Tokyo Tower', 'Monument'),
(7, 'Central Park', 'Park'),
(8, 'Charles Bridge', 'Bridge'),
(9, 'Blue Mosque', 'Mosque'),
(10, 'Marina Bay', 'Modern Building');

INSERT INTO Cities (ID, Name, Country) VALUES 
(1, 'Paris', 'France'),
(2, 'Rome', 'Italy'),
(3, 'Berlin', 'Germany'),
(4, 'London', 'UK'),
(5, 'Barcelona', 'Spain'),
(6, 'Tokyo', 'Japan'),
(7, 'New York', 'USA'),
(8, 'Prague', 'Czech Republic'),
(9, 'Istanbul', 'Turkey'),
(10, 'Singapore', 'Singapore');


CREATE TABLE Visited AS EDGE;
CREATE TABLE TraveledWith AS EDGE;
CREATE TABLE RecommendsAttraction AS EDGE;


INSERT INTO Visited ($from_id, $to_id) VALUES
((SELECT $node_id FROM Travelers WHERE ID = 1), (SELECT $node_id FROM Cities WHERE ID = 1)),
((SELECT $node_id FROM Travelers WHERE ID = 2), (SELECT $node_id FROM Cities WHERE ID = 2)),
((SELECT $node_id FROM Travelers WHERE ID = 3), (SELECT $node_id FROM Cities WHERE ID = 3)),
((SELECT $node_id FROM Travelers WHERE ID = 4), (SELECT $node_id FROM Cities WHERE ID = 4)),
((SELECT $node_id FROM Travelers WHERE ID = 5), (SELECT $node_id FROM Cities WHERE ID = 5)),
((SELECT $node_id FROM Travelers WHERE ID = 6), (SELECT $node_id FROM Cities WHERE ID = 6)),
((SELECT $node_id FROM Travelers WHERE ID = 7), (SELECT $node_id FROM Cities WHERE ID = 7)),
((SELECT $node_id FROM Travelers WHERE ID = 8), (SELECT $node_id FROM Cities WHERE ID = 8)),
((SELECT $node_id FROM Travelers WHERE ID = 9), (SELECT $node_id FROM Cities WHERE ID = 9)),
((SELECT $node_id FROM Travelers WHERE ID = 10), (SELECT $node_id FROM Cities WHERE ID = 10)),
((SELECT $node_id FROM Travelers WHERE ID = 1), (SELECT $node_id FROM Cities WHERE ID = 2)),  -- Alexey в Рим
((SELECT $node_id FROM Travelers WHERE ID = 3), (SELECT $node_id FROM Cities WHERE ID = 4)),  -- Olga в Лондон
((SELECT $node_id FROM Travelers WHERE ID = 5), (SELECT $node_id FROM Cities WHERE ID = 6)),  -- Irina в Токио
((SELECT $node_id FROM Travelers WHERE ID = 7), (SELECT $node_id FROM Cities WHERE ID = 3)),  -- Anna в Берлин
((SELECT $node_id FROM Travelers WHERE ID = 8), (SELECT $node_id FROM Cities WHERE ID = 5)),  -- Vladimir в Барселону
((SELECT $node_id FROM Travelers WHERE ID = 9), (SELECT $node_id FROM Cities WHERE ID = 7)),  -- Tatyana в Нью-Йорк
((SELECT $node_id FROM Travelers WHERE ID = 10), (SELECT $node_id FROM Cities WHERE ID = 8));  -- Elena в Прагу




INSERT INTO TraveledWith ($from_id, $to_id) VALUES
((SELECT $node_id FROM Travelers WHERE ID = 1), (SELECT $node_id FROM Travelers WHERE ID = 2)),
((SELECT $node_id FROM Travelers WHERE ID = 3), (SELECT $node_id FROM Travelers WHERE ID = 5)),
((SELECT $node_id FROM Travelers WHERE ID = 4), (SELECT $node_id FROM Travelers WHERE ID = 7)),
((SELECT $node_id FROM Travelers WHERE ID = 6), (SELECT $node_id FROM Travelers WHERE ID = 8)),
((SELECT $node_id FROM Travelers WHERE ID = 9), (SELECT $node_id FROM Travelers WHERE ID = 10)),
((SELECT $node_id FROM Travelers WHERE ID = 2), (SELECT $node_id FROM Travelers WHERE ID = 3)),
((SELECT $node_id FROM Travelers WHERE ID = 7), (SELECT $node_id FROM Travelers WHERE ID = 10)),
((SELECT $node_id FROM Travelers WHERE ID = 1), (SELECT $node_id FROM Travelers WHERE ID = 4)),  -- Новая пара
((SELECT $node_id FROM Travelers WHERE ID = 5), (SELECT $node_id FROM Travelers WHERE ID = 9));  -- Новая пара


INSERT INTO RecommendsAttraction ($from_id, $to_id) VALUES
((SELECT $node_id FROM Travelers WHERE ID = 1), (SELECT $node_id FROM Attractions WHERE ID = 1)),
((SELECT $node_id FROM Travelers WHERE ID = 2), (SELECT $node_id FROM Attractions WHERE ID = 2)),
((SELECT $node_id FROM Travelers WHERE ID = 3), (SELECT $node_id FROM Attractions WHERE ID = 4)),
((SELECT $node_id FROM Travelers WHERE ID = 4), (SELECT $node_id FROM Attractions WHERE ID = 7)),
((SELECT $node_id FROM Travelers WHERE ID = 5), (SELECT $node_id FROM Attractions WHERE ID = 5)),
((SELECT $node_id FROM Travelers WHERE ID = 6), (SELECT $node_id FROM Attractions WHERE ID = 6)),
((SELECT $node_id FROM Travelers WHERE ID = 7), (SELECT $node_id FROM Attractions WHERE ID = 8)),
((SELECT $node_id FROM Travelers WHERE ID = 8), (SELECT $node_id FROM Attractions WHERE ID = 9)),
((SELECT $node_id FROM Travelers WHERE ID = 9), (SELECT $node_id FROM Attractions WHERE ID = 10)),
((SELECT $node_id FROM Travelers WHERE ID = 10), (SELECT $node_id FROM Attractions WHERE ID = 3)),
((SELECT $node_id FROM Travelers WHERE ID = 1), (SELECT $node_id FROM Attractions WHERE ID = 2)), 
((SELECT $node_id FROM Travelers WHERE ID = 2), (SELECT $node_id FROM Attractions WHERE ID = 5)),
((SELECT $node_id FROM Travelers WHERE ID = 4), (SELECT $node_id FROM Attractions WHERE ID = 8));

ALTER TABLE Visited ADD CONSTRAINT EC_Visited CONNECTION (Travelers TO Cities);
ALTER TABLE TraveledWith ADD CONSTRAINT EC_TraveledWith CONNECTION (Travelers TO Travelers);
ALTER TABLE RecommendsAttraction ADD CONSTRAINT EC_RecommendsAttraction CONNECTION (Travelers TO Attractions);


-- Who traveled with Alexey
SELECT 
    t1.Name + ' traveled with ' + t2.Name AS TravelPartners
FROM 
    Travelers AS t1,
    TraveledWith AS tw,
    Travelers AS t2
WHERE 
    MATCH(t1-(tw)->t2)
    AND t1.ID = 1;

-- Who recommended a monument And Bridge
SELECT 
    t.Name + ' recommended ' + a.Name AS Recommendation
FROM 
    Travelers AS t,
    RecommendsAttraction AS r,
    Attractions AS a
WHERE 
    MATCH(t-(r)->a)
    AND a.Type IN ('Monument', 'Bridge');


-- Travelers who visited the same city
SELECT 
    t1.Name + ' and ' + t2.Name + ' visited the same city: ' + c.Name AS CoTravelers
FROM 
    Travelers AS t1,
    Visited AS v1,
    Cities AS c,
    Visited AS v2,
    Travelers AS t2
WHERE 
    MATCH(t1-(v1)->c<-(v2)-t2)
    AND t1.ID < t2.ID;

-- Suggestions based on visited city
SELECT 
    t.Name + ' visited multiple cities: ' + STRING_AGG(c.Name, ', ') AS MultiCityVisit
FROM 
    Travelers AS t,
    Visited AS v,
    Cities AS c
WHERE 
    MATCH(t-(v)->c)
GROUP BY 
    t.Name
HAVING 
    COUNT(c.Name) > 1;




-- Two levels of travel partners from Alexey
SELECT 
    t1.Name + ' traveled with ' + t2.Name AS Level1,
    t2.Name + ' traveled with ' + t3.Name AS Level2
FROM 
    Travelers AS t1,
    TraveledWith AS tw1,
    Travelers AS t2,
    TraveledWith AS tw2,
    Travelers AS t3
WHERE 
    MATCH(t1-(tw1)->t2-(tw2)->t3)
    AND t1.ID = 1;


DECLARE @TravelerFrom NVARCHAR(100) = N'Alexey';
DECLARE @TravelerTo NVARCHAR(100) = N'Maria';

WITH FriendshipPath AS
(
    SELECT 
        T1.Name AS TravelerName,
        STRING_AGG(T2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FriendsPath,
        LAST_VALUE(T2.Name) WITHIN GROUP (GRAPH PATH) AS LastNode
    FROM 
        Travelers AS T1,
        TraveledWith FOR PATH AS TW,
        Travelers FOR PATH AS T2
    WHERE 
        MATCH(SHORTEST_PATH(T1(-(TW)->T2)+))
        AND T1.Name = @TravelerFrom
)
SELECT 
    TravelerName,
    FriendsPath
FROM 
    FriendshipPath
WHERE 
    LastNode = @TravelerTo;


DECLARE @TravelerName NVARCHAR(100) = N'Alexey';

WITH TravelerVisitedCities AS 
(
    SELECT 
        C.Name AS CityName,
        C.Country AS Country
    FROM 
        Travelers AS T,
        Visited AS V,
        Cities AS C
    WHERE 
        MATCH(T-(V)->C)
        AND T.Name = @TravelerName
),
TravelerRecommendedAttractions AS
(
    SELECT 
        A.Name AS AttractionName,
        A.Type AS AttractionType
    FROM 
        Travelers AS T,
        RecommendsAttraction AS R,
        Attractions AS A
    WHERE 
        MATCH(T-(R)->A)
        AND T.Name = @TravelerName
)
SELECT 
    'Cities' AS DataType,
    CityName AS Name,
    Country AS AdditionalInfo
FROM 
    TravelerVisitedCities
UNION ALL
SELECT 
    'Attractions' AS DataType,
    AttractionName AS Name,
    AttractionType AS AdditionalInfo
FROM 
    TravelerRecommendedAttractions;