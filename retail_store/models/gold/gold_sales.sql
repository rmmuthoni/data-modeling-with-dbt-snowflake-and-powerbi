WITH silver_sales AS (
    SELECT
        sales_id,
        date_sk,
        product_sk,
        customer_sk,
        promotion_sk,
        quantity,
        unit_price,
        gross_amount,
        net_amount,
        payment_method
    FROM {{ ref('silver_sales') }}
),

bronze_date AS (
    SELECT 
        date_sk,
        date,
        month_name,
        year
    FROM {{ ref('bronze_date') }}
),

finally AS (
    SELECT 
        sales_id,
        bronze_date.date as transaction_date,
        product_sk,
        customer_sk,
        promotion_sk,
        quantity,
        unit_price,
        gross_amount,
        net_amount,
        payment_method
    FROM silver_sales
    LEFT JOIN bronze_date USING(date_sk)
)

SELECT * FROM finally