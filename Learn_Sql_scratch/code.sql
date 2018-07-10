-- Question 2: What is the number of responses for each question?


‘SELECT question,
   COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;'



-- Question 4:


SELECT * FROM quiz
LIMIT 10;


SELECT * FROM home_try_on
LIMIT 10;


SELECT * FROM purchase
LIMIT 10;


-- Question 5:


SELECT DISTINCT q.user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz as q
LEFT JOIN home_try_on as h ON q.user_id=h.user_id 
LEFT JOIN purchase as p ON q.user_id=p.user_id 
LIMIT 10;


-- Question 6




Overall Conversion Rate:


WITH funnels AS (SELECT DISTINCT q.user_id AS user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz as q
LEFT JOIN home_try_on as h ON q.user_id=h.user_id 
LEFT JOIN purchase as p ON q.user_id=p.user_id)
SELECT COUNT(*), sum(is_home_try_on) as  'num_is_home_try_on', sum(is_purchase) as  'num_purchase',100.0 * SUM(is_home_try_on) / COUNT(user_id) as '% browse home_try_on',
100.0 * SUM(is_purchase) / COUNT(is_home_try_on)
as '% try_at_home to purchase' FROM funnels;


-- Purchase rates between customers who had 3 number_of_pairs with ones who had 5.


WITH funnels AS (SELECT DISTINCT q.user_id AS user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs as number_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz as q
LEFT JOIN home_try_on as h ON q.user_id=h.user_id 
LEFT JOIN purchase as p ON q.user_id=p.user_id)
SELECT number_pairs, COUNT(*),
100.0 * SUM(is_purchase) / COUNT(is_home_try_on)
as '% home_try_on to purchase' FROM funnels
WHERE number_pairs IS NOT NULL
GROUP BY 1;


-- Analyse average order size


WITH funnels AS (SELECT DISTINCT q.user_id AS user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs as number_pairs,
p.user_id IS NOT NULL AS 'is_purchase', p.price as price
FROM quiz as q
LEFT JOIN home_try_on as h ON q.user_id=h.user_id 
LEFT JOIN purchase as p ON q.user_id=p.user_id)
SELECT number_pairs, COUNT(*),
100.0 * SUM(is_purchase) / COUNT(is_home_try_on)
as '% browse to purchase', SUM(price), AVG(price) FROM funnels
WHERE number_pairs IS NOT NULL
GROUP BY 1;