# SQL Spending Database: Personal Finance Analytics

A relational database project tracking personal food and shopping expenses using SQL. Includes schema design, seed data, and analytical queries.

## Tools
- SQL (SQLite)
- DB Browser for SQLite / sqliteonline.com

## What This Project Does
- Designed a relational database schema with 3 tables: categories, purchases, and weekly_summary
- Loaded 10 weeks of real-world spending transactions across Food & Dining and Shopping
- Wrote 10 analytical queries using JOIN, GROUP BY, aggregate functions, and subqueries
- Analyzed weekly spending trends, budget vs. actual comparisons, and merchant patterns
- Identified highest expense categories and day-of-week spending behavior

## Key Queries
| Query | Description |
|-------|-------------|
| Total by category | Ranked spending across all categories |
| Budget vs. actual | Flags over-budget and near-limit categories |
| Weekly trend | Tracks spending week over week |
| Day of week analysis | Identifies highest spending days |
| Month-over-month change | Measures spending increase or decrease by month |
| Merchant loyalty | Finds most frequently visited merchants |

## How to Run
1. Go to sqliteonline.com
2. Click File > Open SQL and upload `personal_finance_analytics.sql`
3. Hit Run to execute all queries and view results

## Files
| File | Description |
|------|-------------|
| `personal_finance_analytics.sql` | Full schema, seed data, and all 10 analysis queries |
