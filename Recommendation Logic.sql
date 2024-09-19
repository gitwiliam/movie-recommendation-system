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
