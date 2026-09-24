-- =====================================================
-- E-COMMERCE DATABASE
-- Database: PostgreSQL
-- Purpose: Create tables with constraints
-- =====================================================


-- =====================================================
-- 1. CUSTOMERS TABLE
-- =====================================================

CREATE TABLE customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY,

    customer_name VARCHAR(100) NOT NULL,

    email VARCHAR(255) NOT NULL,

    signup_date DATE NOT NULL,

    country VARCHAR(100),

    CONSTRAINT pk_customers
        PRIMARY KEY (customer_id),

    CONSTRAINT uq_customers_email
        UNIQUE (email)
);


-- =====================================================
-- 2. CATEGORIES TABLE
-- =====================================================

CREATE TABLE categories (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY,

    category_name VARCHAR(100) NOT NULL,

    CONSTRAINT pk_categories
        PRIMARY KEY (category_id),

    CONSTRAINT uq_categories_name
        UNIQUE (category_name)
);


-- =====================================================
-- 3. PRODUCTS TABLE
-- =====================================================

CREATE TABLE products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY,

    product_name VARCHAR(150) NOT NULL,

    category_id INTEGER NOT NULL,

    price NUMERIC(10, 2) NOT NULL,

    CONSTRAINT pk_products
        PRIMARY KEY (product_id),

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT chk_products_price
        CHECK (price >= 0)
);


-- =====================================================
-- 4. ORDERS TABLE
-- =====================================================

CREATE TABLE orders (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY,

    customer_id INTEGER NOT NULL,

    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',

    total_amount NUMERIC(12, 2) NOT NULL,

    CONSTRAINT pk_orders
        PRIMARY KEY (order_id),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT chk_orders_status
        CHECK (
            status IN (
                'PENDING',
                'CONFIRMED',
                'SHIPPED',
                'DELIVERED',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_orders_total_amount
        CHECK (total_amount >= 0)
);


-- =====================================================
-- 5. ORDER_ITEMS TABLE
-- =====================================================

CREATE TABLE order_items (
    order_item_id INTEGER GENERATED ALWAYS AS IDENTITY,

    order_id INTEGER NOT NULL,

    product_id INTEGER NOT NULL,

    quantity INTEGER NOT NULL,

    unit_price NUMERIC(10, 2) NOT NULL,

    CONSTRAINT pk_order_items
        PRIMARY KEY (order_item_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT uq_order_items_order_product
        UNIQUE (order_id, product_id)
);