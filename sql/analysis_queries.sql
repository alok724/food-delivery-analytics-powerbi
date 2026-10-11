-- USE food_delivery_analysis;


-- -- =========================================================
-- -- SECTION 1: DATA VALIDATION
-- -- =========================================================


-- -- Q1. ROW COUNT VALIDATION
-- -- Checks whether the raw and final tables contain the same
-- -- number of records.

-- SELECT COUNT(*) AS total_rows
-- FROM food_orders;

-- SELECT 
--     (SELECT COUNT(*) FROM food_orders_raw) AS raw_rows,
--     (SELECT COUNT(*) FROM food_orders) AS final_rows;


-- -- Q2. DUPLICATE ORDER ID CHECK
-- -- Checks whether any order_id appears more than once.

-- SELECT
--     order_id,
--     COUNT(*) AS duplicate_count
-- FROM food_orders
-- GROUP BY order_id
-- HAVING COUNT(*) > 1;


-- -- Q3. NULL VALUE ANALYSIS
-- -- Checks missing values in important columns.

-- SELECT
--     COUNT(*) AS total_rows,
--     SUM(order_id IS NULL) AS null_order_id,
--     SUM(restaurant_id IS NULL) AS null_restaurant_id,
--     SUM(restaurant_name IS NULL) AS null_restaurant_name,
--     SUM(order_placed_at IS NULL) AS null_order_time,
--     SUM(order_status IS NULL) AS null_status,
--     SUM(total IS NULL) AS null_total,
--     SUM(rating IS NULL) AS null_rating,
--     SUM(customer_id IS NULL) AS null_customer_id,
--     SUM(distance_km IS NULL) AS null_distance,
--     SUM(kpt_duration_minutes IS NULL) AS null_kpt,
--     SUM(rider_wait_time_minutes IS NULL) AS null_rider_wait
-- FROM food_orders;


-- -- Q4. ORDER STATUS VALIDATION
-- -- Shows the number and percentage of orders in each status.

-- SELECT
--     order_status,
--     COUNT(*) AS orders,
--     ROUND(
--         COUNT(*) * 100.0 /
--         (SELECT COUNT(*) FROM food_orders),
--         2
--     ) AS percentage
-- FROM food_orders
-- GROUP BY order_status
-- ORDER BY orders DESC;


-- -- Q5. NUMERIC RANGE VALIDATION
-- -- Checks minimum and maximum values of important numeric columns.

-- SELECT
--     MIN(bill_subtotal) AS min_bill_subtotal,
--     MAX(bill_subtotal) AS max_bill_subtotal,
--     MIN(total) AS min_total,
--     MAX(total) AS max_total,
--     MIN(distance_km) AS min_distance,
--     MAX(distance_km) AS max_distance,
--     MIN(kpt_duration_minutes) AS min_kpt,
--     MAX(kpt_duration_minutes) AS max_kpt,
--     MIN(rider_wait_time_minutes) AS min_rider_wait,
--     MAX(rider_wait_time_minutes) AS max_rider_wait,
--     MIN(rating) AS min_rating,
--     MAX(rating) AS max_rating
-- FROM food_orders;


-- -- Q6. RATING VALIDATION
-- -- Checks whether any rating is outside the valid 0–5 range.

-- SELECT
--     COUNT(*) AS invalid_rating_rows
-- FROM food_orders
-- WHERE rating IS NOT NULL
--   AND (rating < 0 OR rating > 5);


-- -- Q7. DISCOUNT VALUE VALIDATION
-- -- Checks whether discount values are negative or discount
-- -- percentage is outside the 0–100% range.

-- SELECT
--     COUNT(*) AS invalid_discount_rows
-- FROM food_orders
-- WHERE COALESCE(total_discount, 0) < 0
--    OR COALESCE(discount_percentage, 0) < 0
--    OR COALESCE(discount_percentage, 0) > 100;


-- -- Q8. Validate total discount against numeric discount components

-- SELECT
--     COUNT(*) AS mismatched_rows
-- FROM food_orders
-- WHERE ROUND(COALESCE(total_discount, 0), 2)
--       <>
--       ROUND(
--         COALESCE(restaurant_discount_promo, 0)
--         + COALESCE(restaurant_discount_other, 0)
--         + COALESCE(gold_discount, 0)
--         + COALESCE(brand_pack_discount, 0),
--         2
--       );


-- -- Q9. DISCOUNT PERCENTAGE VALIDATION
-- -- Checks whether discount_percentage matches the calculated
-- -- discount percentage from total_discount and bill_subtotal.

-- SELECT
--     COUNT(*) AS mismatched_discount_percentage
-- FROM food_orders
-- WHERE bill_subtotal > 0
--   AND ABS(
--         discount_percentage -
--         (total_discount * 100.0 / bill_subtotal)
--       ) > 0.01;


-- -- Q10. OPERATIONAL NULL ANALYSIS BY ORDER STATUS
-- -- Checks missing operational information for each order status.

-- SELECT
--     order_status,
--     COUNT(*) AS total_orders,
--     SUM(kpt_duration_minutes IS NULL) AS missing_kpt,
--     SUM(rider_wait_time_minutes IS NULL) AS missing_rider_wait,
--     SUM(order_ready_marked IS NULL) AS missing_ready_status
-- FROM food_orders
-- GROUP BY order_status
-- ORDER BY total_orders DESC;


-- -- =========================================================
-- -- SECTION 2: OVERALL BUSINESS PERFORMANCE
-- -- =========================================================


-- -- Q11. OVERALL BUSINESS SUMMARY
-- -- Provides the main business-level KPIs.

-- SELECT
--     COUNT(*) AS total_orders,
--     COUNT(DISTINCT customer_id) AS unique_customers,
--     COUNT(DISTINCT restaurant_id) AS restaurants,
--     ROUND(SUM(total), 2) AS total_revenue,
--     ROUND(AVG(total), 2) AS average_order_value,
--     ROUND(AVG(distance_km), 2) AS avg_delivery_distance,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt_minutes
-- FROM food_orders;


-- -- =========================================================
-- -- SECTION 3: ORDER STATUS & DELIVERY PERFORMANCE
-- -- =========================================================


-- -- Q12. ORDER STATUS PERFORMANCE
-- -- Compares order volume, percentage, average order value,
-- -- and total order value across different statuses.

-- SELECT
--     order_status,
--     COUNT(*) AS orders,
--     ROUND(
--         COUNT(*) * 100.0 /
--         (SELECT COUNT(*) FROM food_orders),
--         2
--     ) AS order_percentage,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(SUM(total), 2) AS total_value
-- FROM food_orders
-- GROUP BY order_status
-- ORDER BY orders DESC;


-- -- Q13. DELIVERED ORDER PERFORMANCE
-- -- Analyzes revenue, AOV, distance, KPT, and rider wait time
-- -- specifically for delivered orders.

-- SELECT
--     COUNT(*) AS delivered_orders,
--     ROUND(SUM(total), 2) AS delivered_revenue,
--     ROUND(AVG(total), 2) AS delivered_aov,
--     ROUND(AVG(distance_km), 2) AS avg_distance,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait
-- FROM food_orders
-- WHERE order_status = 'Delivered';


-- -- =========================================================
-- -- SECTION 4: RESTAURANT ANALYSIS
-- -- =========================================================


-- -- Q14. RESTAURANT PERFORMANCE
-- -- Compares restaurant order volume, delivered orders,
-- -- revenue, AOV, rating, and KPT.

-- SELECT
--     restaurant_id,
--     restaurant_name,
--     COUNT(*) AS total_orders,
--     SUM(order_status = 'Delivered') AS delivered_orders,
--     SUM(order_status <> 'Delivered') AS non_delivered_orders,
--     ROUND(SUM(total), 2) AS total_order_value,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(AVG(rating), 2) AS avg_rating,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt
-- FROM food_orders
-- GROUP BY restaurant_id, restaurant_name
-- HAVING COUNT(*) >= 20
-- ORDER BY total_orders DESC;


-- -- Q15. RESTAURANT FAILURE RATE
-- -- Measures the percentage of orders with specific failure
-- -- statuses: Rejected, Returned, Return cancelled, and Timed out.

-- SELECT
--     restaurant_id,
--     restaurant_name,
--     COUNT(*) AS total_orders,
--     SUM(order_status = 'Delivered') AS delivered_orders,
--     SUM(
--         order_status IN
--         ('Rejected', 'Returned', 'Return cancelled', 'Timed out')
--     ) AS failed_orders,
--     ROUND(
--         SUM(
--             order_status IN
--             ('Rejected', 'Returned', 'Return cancelled', 'Timed out')
--         ) * 100.0 / COUNT(*),
--         2
--     ) AS failure_rate
-- FROM food_orders
-- GROUP BY restaurant_id, restaurant_name
-- HAVING COUNT(*) >= 20
-- ORDER BY failure_rate DESC;


-- -- Q16. RESTAURANT REVENUE CONTRIBUTION
-- -- Shows how much total revenue each restaurant contributes.

-- SELECT
--     restaurant_name,
--     ROUND(SUM(total), 2) AS restaurant_revenue,
--     ROUND(
--         SUM(total) * 100.0 /
--         (SELECT SUM(total) FROM food_orders),
--         2
--     ) AS revenue_contribution_percentage
-- FROM food_orders
-- GROUP BY restaurant_name
-- ORDER BY restaurant_revenue DESC;


-- -- Q17. CUMULATIVE RESTAURANT REVENUE / PARETO ANALYSIS
-- -- Ranks restaurants by revenue and calculates their cumulative
-- -- contribution to total revenue.

-- WITH restaurant_revenue AS (
--     SELECT
--         restaurant_name,
--         SUM(total) AS revenue
--     FROM food_orders
--     GROUP BY restaurant_name
-- ),
-- ranked AS (
--     SELECT
--         restaurant_name,
--         revenue,
--         RANK() OVER (
--             ORDER BY revenue DESC
--         ) AS revenue_rank,
--         SUM(revenue) OVER (
--             ORDER BY revenue DESC
--             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--         ) AS cumulative_revenue,
--         SUM(revenue) OVER () AS total_revenue
--     FROM restaurant_revenue
-- )
-- SELECT
--     restaurant_name,
--     revenue_rank,
--     ROUND(revenue, 2) AS revenue,
--     ROUND(
--         revenue * 100.0 / total_revenue,
--         2
--     ) AS revenue_percentage,
--     ROUND(
--         cumulative_revenue * 100.0 / total_revenue,
--         2
--     ) AS cumulative_revenue_percentage
-- FROM ranked
-- ORDER BY revenue_rank;


-- -- Q18. RESTAURANT ORDER-VOLUME CONTRIBUTION
-- -- Shows how much of the total order volume comes from each
-- -- restaurant.

-- SELECT
--     restaurant_name,
--     COUNT(*) AS orders,
--     ROUND(
--         COUNT(*) * 100.0 /
--         (SELECT COUNT(*) FROM food_orders),
--         2
--     ) AS order_contribution_percentage
-- FROM food_orders
-- GROUP BY restaurant_name
-- ORDER BY orders DESC;


-- -- Q19. RESTAURANT SCORECARD
-- -- Creates a comparison table of important restaurant KPIs
-- -- without creating an artificial score.

-- SELECT
--     restaurant_id,
--     restaurant_name,
--     COUNT(*) AS total_orders,
--     SUM(order_status = 'Delivered') AS delivered_orders,
--     ROUND(
--         SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
--         2
--     ) AS delivery_rate,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(AVG(rating), 2) AS avg_rating,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait,
--     ROUND(AVG(discount_percentage), 2) AS avg_discount_percentage
-- FROM food_orders
-- GROUP BY restaurant_id, restaurant_name
-- HAVING COUNT(*) >= 20
-- ORDER BY total_orders DESC;


-- -- Q20. RESTAURANT + HOUR OPERATIONAL PRESSURE
-- -- Identifies restaurant-hour combinations with higher order
-- -- volume and operational workload.

-- SELECT
--     restaurant_name,
--     `hour`,
--     COUNT(*) AS orders,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait
-- FROM food_orders
-- GROUP BY restaurant_name, `hour`
-- HAVING COUNT(*) >= 10
-- ORDER BY avg_kpt DESC;


-- -- Q21. TOP RESTAURANTS WITHIN EACH SUBZONE
-- -- Uses ranking to identify the top 3 restaurants by revenue
-- -- within each subzone.

-- WITH restaurant_subzone AS (
--     SELECT
--         subzone,
--         restaurant_name,
--         COUNT(*) AS orders,
--         SUM(total) AS revenue
--     FROM food_orders
--     GROUP BY subzone, restaurant_name
-- ),
-- ranked AS (
--     SELECT
--         subzone,
--         restaurant_name,
--         orders,
--         revenue,
--         RANK() OVER (
--             PARTITION BY subzone
--             ORDER BY revenue DESC
--         ) AS revenue_rank
--     FROM restaurant_subzone
-- )
-- SELECT
--     subzone,
--     restaurant_name,
--     orders,
--     ROUND(revenue, 2) AS revenue,
--     revenue_rank
-- FROM ranked
-- WHERE revenue_rank <= 3
-- ORDER BY subzone, revenue_rank;


-- -- =========================================================
-- -- SECTION 5: CUSTOMER ANALYSIS
-- -- =========================================================


-- -- Q22. REPEAT CUSTOMER SEGMENTATION
-- -- Segments customers into One-time, Repeat, and Highly Repeat
-- -- customers based on their order frequency.

-- WITH customer_orders AS (
--     SELECT
--         customer_id,
--         COUNT(*) AS order_count,
--         SUM(total) AS total_spend
--     FROM food_orders
--     WHERE customer_id IS NOT NULL
--     GROUP BY customer_id
-- )
-- SELECT
--     CASE
--         WHEN order_count = 1 THEN 'One-time'
--         WHEN order_count BETWEEN 2 AND 5 THEN 'Repeat'
--         ELSE 'Highly Repeat'
--     END AS customer_segment,
--     COUNT(*) AS customers,
--     ROUND(AVG(order_count), 2) AS avg_orders,
--     ROUND(AVG(total_spend), 2) AS avg_customer_spend
-- FROM customer_orders
-- GROUP BY
--     CASE
--         WHEN order_count = 1 THEN 'One-time'
--         WHEN order_count BETWEEN 2 AND 5 THEN 'Repeat'
--         ELSE 'Highly Repeat'
--     END
-- ORDER BY avg_orders;


-- -- Q23. TOP CUSTOMERS BY SPEND
-- -- Identifies high-value customers with at least two orders.

-- SELECT
--     customer_id,
--     COUNT(*) AS orders,
--     ROUND(SUM(total), 2) AS total_spend,
--     ROUND(AVG(total), 2) AS avg_order_value
-- FROM food_orders
-- WHERE customer_id IS NOT NULL
-- GROUP BY customer_id
-- HAVING COUNT(*) >= 2
-- ORDER BY total_spend DESC
-- LIMIT 20;


-- -- Q24. CUSTOMER SPEND CONCENTRATION
-- -- Divides customers into ten spend groups using NTILE and
-- -- compares their contribution to revenue.

-- WITH customer_spend AS (
--     SELECT
--         customer_id,
--         SUM(total) AS spend
--     FROM food_orders
--     WHERE customer_id IS NOT NULL
--     GROUP BY customer_id
-- ),
-- ranked AS (
--     SELECT
--         customer_id,
--         spend,
--         NTILE(10) OVER (
--             ORDER BY spend DESC
--         ) AS spend_decile
--     FROM customer_spend
-- )
-- SELECT
--     spend_decile,
--     COUNT(*) AS customers,
--     ROUND(SUM(spend), 2) AS revenue
-- FROM ranked
-- GROUP BY spend_decile
-- ORDER BY spend_decile;


-- -- =========================================================
-- -- SECTION 6: TIME & DEMAND ANALYSIS
-- -- =========================================================


-- -- Q25. HOURLY DEMAND ANALYSIS
-- -- Shows order demand and order value by hour of the day.

-- SELECT
--     `hour`,
--     COUNT(*) AS orders,
--     ROUND(SUM(total), 2) AS order_value,
--     ROUND(AVG(total), 2) AS avg_order_value
-- FROM food_orders
-- GROUP BY `hour`
-- ORDER BY orders DESC;


-- -- Q26. PEAK-HOUR OPERATIONAL ANALYSIS
-- -- Compares order demand with KPT, rider wait time, and distance
-- -- during different hours.

-- SELECT
--     `hour`,
--     COUNT(*) AS orders,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait,
--     ROUND(AVG(distance_km), 2) AS avg_distance
-- FROM food_orders
-- GROUP BY `hour`
-- HAVING COUNT(*) >= 20
-- ORDER BY orders DESC;


-- -- Q27. DAY-OF-WEEK ANALYSIS
-- -- Compares demand, order value, AOV, and KPT by day.

-- SELECT
--     `day`,
--     COUNT(*) AS orders,
--     ROUND(SUM(total), 2) AS total_value,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt
-- FROM food_orders
-- GROUP BY `day`
-- ORDER BY orders DESC;


-- -- Q28. MONTHLY BUSINESS ANALYSIS
-- -- Shows monthly order volume, revenue, and AOV.

-- SELECT
--     `month`,
--     COUNT(*) AS orders,
--     ROUND(SUM(total), 2) AS revenue,
--     ROUND(AVG(total), 2) AS avg_order_value
-- FROM food_orders
-- GROUP BY `month`
-- ORDER BY `month`;


-- -- =========================================================
-- -- SECTION 7: DELIVERY & OPERATIONAL ANALYSIS
-- -- =========================================================


-- -- Q29. DISTANCE BUCKET ANALYSIS
-- -- Groups orders by delivery distance and compares operational
-- -- performance.

-- SELECT
--     CASE
--         WHEN distance_km < 1 THEN '<1 km'
--         WHEN distance_km < 3 THEN '1–3 km'
--         WHEN distance_km < 5 THEN '3–5 km'
--         WHEN distance_km < 8 THEN '5–8 km'
--         ELSE '8+ km'
--     END AS distance_bucket,
--     COUNT(*) AS orders,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait,
--     ROUND(AVG(total), 2) AS avg_order_value
-- FROM food_orders
-- GROUP BY
--     CASE
--         WHEN distance_km < 1 THEN '<1 km'
--         WHEN distance_km < 3 THEN '1–3 km'
--         WHEN distance_km < 5 THEN '3–5 km'
--         WHEN distance_km < 8 THEN '5–8 km'
--         ELSE '8+ km'
--     END
-- ORDER BY MIN(distance_km);


-- -- Q30. KPT BUCKET ANALYSIS
-- -- Groups orders by kitchen preparation time and compares
-- -- order value and delivery distance.

-- SELECT
--     CASE
--         WHEN kpt_duration_minutes < 15 THEN '<15 min'
--         WHEN kpt_duration_minutes < 30 THEN '15–30 min'
--         WHEN kpt_duration_minutes < 45 THEN '30–45 min'
--         WHEN kpt_duration_minutes < 60 THEN '45–60 min'
--         ELSE '60+ min'
--     END AS kpt_bucket,
--     COUNT(*) AS orders,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(AVG(distance_km), 2) AS avg_distance
-- FROM food_orders
-- WHERE kpt_duration_minutes IS NOT NULL
-- GROUP BY
--     CASE
--         WHEN kpt_duration_minutes < 15 THEN '<15 min'
--         WHEN kpt_duration_minutes < 30 THEN '15–30 min'
--         WHEN kpt_duration_minutes < 45 THEN '30–45 min'
--         WHEN kpt_duration_minutes < 60 THEN '45–60 min'
--         ELSE '60+ min'
--     END
-- ORDER BY MIN(kpt_duration_minutes);


-- -- Q31. RIDER WAIT TIME BUCKET ANALYSIS
-- -- Groups orders by rider waiting time and compares average KPT.

-- SELECT
--     CASE
--         WHEN rider_wait_time_minutes IS NULL THEN 'Not Available'
--         WHEN rider_wait_time_minutes = 0 THEN 'No Wait'
--         WHEN rider_wait_time_minutes < 5 THEN '<5 min'
--         WHEN rider_wait_time_minutes < 10 THEN '5–10 min'
--         WHEN rider_wait_time_minutes < 20 THEN '10–20 min'
--         ELSE '20+ min'
--     END AS rider_wait_bucket,
--     COUNT(*) AS orders,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt
-- FROM food_orders
-- GROUP BY
--     CASE
--         WHEN rider_wait_time_minutes IS NULL THEN 'Not Available'
--         WHEN rider_wait_time_minutes = 0 THEN 'No Wait'
--         WHEN rider_wait_time_minutes < 5 THEN '<5 min'
--         WHEN rider_wait_time_minutes < 10 THEN '5–10 min'
--         WHEN rider_wait_time_minutes < 20 THEN '10–20 min'
--         ELSE '20+ min'
--     END
-- ORDER BY orders DESC;


-- -- Q32. ORDER-READY STATUS ANALYSIS
-- -- Compares delivery performance based on whether the order
-- -- was marked ready.

-- SELECT
--     order_ready_marked,
--     COUNT(*) AS orders,
--     SUM(order_status = 'Delivered') AS delivered_orders,
--     SUM(order_status <> 'Delivered') AS non_delivered_orders,
--     ROUND(
--         SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
--         2
--     ) AS delivery_rate
-- FROM food_orders
-- GROUP BY order_ready_marked
-- ORDER BY orders DESC;


-- -- Q33. HIGH-OPERATIONAL-PRESSURE ORDERS
-- -- Identifies orders with both high KPT and high rider waiting time.

-- SELECT
--     order_id,
--     restaurant_name,
--     order_status,
--     kpt_duration_minutes,
--     rider_wait_time_minutes,
--     distance_km,
--     total
-- FROM food_orders
-- WHERE kpt_duration_minutes >= 45
--   AND rider_wait_time_minutes >= 10
-- ORDER BY
--     kpt_duration_minutes DESC,
--     rider_wait_time_minutes DESC;


-- -- =========================================================
-- -- SECTION 8: DISCOUNT & PROMOTION ANALYSIS
-- -- =========================================================


-- -- Q34. DISCOUNT VS ORDER VALUE
-- -- Compares average order value and average discount across
-- -- different discount ranges.

-- SELECT
--     CASE
--         WHEN discount_percentage = 0 THEN 'No Discount'
--         WHEN discount_percentage < 10 THEN '1–9%'
--         WHEN discount_percentage < 20 THEN '10–19%'
--         WHEN discount_percentage < 30 THEN '20–29%'
--         ELSE '30%+'
--     END AS discount_bucket,
--     COUNT(*) AS orders,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(AVG(total_discount), 2) AS avg_discount,
--     ROUND(AVG(discount_percentage), 2) AS avg_discount_percentage
-- FROM food_orders
-- GROUP BY
--     CASE
--         WHEN discount_percentage = 0 THEN 'No Discount'
--         WHEN discount_percentage < 10 THEN '1–9%'
--         WHEN discount_percentage < 20 THEN '10–19%'
--         WHEN discount_percentage < 30 THEN '20–29%'
--         ELSE '30%+'
--     END
-- ORDER BY MIN(discount_percentage);


-- -- Q35. DISCOUNT VS DELIVERY PERFORMANCE
-- -- Compares delivery rate and AOV across different discount ranges.

-- SELECT
--     CASE
--         WHEN discount_percentage = 0 THEN 'No Discount'
--         WHEN discount_percentage < 10 THEN '1–9%'
--         WHEN discount_percentage < 20 THEN '10–19%'
--         WHEN discount_percentage < 30 THEN '20–29%'
--         ELSE '30%+'
--     END AS discount_bucket,
--     COUNT(*) AS orders,
--     SUM(order_status = 'Delivered') AS delivered,
--     ROUND(
--         SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
--         2
--     ) AS delivery_rate,
--     ROUND(AVG(total), 2) AS avg_order_value
-- FROM food_orders
-- GROUP BY
--     CASE
--         WHEN discount_percentage = 0 THEN 'No Discount'
--         WHEN discount_percentage < 10 THEN '1–9%'
--         WHEN discount_percentage < 20 THEN '10–19%'
--         WHEN discount_percentage < 30 THEN '20–29%'
--         ELSE '30%+'
--     END
-- ORDER BY MIN(discount_percentage);
-- -- =========================================================
-- -- SECTION 9: CUSTOMER EXPERIENCE ANALYSIS
-- -- =========================================================


-- -- Q36. RATING DISTRIBUTION
-- -- Shows the distribution and percentage of available ratings.

-- SELECT
--     rating,
--     COUNT(*) AS ratings,
--     ROUND(
--         COUNT(*) * 100.0 /
--         (SELECT COUNT(*) FROM food_orders WHERE rating IS NOT NULL),
--         2
--     ) AS percentage
-- FROM food_orders
-- WHERE rating IS NOT NULL
-- GROUP BY rating
-- ORDER BY rating;


-- -- Q37. RATING VS OPERATIONS
-- -- Compares KPT, rider wait, distance, and AOV across rating groups.

-- SELECT
--     CASE
--         WHEN rating < 2 THEN 'Low Rating'
--         WHEN rating < 4 THEN 'Medium Rating'
--         ELSE 'High Rating'
--     END AS rating_group,
--     COUNT(*) AS orders,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait,
--     ROUND(AVG(distance_km), 2) AS avg_distance,
--     ROUND(AVG(total), 2) AS avg_order_value
-- FROM food_orders
-- WHERE rating IS NOT NULL
-- GROUP BY
--     CASE
--         WHEN rating < 2 THEN 'Low Rating'
--         WHEN rating < 4 THEN 'Medium Rating'
--         ELSE 'High Rating'
--     END
-- ORDER BY rating_group;


-- -- Q38. CUSTOMER COMPLAINT ANALYSIS
-- -- Identifies complaint categories and compares their ratings
-- -- and operational metrics.

-- SELECT
--     customer_complaint_tag,
--     COUNT(*) AS complaints,
--     ROUND(AVG(rating), 2) AS avg_rating,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait
-- FROM food_orders
-- WHERE customer_complaint_tag IS NOT NULL
-- GROUP BY customer_complaint_tag
-- ORDER BY complaints DESC;


-- -- Q39. CANCELLATION / REJECTION REASON ANALYSIS
-- -- Shows the most common cancellation or rejection reasons
-- -- and their affected order value.

-- SELECT
--     cancellation_rejection_reason,
--     COUNT(*) AS orders,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(SUM(total), 2) AS affected_order_value
-- FROM food_orders
-- WHERE cancellation_rejection_reason IS NOT NULL
-- GROUP BY cancellation_rejection_reason
-- ORDER BY orders DESC;


-- -- Q40. RESTAURANT COMPENSATION AND PENALTY ANALYSIS
-- -- Measures compensation and penalty amounts by restaurant.
-- SELECT
--     restaurant_name,
--     COUNT(*) AS affected_orders,
--     ROUND(
--         SUM(COALESCE(restaurant_compensation_cancellation, 0)),
--         2
--     ) AS total_compensation,
--     ROUND(
--         SUM(COALESCE(restaurant_penalty_rejection, 0)),
--         2
--     ) AS total_penalty
-- FROM food_orders
-- WHERE restaurant_compensation_cancellation IS NOT NULL
--    OR restaurant_penalty_rejection IS NOT NULL
-- GROUP BY restaurant_name
-- ORDER BY affected_orders DESC;


-- -- =========================================================
-- -- SECTION 10: GEOGRAPHIC / SUBZONE ANALYSIS
-- -- =========================================================


-- -- Q41. SUBZONE PERFORMANCE
-- -- Compares demand, order value, distance, KPT, and rider wait
-- -- across subzones.

-- SELECT
--     subzone,
--     COUNT(*) AS orders,
--     ROUND(SUM(total), 2) AS total_value,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(AVG(distance_km), 2) AS avg_distance,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait
-- FROM food_orders
-- GROUP BY subzone
-- HAVING COUNT(*) >= 20
-- ORDER BY orders DESC;


-- -- =========================================================
-- -- SECTION 11: ADVANCED SQL ANALYSIS
-- -- =========================================================


-- -- Q42. HIGH-VALUE ORDERS
-- -- Finds orders whose total value is above the overall average
-- -- order value.

-- SELECT
--     order_id,
--     restaurant_name,
--     total,
--     distance_km,
--     discount_percentage,
--     order_status
-- FROM food_orders
-- WHERE total > (
--     SELECT AVG(total)
--     FROM food_orders
-- )
-- ORDER BY total DESC;


-- -- Q43. RESTAURANTS ABOVE OVERALL AOV
-- -- Identifies restaurants whose average order value is higher
-- -- than the overall business AOV.

-- SELECT
--     restaurant_name,
--     COUNT(*) AS orders,
--     ROUND(AVG(total), 2) AS restaurant_aov
-- FROM food_orders
-- GROUP BY restaurant_name
-- HAVING AVG(total) > (
--     SELECT AVG(total)
--     FROM food_orders
-- )
-- ORDER BY restaurant_aov DESC;


-- -- Q44. DATE/TIME VALIDATION
-- -- Checks the earliest and latest order date/time and verifies
-- -- whether any order timestamp is missing.

-- SELECT
--     MIN(order_placed_at) AS earliest_order,
--     MAX(order_placed_at) AS latest_order,
--     COUNT(*) AS total_orders,
--     SUM(order_placed_at IS NULL) AS null_order_time
-- FROM food_orders;


-- -- Q45. NEGATIVE NUMERIC VALUE VALIDATION
-- -- Checks for impossible negative values in important numeric
-- -- business and operational columns.

-- SELECT
--     SUM(bill_subtotal < 0) AS negative_subtotal,
--     SUM(packaging_charges < 0) AS negative_packaging,
--     SUM(total < 0) AS negative_total,
--     SUM(distance_km < 0) AS negative_distance,
--     SUM(kpt_duration_minutes < 0) AS negative_kpt,
--     SUM(rider_wait_time_minutes < 0) AS negative_rider_wait
-- FROM food_orders;


-- -- Q46. EXECUTIVE KPI SUMMARY
-- -- Provides the main KPIs required for the final dashboard
-- -- and project presentation.

-- SELECT 
--     COUNT(*) AS total_orders,
--     COUNT(DISTINCT customer_id) AS unique_customers,
--     COUNT(DISTINCT restaurant_id) AS active_restaurants,
--     SUM(order_status = 'Delivered') AS delivered_orders,
--     SUM(order_status <> 'Delivered') AS non_delivered_orders,
--     ROUND(SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
--             2) AS delivery_rate,
--     ROUND(SUM(total), 2) AS total_order_value,
--     ROUND(AVG(total), 2) AS avg_order_value,
--     ROUND(AVG(distance_km), 2) AS avg_distance,
--     ROUND(AVG(kpt_duration_minutes), 2) AS avg_kpt,
--     ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait,
--     ROUND(AVG(rating), 2) AS avg_rating,
--     ROUND(AVG(discount_percentage), 2) AS avg_discount_percentage
-- FROM
--     food_orders;
