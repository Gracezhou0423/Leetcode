LeetCode SQL

# 175. Combine Two Tables


SELECT P.FirstName, P.LastName, A.City, A.State
FROM Person AS P LEFT JOIN Address AS A ON P.PersonId = A.PersonId
;


# 181. Employees Earning More Than Their Managers

SELECT E1.Name AS Employee
FROM Employee E1 INNER JOIN Employee E2 ON E1.ManagerId = E2.Id 
WHERE E1.Salary > E2.Salary
;

# 182. Duplicate Emails

SELECT Email
FROM Person 
GROUP BY 1 
HAVING COUNT(DISTINCT Id) > 1
;

# 183. Customers Who Never Order

# Option 1 
SELECT Name AS Customers
FROM Customers 
WHERE Id NOT IN (SELECT DISTINCT CustomerId FROM Orders)
;

# Option 2

SELECT C.Name AS Customers
FROM Customers C LEFT JOIN Orders O ON C.Id = O.CustomerId
WHERE O.CustomerId IS NULL
;

# 196. Delete Duplicate Emails

SELECT mid AS Id, Email
FROM 
(SELECT Email, MIN(Id) AS mid
FROM Person 
GROUP BY 1) AS TEMP 
;

# delte version 
DELETE P1 FROM Person P1 INNER JOIN Person P2 ON P1.Email = P2.Email 
WHERE P1.Id > p2.Id;

# 197. Rising Temperature

SELECT DISTINCT W1.Id
FROM Weather W1 INNER JOIN Weather W2 ON DATEDIFF(W1.RecordDate, W2.RecordDate) = 1
WHERE W1.Temperature > W2.Temperature 
;

# 511. Game Play Analysis I

SELECT player_id, MIN(event_date) as first_login
FROM Activity 
GROUP BY 1
;

# 512. Game Play Analysis II

SELECT player_id, device_id
FROM (SELECT player_id, device_id, ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date ASC) AS rnk
FROM Activity) AS TEMP 
WHERE rnk = 1
;

# 577. Employee Bonus

SELECT DISTINCT E.name, B.bonus
FROM Employee E LEFT JOIN Bonus B ON E.empId = B.empId 
WHERE B.bonus < 1000 OR B.bonus IS NULL 
;

# 584. Find Customer Referee

SELECT DISTINCT name 
FROM customer 
WHERE referee_id != 2 OR referee_id IS NULL 
;


# 586. Customer Placing the Largest Number of Orders

SELECT customer_number
FROM 
(SELECT customer_number, COUNT(DISTINCT order_number) as orders
FROM Orders
GROUP BY 1) AS TEMP 
ORDER BY orders DESC
LIMIT 1;


SELECT customer_number
FROM Orders 
GROUP BY 1 
ORDER BY COUNT(DISTINCT order_number) DESC 
LIMIT 1;


# 595. Big Countries

SELECT name, population, area
FROM World
WHERE area > 3000000 OR population > 25000000
;


# 596. Classes More Than 5 Students

SELECT class
FROM courses 
GROUP BY 1
HAVING COUNT(DISTINCT student) >= 5
;


# 597. Friend Requests I: Overall Acceptance Rate

SELECT 
COALESCE(ROUND((SELECT COUNT(DISTINCT requester_id, accepter_id) as acpts
FROM  RequestAccepted) /
(SELECT COUNT(DISTINCT sender_id, send_to_id) as reqs 
FROM FriendRequest), 2), 0) AS accept_rate
;

Follow up:
# Could you write a query to return the acceptance rate for every month?

WITH N AS (
SELECT MONTH(accept_date) AS M, COUNT(DISTINCT requester_id, accepter_id) as acpts
FROM  RequestAccepted
GROUP BY 1 
),

D AS (
SELECT MONTH(request_date) AS M, COUNT(DISTINCT sender_id, send_to_id) as reqs 
FROM FriendRequest
GROUP BY 1
)

SELECT COALESCE(N.M, D.M) AS month, ROUND(COALESCE(N.acpts/M.reqs, 0), 2) AS accept_rate
FROM N FULL OUTER JOIN D ON N.M=D.M;


# Could you write a query to return the cumulative acceptance rate for every day?

WITH N AS (SELECT T1.date, COUNT(DISTINCT T2.requester_id, T2.accepter_id) as acpts
FROM RequestAccepted T1 LEFT JOIN RequestAccepted T2 ON T1.date >= T2.date
GROUP BY 1),
D AS (

SELECT T1.date, COUNT(DISTINCT T2.sender_id, T2.send_to_id) as reqs 
FROM FriendRequest T1 LEFT JOIN FriendRequest T2 ON T1.date >= T2.date 
GROUP BY 1
) 


SELECT COALESCE(N.date, D.date) as date, ROUND(COALESCE(N.acpts/D.reqs, 0), 2) AS accept_rate
FROM N FULL OUTER JION D ON N.date = D.date 


# 603. Consecutive Available Seats


SELECT DISTINCT C1.seat_id
FROM cinema C1 INNER JOIN cinema C2 ON ABS(C1.seat_id - C2.seat_id) = 1 
WHERE C1.free = 1 AND C2.free = 1 
ORDER BY 1
;

# 607. Sales Person

SELECT name
FROM salesperson
WHERE sales_id NOT IN (
SELECT DISTINCT sales_id 
FROM orders O LEFT JOIN company C ON O.com_id = C.com_id
WHERE C.name = "RED"
)
;

# 610. Triangle Judgement

SELECT x, y, z, CASE WHEN (x+y>z and x+z>y and y+z>x ) THEN  'Yes' ELSE 'No' END AS triangle
FROM triangle
;

# 613. Shortest Distance in a Line

SELECT MIN(ABS(P1.x - P2.x)) AS shortest
FROM point P1 INNER JOIN point P2 ON P1.x != P2.x 
;

# 619. Biggest Single Number

SELECT MAX(num) as num
FROM 
(SELECT num
FROM my_numbers
GROUP BY num 
HAVING COUNT(*) = 1) AS TEMP 
;


# 620. Not Boring Movies

SELECT * 
FROM Cinema
WHERE id %2 = 1 AND description != "boring"
ORDER BY rating DESC;


# 627. Swap Salary

UPDATE salary 
SET sex = IF (sex = "m", "f", "m");

# 1050. Actors and Directors Who Cooperated At Least Three Times

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY 1, 2
HAVING COUNT(DISTINCT timestamp) >= 3
;


# 1068. Product Sales Analysis I

SELECT DISTINCT P.product_name, S.year, S.price
FROM Sales S LEFT JOIN Product P on S.product_id = P.product_id 
;

# 1069. Product Sales Analysis II

SELECT product_id, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY 1
;


SELECT DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id) AS total_quantity
FROM Sales

;


# 1075. Project Employees I

SELECT project_id, ROUND(AVG(E.experience_years), 2) AS average_years
FROM Project P LEFT JOIN Employee E on E.employee_id = P.employee_id
GROUP BY 1
;

SELECT DISTINCT project_id, ROUND(AVG(E.experience_years) OVER (PARTITION BY P.project_id), 2) AS average_years
FROM Project P LEFT JOIN Employee E on E.employee_id = P.employee_id
;

# 1076. Project Employees II


SELECT DISTINCT project_id
FROM (SELECT *, DENSE_RANK() OVER (ORDER BY employees DESC) AS RK
FROM (SELECT project_id, COUNT(DISTINCT employee_id) AS employees
FROM Project
GROUP BY 1) AS TEMP) AS T2
WHERE RK = 1
;

# 1082. Sales Analysis I
SELECT DISTINCT seller_id
FROM 
(SELECT DISTINCT seller_id, DENSE_RANK() OVER(ORDER BY total_price DESC) AS rk
FROM (SELECT seller_id, SUM(price) as total_price
FROM Sales
GROUP BY 1) AS T1) AS T2
WHERE rk = 1
;


# 1083. Sales Analysis II
SELECT DISTINCT P1.buyer_id
FROM
(SELECT DISTINCT S.buyer_id, P.product_name
FROM Sales AS S INNER JOIN Product P on S.product_id = P.product_id
WHERE P.product_name = "S8") AS P1 
LEFT JOIN (
SELECT DISTINCT S.buyer_id, P.product_name
FROM Sales AS S INNER JOIN Product P on S.product_id = P.product_id
WHERE P.product_name = "iPhone"
) AS P2 
ON P2.buyer_id = P1.buyer_id
WHERE P2.buyer_id IS NULL
;

SELECT DISTINCT S.buyer_id
FROM Sales AS S INNER JOIN Product P on S.product_id = P.product_id
WHERE P.product_name = "S8" 
AND S.buyer_id NOT IN (
SELECT DISTINCT buyer_id
FROM Sales AS S INNER JOIN Product P on S.product_id = P.product_id
WHERE P.product_name = "iPhone"
);

# 1084. Sales Analysis III

SELECT DISTINCT S.product_id, P.product_name
FROM Sales S INNER JOIN Product P ON S.product_id = P.product_id
WHERE sale_date >= "2019-01-01" AND sale_date <= "2019-03-31"
AND S.product_id NOT IN (
SELECT DISTINCT product_id 
FROM Sales
WHERE sale_date < "2019-01-01" OR sale_date > "2019-03-31"
)
;


SELECT DISTINCT P3.product_id, P.product_name
FROM 
(SELECT DISTINCT P1.product_id
FROM 
(
SELECT DISTINCT product_id
FROM Sales
WHERE sale_date >= "2019-01-01" AND sale_date <= "2019-03-31"
) AS P1 LEFT JOIN (
SELECT DISTINCT product_id
FROM Sales
WHERE sale_date < "2019-01-01" OR sale_date > "2019-03-31"
) AS P2 ON P1.product_id = P2.product_id
WHERE P2.product_id IS NULL) AS P3 INNER JOIN Product P ON P3.product_id = P.product_id
;

# 1113. Reported Posts

SELECT extra as report_reason, COUNT(DISTINCT post_id) as report_count
FROM Actions
WHERE action_date = "2019-07-04" AND extra is NOT NULL
AND action = "report"
GROUP BY 1
;

SELECT extra as report_reason, COUNT(DISTINCT post_id) as report_count
FROM Actions
WHERE action_date = date_add("2019-07-05", interval -1 day) 
AND action = "report"
GROUP BY 1
;


# 1141. User Activity for the Past 30 Days I

SELECT activity_date as day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date between "2019-06-28" and "2019-07-27"
GROUP BY 1


SELECT activity_date as day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date between date_add("2019-07-27", interval -29 day) and "2019-07-27"
GROUP BY 1


# 1142. User Activity for the Past 30 Days II
SELECT COALESCE(ROUND(AVG(sessions), 2), 0) AS average_sessions_per_user
FROM 
(SELECT  user_id, COUNT(DISTINCT session_id) as sessions
FROM Activity
WHERE activity_date between date_add("2019-07-27", interval -29 day) and "2019-07-27"
GROUP BY 1) AS TEMP 
;


SELECT COALESCE(ROUND(COUNT(DISTINCT session_id) / COUNT(DISTINCT user_id), 2), 0) as average_sessions_per_user
FROM Activity
WHERE activity_date between date_add("2019-07-27", interval -29 day) and "2019-07-27"
;


# 1148. Article Views I

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY 1;


# 1173. Immediate Food Delivery I

SELECT COALESCE(ROUND(COUNT(DISTINCT delivery_id) * 100 / (SELECT COUNT(DISTINCT delivery_id) FROM Delivery), 2), 0) AS immediate_percentage
FROM Delivery
WHERE order_date = customer_pref_delivery_date
;


# 1179. Reformat Department Table


select id, 
	sum(case when month = 'jan' then revenue else null end) as Jan_Revenue,
	sum(case when month = 'feb' then revenue else null end) as Feb_Revenue,
	sum(case when month = 'mar' then revenue else null end) as Mar_Revenue,
	sum(case when month = 'apr' then revenue else null end) as Apr_Revenue,
	sum(case when month = 'may' then revenue else null end) as May_Revenue,
	sum(case when month = 'jun' then revenue else null end) as Jun_Revenue,
	sum(case when month = 'jul' then revenue else null end) as Jul_Revenue,
	sum(case when month = 'aug' then revenue else null end) as Aug_Revenue,
	sum(case when month = 'sep' then revenue else null end) as Sep_Revenue,
	sum(case when month = 'oct' then revenue else null end) as Oct_Revenue,
	sum(case when month = 'nov' then revenue else null end) as Nov_Revenue,
	sum(case when month = 'dec' then revenue else null end) as Dec_Revenue
from department
group by id
order by id

# 1211. Queries Quality and Percentage


SELECT query_name, ROUND(COALESCE(AVG(rating/position), 0), 2) AS quality, 
ROUND(COALESCE(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END), 0) * 100 / COUNT(*), 2) AS poor_query_percentage
FROM Queries
GROUP BY 1;


# 1241. Number of Comments per Post


SELECT P.post_id, COALESCE(COUNT(DISTINCT S.sub_id), 0) AS number_of_comments
FROM (
SELECT DISTINCT sub_id as post_id
FROM Submissions
WHERE parent_id IS NULL
) AS P
LEFT JOIN Submissions AS S ON P.post_id = S.parent_id
GROUP BY 1;


# 1251. Average Selling Price


SELECT P.product_id, ROUND(SUM(P.price * U.units)/SUM(U.units), 2) AS average_price 
FROM Prices P INNER JOIN UnitsSold U ON P.product_id = U.product_id
AND U.purchase_date BETWEEN P.start_date AND P.end_date
GROUP BY 1
;

# 1280. Students and Examinations

SELECT ST.student_id, ST.student_name, SJ.subject_name, COALESCE(COUNT(E.student_id), 0) AS attended_exams
FROM Students ST CROSS JOIN Subjects SJ
LEFT JOIN Examinations E ON E.student_id = ST.student_id AND E.subject_name = SJ.subject_name 
GROUP BY 1, 2, 3
ORDER BY 1, 3;


# 1294. Weather Type in Each Country

SELECT C.country_name, CASE WHEN AVG(W.weather_state) <= 15 THEN "Cold"
							WHEN AVG(W.weather_state) >= 25 THEN "Hot"
						ELSE "Warm" END AS weather_type
FROM Countries C INNER JOIN Weather W ON C.country_id = W.country_id
WHERE W.day between "2019-11-01" AND "2019-11-30"
GROUP BY 1
;


SELECT C.country_name, CASE WHEN AVG(W.weather_state) <= 15 THEN "Cold"
							WHEN AVG(W.weather_state) >= 25 THEN "Hot"
						ELSE "Warm" END AS weather_type
FROM Countries C INNER JOIN Weather W ON C.country_id = W.country_id
WHERE MONTH(W.day) = 11 AND YEAR(W.day) = 2019
GROUP BY 1
;

# 1303. Find the Team Size

SELECT E.employee_id, TEMP.team_size
FROM Employee E INNER JOIN 
(SELECT team_id, COUNT(DISTINCT employee_id) as team_size
FROM Employee
GROUP BY 1) AS TEMP ON E.team_id = TEMP.team_id
;

SELECT employee_id, COUNT(employee_id) OVER (PARTITION BY team_id) AS team_size
FROM Employee
;


# 1322. Ads Performance

SELECT ad_id, COALESCE(ROUND(SUM(CASE WHEN action = "Clicked" THEN 1 ELSE 0 END) / SUM(CASE WHEN action in ('Clicked', 'Viewed') THEN 1 ELSE 0 END) * 100, 2), 0) AS ctr 
FROM Ads 
GROUP BY 1 
ORDER BY 2 DESC, 1 ASC
; 


# 1327. List the Products Ordered in a Period

SELECT P.product_name, SUM(O.unit) AS unit
FROM Products P INNER JOIN Orders O ON P.product_id = O.product_id
WHERE MONTH(O.order_date) = 2 AND YEAR(O.order_date) = 2020
GROUP BY 1
HAVING SUM(O.unit) >= 100
;


# 1350. Students With Invalid Departments
SELECT DISTINCT S.id, S.name
FROM Students S LEFT JOIN Departments D ON S.department_id = D.id
WHERE D.id IS NULL 
;

# 1378. Replace Employee ID With The Unique Identifier

SELECT EI.unique_id, E.name
FROM Employees E LEFT JOIN EmployeeUNI EI ON E.id = EI.id
;

# 1407. Top Travellers

SELECT U.name, COALESCE(SUM(R.distance), 0) AS travelled_distance
FROM Users U LEFT JOIN Rides R ON U.id = R.user_id
GROUP BY 1
ORDER BY 2 DESC, 1 ASC;


# 1421. NPV Queries
SELECT Q.id, Q.year, COALESCE(NPV.npv, 0) AS npv
FROM Queries Q LEFT JOIN NPV ON Q.id = NPV.id AND Q.year = NPV.year
;

# 1435. Create a Session Bar Chart

SELECT CTE.bin, COALESCE(TEMP.total, 0) AS total
FROM 
(SELECT CASE WHEN duration/60 >= 0 AND duration/60 < 5 THEN "[0-5>"
			WHEN duration/60 >= 5 AND duration/60 < 10 THEN "[5-10>"
			WHEN duration/60 >= 10 AND duration/60 < 15 THEN "[10-15>"
			WHEN duration/60 >= 15 THEN "15 or more" 
			ELSE NULL END AS bin, COUNT(DISTINCT session_id) AS total
FROM Sessions 
GROUP BY 1) AS TEMP RIGHT JOIN (
SELECT "[0-5>" AS bin 
UNION ALL 
SELECT "[5-10>" AS bin 
UNION ALL 
SELECT "[10-15>" AS bin 
UNION ALL 
SELECT "15 or more" AS bin 
) AS CTE ON CTE.bin = TEMP.bin
;

# 1484. Group Sold Products By The Date

SELECT sell_date, COUNT(DISTINCT product) AS num_sold, GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM Activities
GROUP BY 1
ORDER BY 1
;


SELECT sell_date, COUNT(DISTINCT product) AS num_sold, STRING_AGG(product, ",") WITHIN GROUP (ORDER BY product ASC) AS products
FROM Activities
GROUP BY 1
ORDER BY 1
;

# 1495. Friendly Movies Streamed Last Month
SELECT DISTINCT C.title 
FROM Content C LEFT JOIN TVProgram TV ON C.content_id = TV.content_id 
WHERE C.Kids_content = "Y" AND MONTH(TV.program_date) = 6 AND YEAR(TV.program_date) = 2020
AND C.content_type = "movies"
;


# 1511. Customer Order Frequency

SELECT customer_id, name
FROM 
(SELECT MONTH(O.order_date) AS Mth, C.customer_id, C.name
FROM Customers C INNER JOIN Orders O ON C.customer_id = O.customer_id 
INNER JOIN Product P ON P.product_id = O.product_id
WHERE (MONTH(O.order_date) = 6 OR MONTH(O.order_date) = 7) AND (YEAR(O.order_date) = 2020)
GROUP BY 1, 2, 3
HAVING SUM(O.quantity * P.price) >= 100) AS TEMP 
GROUP BY 1, 2
HAVING COUNT(DISTINCT Mth) > 1
;

# 1517. Find Users With Valid E-Mails

SELECT *
FROM Users 
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9\_\.\-]*@leetcode.com'
; 


# 1527. Patients With a Condition

SELECT *
FROM Patients 
WHERE (conditions like "DIAB1%" OR conditions like "% DIAB1%")
;

# 1543. Fix Product Name Format

SELECT LOWER(TRIM(product_name)) AS product_name, DATE_FORMAT(sale_date, "%Y-%m") as sale_date, COUNT(DISTINCT sale_id) as total
FROM Sales
GROUP BY 1, 2
ORDER BY 1 ASC, 2 ASC;

# 1565. Unique Orders and Customers Per Month

SELECT DATE_FORMAT(order_date, "%Y-%m") AS month, COUNT(DISTINCT order_id) as order_count, COUNT(DISTINCT customer_id) as customer_count
FROM Orders
WHERE invoice > 20 
GROUP BY 1
;

# 1571. Warehouse Manager

SELECT W.name AS warehouse_name, SUM(P.Width * P.Length * P.Height * W.units) AS volume
FROM Warehouse W LEFT JOIN Products P ON W.product_id = P.product_id
GROUP BY 1;



# 1581. Customer Who Visited but Did Not Make Any Transactions

SELECT V.customer_id, COUNT(DISTINCT V.visit_id) AS count_no_trans
FROM Visits AS V LEFT JOIN Transactions AS T ON V.visit_id = T.visit_id
WHERE T.amount IS NULL OR T.amount = 0 
GROUP BY 1
;

# 1587. Bank Account Summary II
SELECT name, balance
FROM 
(SELECT U.name, U.account, SUM(T.amount) AS balance
FROM Users AS U INNER JOIN Transactions AS T ON U.account = T.account 
GROUP BY 1, 2
HAVING SUM(T.amount) > 10000) AS TEMP 
;

# 1607. Sellers With No Sales

SELECT seller_name
FROM Seller
WHERE seller_id NOT IN (SELECT DISTINCT seller_id FROM Orders WHERE YEAR(sale_date) = 2020)
ORDER BY 1 ASC
;
