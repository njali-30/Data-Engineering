# E-Commerce Database — PostgreSQL

## Overview

This project creates a relational **E-Commerce database using PostgreSQL**.

The purpose of this task is to practice:

* Relational database design
* SQL `CREATE TABLE`
* Primary keys
* Foreign keys
* `NOT NULL` constraints
* `UNIQUE` constraints
* `CHECK` constraints
* Identity columns
* Default values
* Relationships between tables
* Executing a `.sql` file using PostgreSQL

---

## Project Structure

```text
01-database-design/
│
├── README.md
└── schema.sql
```

---

# Database Design

The database contains five tables:

```text
customers
    │
    │ 1 : Many
    ▼
orders
    │
    │ 1 : Many
    ▼
order_items
    ▲
    │ Many : 1
    │
products
    ▲
    │ Many : 1
    │
categories
```

### Tables

| Table         | Purpose                                |
| ------------- | -------------------------------------- |
| `customers`   | Stores customer information            |
| `categories`  | Stores product categories              |
| `products`    | Stores products and their prices       |
| `orders`      | Stores customer orders                 |
| `order_items` | Stores products included in each order |

---

# 1. Customers

The `customers` table stores customer information.

### Columns

| Column          | Data Type    | Constraint            |
| --------------- | ------------ | --------------------- |
| `customer_id`   | INTEGER      | Primary Key, Identity |
| `customer_name` | VARCHAR(100) | NOT NULL              |
| `email`         | VARCHAR(255) | NOT NULL, UNIQUE      |
| `signup_date`   | DATE         | NOT NULL              |
| `country`       | VARCHAR(100) | Optional              |

### Constraints

* `customer_id` is the primary key.
* `customer_id` is automatically generated using `GENERATED ALWAYS AS IDENTITY`.
* `email` must be unique.
* Required fields cannot contain `NULL`.

---

# 2. Categories

The `categories` table stores product categories.

### Columns

| Column          | Data Type    | Constraint            |
| --------------- | ------------ | --------------------- |
| `category_id`   | INTEGER      | Primary Key, Identity |
| `category_name` | VARCHAR(100) | NOT NULL, UNIQUE      |

### Constraints

* `category_id` is the primary key.
* `category_id` is automatically generated.
* `category_name` must be unique.

---

# 3. Products

The `products` table stores products.

### Columns

| Column         | Data Type     | Constraint            |
| -------------- | ------------- | --------------------- |
| `product_id`   | INTEGER       | Primary Key, Identity |
| `product_name` | VARCHAR(150)  | NOT NULL              |
| `category_id`  | INTEGER       | NOT NULL, Foreign Key |
| `price`        | NUMERIC(10,2) | NOT NULL, CHECK       |

### Relationship

```text
products.category_id
        ↓
categories.category_id
```

Each product belongs to a category.

### Constraint

```sql
CHECK (price >= 0)
```

This prevents negative product prices.

---

# 4. Orders

The `orders` table stores customer orders.

### Columns

| Column         | Data Type     | Constraint            |
| -------------- | ------------- | --------------------- |
| `order_id`     | INTEGER       | Primary Key, Identity |
| `customer_id`  | INTEGER       | NOT NULL, Foreign Key |
| `order_date`   | TIMESTAMP     | NOT NULL, Default     |
| `status`       | VARCHAR(30)   | NOT NULL, Default     |
| `total_amount` | NUMERIC(12,2) | NOT NULL, CHECK       |

### Relationship

```text
orders.customer_id
        ↓
customers.customer_id
```

Each order belongs to a customer.

### Default Values

If no order date is provided:

```sql
DEFAULT CURRENT_TIMESTAMP
```

is used.

If no status is provided:

```sql
DEFAULT 'PENDING'
```

is used.

### Allowed Order Statuses

```text
PENDING
CONFIRMED
SHIPPED
DELIVERED
CANCELLED
```

The `CHECK` constraint prevents any other status from being inserted.

---

# 5. Order Items

The `order_items` table connects orders with products.

### Columns

| Column          | Data Type     | Constraint            |
| --------------- | ------------- | --------------------- |
| `order_item_id` | INTEGER       | Primary Key, Identity |
| `order_id`      | INTEGER       | NOT NULL, Foreign Key |
| `product_id`    | INTEGER       | NOT NULL, Foreign Key |
| `quantity`      | INTEGER       | NOT NULL, CHECK       |
| `unit_price`    | NUMERIC(10,2) | NOT NULL, CHECK       |

### Relationships

```text
order_items.order_id
        ↓
orders.order_id

order_items.product_id
        ↓
products.product_id
```

### Constraints

Quantity must be greater than zero:

```sql
CHECK (quantity > 0)
```

Unit price cannot be negative:

```sql
CHECK (unit_price >= 0)
```

The combination of `order_id` and `product_id` must be unique:

```sql
UNIQUE (order_id, product_id)
```

This prevents the same product from appearing multiple times within the same order.

---

# Database Relationships

The database represents the following relationships:

```text
customers
    │
    │ 1 : Many
    ▼
orders
    │
    │ 1 : Many
    ▼
order_items
    ▲
    │ Many : 1
    │
products
    ▲
    │ Many : 1
    │
categories
```

More specifically:

```text
customers.customer_id
        ↓
orders.customer_id

categories.category_id
        ↓
products.category_id

orders.order_id
        ↓
order_items.order_id

products.product_id
        ↓
order_items.product_id
```

`order_items` acts as the bridge between `orders` and `products`, allowing an order to contain multiple products and a product to appear in multiple orders.

---

# PostgreSQL Setup

## Prerequisites

You need:

* PostgreSQL
* PostgreSQL command-line tool (`psql`)
* VS Code
* `schema.sql`

PostgreSQL is the database server, while `psql` is the command-line client used to communicate with the server.

---

# Step 1 — Check PostgreSQL Service

Run:

```powershell
Get-Service *postgres*
```

The PostgreSQL service should have a status of:

```text
Running
```

If the service is stopped, start it using:

```powershell
Start-Service postgresql-x64-18
```

---

# Step 2 — Check `psql`

Run:

```powershell
psql --version
```

Expected output:

```text
psql (PostgreSQL) 18.x
```

---

# Step 3 — Connect to PostgreSQL

Run:

```powershell
psql -U postgres -h 127.0.0.1
```

Enter the password for the PostgreSQL `postgres` user.

Successful connection:

```text
postgres=#
```

---

# Step 4 — Create the Database

Inside `psql`, create the project database:

```sql
CREATE DATABASE e_commerce;
```

Expected:

```text
CREATE DATABASE
```

Connect to the database:

```sql
\c e_commerce
```

The prompt should become:

```text
e_commerce=#
```

---

# Step 5 — Execute `schema.sql`

Exit `psql`:

```sql
\q
```

Open a terminal in the project directory containing `schema.sql`.

Run:

```powershell
psql -U postgres -h 127.0.0.1 -d e_commerce -f schema.sql
```

Enter the PostgreSQL password.

If the schema executes successfully, PostgreSQL should display:

```text
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
```

There should be no `ERROR` messages.

---

# Step 6 — Verify the Tables

Connect to the database:

```powershell
psql -U postgres -h 127.0.0.1 -d e_commerce
```

Then run:

```sql
\dt
```

Expected tables:

```text
categories
customers
order_items
orders
products
```

---

# Step 7 — Inspect Table Structure

To inspect a table:

```sql
\d customers
```

Other tables:

```sql
\d categories
\d products
\d orders
\d order_items
```

These commands show columns, data types, constraints, indexes, and relationships.

---

# Useful PostgreSQL Commands

### List databases

```sql
\l
```

### Connect to a database

```sql
\c database_name
```

### List tables

```sql
\dt
```

### Describe a table

```sql
\d table_name
```

### Show current database

```sql
SELECT current_database();
```

### Exit PostgreSQL

```sql
\q
```

### Turn off the output pager

```sql
\pset pager off
```

---

# Re-running the Schema

The tables are created when `schema.sql` is executed successfully.

Running the same script again without removing the existing tables will produce errors such as:

```text
ERROR: relation "customers" already exists
```

To recreate the schema from scratch, connect to the `e_commerce` database and run:

```sql
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
```

The tables should be dropped in this order because foreign-key relationships exist between them.

Then execute `schema.sql` again:

```powershell
psql -U postgres -h 127.0.0.1 -d e_commerce -f schema.sql
```

# Next Steps

The database design stage is followed by SQL querying and data engineering practice.

Planned progression:

1. Insert sample data
2. Basic `SELECT` queries
3. Filtering with `WHERE`
4. Sorting with `ORDER BY`
5. Aggregation with `GROUP BY`
6. Aggregate functions
7. Multi-table `JOIN`s
8. Subqueries
9. CTEs
10. Conditional aggregation
11. Window functions
12. Ranking and top-k problems
13. Time-series analysis
14. Deduplication
15. Data quality
16. Indexes and query plans
17. Incremental loading
18. Fact and dimension modeling

