WITH bronze_sales AS (
    SELECT 
        sales_id,
        product_sk, 
        customer_sk,
        gross_amount, 
        payment_method,
        quantity,
        unit_price,
        date_sk
    FROM {{ ref('bronze_sales') }}
),

bronze_product AS (
    SELECT
        product_sk, 
        category
    FROM {{ ref('bronze_product') }}
), 

bronze_customer AS (
    SELECT 
        customer_sk,
        gender,
        first_name, 
        last_name 
    FROM {{ ref('bronze_customer') }}
),

bronze_date AS (
    SELECT
        date_sk,
        date
    FROM {{ ref('bronze_date') }}
),

finally AS (
    SELECT 
        bronze_sales.sales_id, 
        bronze_sales.quantity,
        bronze_sales.unit_price,
        bronze_sales.gross_amount,
        bronze_sales.payment_method,
        bronze_product.category,
        bronze_customer.first_name,
        bronze_customer.last_name,
        bronze_customer.gender,
        bronze_date.date
    FROM bronze_sales
    LEFT JOIN bronze_product USING(product_sk)
    LEFT JOIN bronze_customer USING(customer_sk)
    LEFT JOIN bronze_date USING(date_sk)
)

SELECT * FROM finally