Recommendation Logic


-- Find similar users based on movie ratings
CREATE VIEW User_Similarity AS
SELECT
    r1.user_id AS user_id1,
    r2.user_id AS user_id2,
    COUNT(*) AS common_ratings
FROM Ratings r1
JOIN Ratings r2
ON r1.movie_id = r2.movie_id AND r1.user_id <> r2.user_id
WHERE r1.rating = r2.rating
GROUP BY r1.user_id, r2.user_id;

-- Find movies liked by similar users
CREATE VIEW Recommendations AS
SELECT
    r1.user_id AS user_id,
    m.movie_id,
    m.title,
    COUNT(*) AS recommendation_score
FROM Ratings r1
JOIN Ratings r2 ON r1.user_id = r2.user_id
JOIN Movies m ON r2.movie_id = m.movie_id
WHERE r1.rating >= 8 -- Only consider high ratings
GROUP BY r1.user_id, m.movie_id
ORDER BY recommendation_score DESC;


Content-Based Filtering:

-- Find movies with similar genres
CREATE VIEW Genre_Similarity AS
SELECT
    m1.movie_id AS movie_id1,
    m2.movie_id AS movie_id2,
    COUNT(*) AS common_genres
FROM Movie_Genres mg1
JOIN Movie_Genres mg2 ON mg1.genre_id = mg2.genre_id
JOIN Movies m1 ON mg1.movie_id = m1.movie_id
JOIN Movies m2 ON mg2.movie_id = m2.movie_id
WHERE m1.movie_id <> m2.movie_id
GROUP BY m1.movie_id, m2.movie_id;

-- Recommend movies based on similar genres
CREATE VIEW Content_Based_Recommendations AS
SELECT
    r.user_id,
    m.movie_id,
    m.title,
    gs.common_genres AS recommendation_score
FROM Ratings r
JOIN Genre_Similarity gs ON r.movie_id = gs.movie_id1
JOIN Movies m ON gs.movie_id2 = m.movie_id
WHERE r.rating >= 8 -- Only consider high ratings
GROUP BY r.user_id, m.movie_id
ORDER BY recommendation_score DESC;
