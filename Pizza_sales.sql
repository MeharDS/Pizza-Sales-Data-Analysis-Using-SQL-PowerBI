create database pizzastore;
-- Basic:
-- Q1: Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_Order_Placed
FROM
    orders

-- Q2: Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            0) AS Total_Revnue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Q3: Identify the highest-priced pizza.
SELECT 
    pizza_types.name AS highest_priced_Pizza, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Q4: Identify the most common pizza size ordered.
SELECT 
    pizzas.size, SUM(order_details.quantity) AS No_of_Orders
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY SUM(order_details.quantity) DESC; 

-- Q5: List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name AS most_ordered_pizza,
    SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY SUM(order_details.quantity) DESC
LIMIT 5;

-- Intermediate:
-- Q6: Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category AS Pizza_Category,
    SUM(order_details.quantity) AS Quantity_Ordered
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Quantity_Ordered DESC;

-- Q7: Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(orders.time) AS Time_Hour,
    COUNT(orders.order_id) AS Orders
FROM
    orders
GROUP BY Time_Hour
ORDER BY Orders DESC;

-- Q8: Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name) as No_of_Pizzas
FROM
    pizza_types
GROUP BY category

-- Q9: Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(Quantity), 0) AS Average_Orders_Per_Day
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS Quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY date) AS orders_quantity;

-- Q10: Determine the top 5 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    (order_details.quantity * pizzas.price) AS Revnue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY Revnue DESC
LIMIT 5;
    
    
-- Advanced:
-- Q11: Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category AS Pizza_Type,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                0) AS Total_Revnue
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100),
            2) AS Revenue_Percentage
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY Pizza_Type
ORDER BY Revenue_Percentage DESC;


-- Q12: Analyze the cumulative revenue generated over time.
SELECT order_date,
sum(Revenue) over (order by order_date) as Cum_Revenue
from (SELECT 
    orders.date AS Order_Date,
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Revenue
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY Order_Date
ORDER BY Revenue) as sales;




-- Q13: Determine the top 3 most ordered pizza types based on revenue for each pizza category.
Select name, Revenue from
(select category, name, Revenue,
rank() over(partition by category order by Revenue desc) as Category_Rank 
from(
select pizza_types.category, pizza_types.name, round(sum(order_details.quantity * pizzas.price),2) AS Revenue
from pizza_types JOIN pizzas on 
pizza_types.pizza_type_id =  pizzas.pizza_type_id
join order_details on
 order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.category, pizza_types.name) as sales) as Rank_Data
 where Category_Rank <= 3;
 































