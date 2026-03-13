-- ============================================================
-- SQL Spending Database: Personal Finance Analytics
-- Tools: SQL (SQLite compatible)
-- Tracks: Food & Dining, Shopping
-- ============================================================


-- ============================================================
-- SECTION 1: SCHEMA DESIGN
-- Relational database with 3 tables:
--   categories -> purchases (one-to-many)
--   purchases  -> weekly_summary (aggregated view)
-- ============================================================

DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS weekly_summary;

-- Categories table: defines spending buckets
CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT    NOT NULL UNIQUE,
    monthly_budget REAL   NOT NULL,  -- planned budget per month
    is_essential  INTEGER NOT NULL DEFAULT 1  -- 1 = essential, 0 = discretionary
);

-- Purchases table: every individual transaction
CREATE TABLE purchases (
    purchase_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    purchase_date TEXT    NOT NULL,  -- format: YYYY-MM-DD
    merchant      TEXT    NOT NULL,
    amount        REAL    NOT NULL CHECK(amount > 0),
    category_id   INTEGER NOT NULL,
    payment_method TEXT   NOT NULL DEFAULT 'Card',
    notes         TEXT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Weekly summary table: pre-aggregated for performance
CREATE TABLE weekly_summary (
    summary_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    week_start      TEXT    NOT NULL,  -- Monday of that week
    category_id     INTEGER NOT NULL,
    total_spent     REAL    NOT NULL,
    transaction_count INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);


-- ============================================================
-- SECTION 2: SEED DATA
-- ============================================================

-- Insert categories
INSERT INTO categories (category_name, monthly_budget, is_essential) VALUES
    ('Food & Dining',    400.00, 1),
    ('Groceries',        250.00, 1),
    ('Coffee & Drinks',   60.00, 0),
    ('Shopping',         150.00, 0),
    ('Clothing',         100.00, 0),
    ('Online Shopping',  120.00, 0);

-- Insert purchases: 10 weeks of transactions (Food & Dining + Shopping)
INSERT INTO purchases (purchase_date, merchant, amount, category_id, payment_method, notes) VALUES

-- Week 1 (Jan 6 - Jan 12)
('2025-01-06', 'Chipotle',           12.50, 1, 'Card',  'Lunch'),
('2025-01-07', 'Whole Foods',        54.30, 2, 'Card',  'Weekly groceries'),
('2025-01-07', 'Starbucks',           6.75, 3, 'Card',  'Morning coffee'),
('2025-01-08', 'Amazon',             34.99, 6, 'Card',  'Phone case'),
('2025-01-09', 'Chick-fil-A',        11.20, 1, 'Cash',  'Dinner'),
('2025-01-10', 'H&M',                42.00, 5, 'Card',  'Winter sale'),
('2025-01-11', 'Trader Joes',        38.50, 2, 'Card',  'Snacks and produce'),
('2025-01-12', 'Panera Bread',       14.80, 1, 'Card',  'Weekend brunch'),

-- Week 2 (Jan 13 - Jan 19)
('2025-01-13', 'McDonalds',           9.40, 1, 'Card',  'Quick lunch'),
('2025-01-14', 'Costco',             87.60, 2, 'Card',  'Bulk groceries'),
('2025-01-15', 'Starbucks',           7.20, 3, 'Card',  'Latte'),
('2025-01-15', 'ASOS',               65.00, 6, 'Card',  'Clothes order'),
('2025-01-16', 'Olive Garden',       38.50, 1, 'Card',  'Dinner with friends'),
('2025-01-17', 'Target',             52.30, 4, 'Card',  'Household items'),
('2025-01-18', 'Subway',              9.80, 1, 'Cash',  'Lunch'),
('2025-01-19', 'Zara',               89.00, 5, 'Card',  'New jeans'),

-- Week 3 (Jan 20 - Jan 26)
('2025-01-20', 'Chipotle',           13.20, 1, 'Card',  'Burrito bowl'),
('2025-01-21', 'Whole Foods',        61.40, 2, 'Card',  'Weekly groceries'),
('2025-01-22', 'Dutch Bros',          6.00, 3, 'Card',  'Coffee'),
('2025-01-22', 'Amazon',             24.99, 6, 'Card',  'Book'),
('2025-01-23', 'Buffalo Wild Wings', 28.60, 1, 'Card',  'Dinner'),
('2025-01-24', 'Nike',               95.00, 5, 'Card',  'Sneakers'),
('2025-01-25', 'Aldi',               33.20, 2, 'Cash',  'Groceries'),
('2025-01-26', 'Shake Shack',        18.40, 1, 'Card',  'Weekend treat'),

-- Week 4 (Jan 27 - Feb 2)
('2025-01-27', 'Panda Express',      11.80, 1, 'Card',  'Lunch'),
('2025-01-28', 'Trader Joes',        44.70, 2, 'Card',  'Weekly groceries'),
('2025-01-29', 'Starbucks',           5.95, 3, 'Card',  'Americano'),
('2025-01-30', 'eBay',               29.50, 6, 'Card',  'Vintage find'),
('2025-01-31', 'Chilis',             32.00, 1, 'Card',  'Dinner'),
('2025-02-01', 'H&M',                38.00, 5, 'Card',  'Basics'),
('2025-02-02', 'Whole Foods',        49.80, 2, 'Card',  'Weekend shop'),

-- Week 5 (Feb 3 - Feb 9)
('2025-02-03', 'Chipotle',           14.00, 1, 'Card',  'Lunch'),
('2025-02-04', 'Costco',             92.40, 2, 'Card',  'Monthly bulk run'),
('2025-02-05', 'Starbucks',           7.50, 3, 'Card',  'Iced latte'),
('2025-02-05', 'Amazon',             59.99, 6, 'Card',  'Desk organizer'),
('2025-02-06', 'Dominos',            22.50, 1, 'Card',  'Pizza night'),
('2025-02-07', 'Urban Outfitters',   74.00, 5, 'Card',  'Sale items'),
('2025-02-08', 'Aldi',               31.60, 2, 'Cash',  'Groceries'),
('2025-02-09', 'IHOP',               19.80, 1, 'Card',  'Sunday brunch'),

-- Week 6 (Feb 10 - Feb 16)
('2025-02-10', 'Taco Bell',           8.40, 1, 'Cash',  'Late night'),
('2025-02-11', 'Whole Foods',        57.20, 2, 'Card',  'Weekly groceries'),
('2025-02-12', 'Dutch Bros',          5.50, 3, 'Card',  'Coffee'),
('2025-02-12', 'ASOS',               48.00, 6, 'Card',  'Tops'),
('2025-02-13', 'Texas Roadhouse',    44.60, 1, 'Card',  'Valentines dinner'),
('2025-02-14', 'Target',             36.80, 4, 'Card',  'Valentines gifts'),
('2025-02-15', 'Subway',              8.90, 1, 'Card',  'Lunch'),
('2025-02-16', 'Zara',               62.00, 5, 'Card',  'Spring preview'),

-- Week 7 (Feb 17 - Feb 23)
('2025-02-17', 'Chipotle',           13.50, 1, 'Card',  'Lunch'),
('2025-02-18', 'Trader Joes',        41.30, 2, 'Card',  'Weekly groceries'),
('2025-02-19', 'Starbucks',           6.95, 3, 'Card',  'Coffee'),
('2025-02-19', 'Amazon',             19.99, 6, 'Card',  'Cable organizer'),
('2025-02-20', 'Five Guys',          17.80, 1, 'Card',  'Burger night'),
('2025-02-21', 'H&M',                55.00, 5, 'Card',  'Clearance haul'),
('2025-02-22', 'Aldi',               28.90, 2, 'Cash',  'Groceries'),
('2025-02-23', 'Crumbl Cookies',     14.00, 1, 'Card',  'Weekend treat'),

-- Week 8 (Feb 24 - Mar 2)
('2025-02-24', 'McDonalds',          10.20, 1, 'Card',  'Quick lunch'),
('2025-02-25', 'Whole Foods',        66.10, 2, 'Card',  'Weekly groceries'),
('2025-02-26', 'Dutch Bros',          6.25, 3, 'Card',  'Morning run'),
('2025-02-26', 'Nike',               49.99, 6, 'Card',  'Running socks'),
('2025-02-27', 'Cheesecake Factory', 52.40, 1, 'Card',  'Dinner out'),
('2025-02-28', 'Urban Outfitters',   38.00, 5, 'Card',  'Sale find'),
('2025-03-01', 'Trader Joes',        37.80, 2, 'Card',  'Weekend groceries'),
('2025-03-02', 'Panera Bread',       13.60, 1, 'Card',  'Sunday lunch');


-- ============================================================
-- SECTION 3: POPULATE WEEKLY SUMMARY TABLE
-- ============================================================

INSERT INTO weekly_summary (week_start, category_id, total_spent, transaction_count)
SELECT
    DATE(purchase_date, 'weekday 0', '-6 days') AS week_start,
    category_id,
    ROUND(SUM(amount), 2)                        AS total_spent,
    COUNT(*)                                     AS transaction_count
FROM purchases
GROUP BY week_start, category_id;


-- ============================================================
-- SECTION 4: ANALYSIS QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- Query 1: Total spending per category (all time)
-- Uses: GROUP BY, SUM, ORDER BY
-- ------------------------------------------------------------
SELECT
    c.category_name,
    COUNT(p.purchase_id)        AS total_transactions,
    ROUND(SUM(p.amount), 2)     AS total_spent,
    ROUND(AVG(p.amount), 2)     AS avg_transaction,
    ROUND(MAX(p.amount), 2)     AS largest_purchase
FROM purchases p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_spent DESC;


-- ------------------------------------------------------------
-- Query 2: Monthly spending breakdown by category
-- Uses: strftime, JOIN, GROUP BY, aggregate functions
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', p.purchase_date) AS month,
    c.category_name,
    ROUND(SUM(p.amount), 2)            AS monthly_total,
    COUNT(p.purchase_id)               AS transactions
FROM purchases p
JOIN categories c ON p.category_id = c.category_id
GROUP BY month, c.category_name
ORDER BY month, monthly_total DESC;


-- ------------------------------------------------------------
-- Query 3: Weekly spending trend (total across all categories)
-- Uses: DATE functions, GROUP BY, rolling context
-- ------------------------------------------------------------
SELECT
    DATE(purchase_date, 'weekday 0', '-6 days') AS week_start,
    ROUND(SUM(amount), 2)                        AS weekly_total,
    COUNT(purchase_id)                           AS transactions,
    ROUND(AVG(amount), 2)                        AS avg_per_transaction
FROM purchases
GROUP BY week_start
ORDER BY week_start;


-- ------------------------------------------------------------
-- Query 4: Budget vs. actual spending comparison
-- Uses: JOIN, GROUP BY, CASE, calculated columns
-- ------------------------------------------------------------
SELECT
    c.category_name,
    c.monthly_budget,
    ROUND(SUM(p.amount), 2)                              AS total_spent,
    ROUND(SUM(p.amount) - c.monthly_budget, 2)           AS variance,
    CASE
        WHEN SUM(p.amount) > c.monthly_budget THEN 'OVER BUDGET'
        WHEN SUM(p.amount) > c.monthly_budget * 0.85 THEN 'Near Limit'
        ELSE 'On Track'
    END AS budget_status,
    ROUND(SUM(p.amount) / c.monthly_budget * 100, 1)    AS pct_of_budget
FROM purchases p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name, c.monthly_budget
ORDER BY pct_of_budget DESC;


-- ------------------------------------------------------------
-- Query 5: Top 10 most expensive individual purchases
-- Uses: JOIN, ORDER BY, LIMIT
-- ------------------------------------------------------------
SELECT
    p.purchase_date,
    p.merchant,
    c.category_name,
    p.amount,
    p.notes
FROM purchases p
JOIN categories c ON p.category_id = c.category_id
ORDER BY p.amount DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Query 6: Spending by day of week (behavioral pattern)
-- Uses: strftime, GROUP BY, ORDER BY
-- ------------------------------------------------------------
SELECT
    CASE strftime('%w', purchase_date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END                               AS day_of_week,
    COUNT(purchase_id)                AS transactions,
    ROUND(SUM(amount), 2)             AS total_spent,
    ROUND(AVG(amount), 2)             AS avg_spent
FROM purchases
GROUP BY strftime('%w', purchase_date)
ORDER BY total_spent DESC;


-- ------------------------------------------------------------
-- Query 7: Essential vs. discretionary spending breakdown
-- Uses: JOIN, GROUP BY, CASE
-- ------------------------------------------------------------
SELECT
    CASE c.is_essential
        WHEN 1 THEN 'Essential'
        ELSE 'Discretionary'
    END                           AS spending_type,
    COUNT(p.purchase_id)          AS transactions,
    ROUND(SUM(p.amount), 2)       AS total_spent,
    ROUND(AVG(p.amount), 2)       AS avg_transaction,
    ROUND(SUM(p.amount) * 100.0 /
        (SELECT SUM(amount) FROM purchases), 1) AS pct_of_total
FROM purchases p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.is_essential;


-- ------------------------------------------------------------
-- Query 8: Merchant frequency and loyalty analysis
-- Uses: GROUP BY, COUNT, SUM, HAVING
-- ------------------------------------------------------------
SELECT
    merchant,
    c.category_name,
    COUNT(p.purchase_id)       AS visit_count,
    ROUND(SUM(p.amount), 2)    AS total_spent,
    ROUND(AVG(p.amount), 2)    AS avg_per_visit
FROM purchases p
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.merchant
HAVING visit_count > 1
ORDER BY total_spent DESC;


-- ------------------------------------------------------------
-- Query 9: Weekly spending trend from summary table
-- Uses: JOIN, GROUP BY on pre-aggregated table
-- ------------------------------------------------------------
SELECT
    ws.week_start,
    c.category_name,
    ws.total_spent,
    ws.transaction_count,
    ROUND(ws.total_spent / ws.transaction_count, 2) AS avg_per_transaction
FROM weekly_summary ws
JOIN categories c ON ws.category_id = c.category_id
ORDER BY ws.week_start, ws.total_spent DESC;


-- ------------------------------------------------------------
-- Query 10: Month-over-month spending change
-- Uses: subquery, self-join pattern, calculated delta
-- ------------------------------------------------------------
SELECT
    curr.month,
    curr.category_name,
    curr.monthly_total,
    prev.monthly_total         AS prev_month_total,
    ROUND(curr.monthly_total - COALESCE(prev.monthly_total, 0), 2) AS month_over_month_change,
    CASE
        WHEN prev.monthly_total IS NULL THEN 'First month'
        WHEN curr.monthly_total > prev.monthly_total THEN 'Increased'
        WHEN curr.monthly_total < prev.monthly_total THEN 'Decreased'
        ELSE 'No change'
    END AS trend
FROM (
    SELECT
        strftime('%Y-%m', p.purchase_date) AS month,
        c.category_name,
        ROUND(SUM(p.amount), 2)            AS monthly_total
    FROM purchases p
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY month, c.category_name
) curr
LEFT JOIN (
    SELECT
        strftime('%Y-%m', p.purchase_date) AS month,
        c.category_name,
        ROUND(SUM(p.amount), 2)            AS monthly_total
    FROM purchases p
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY month, c.category_name
) prev
ON curr.category_name = prev.category_name
AND curr.month = strftime('%Y-%m', DATE(prev.month || '-01', '+1 month'))
ORDER BY curr.month, curr.category_name;
