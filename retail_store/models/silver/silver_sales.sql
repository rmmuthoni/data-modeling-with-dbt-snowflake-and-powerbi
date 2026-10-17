WITH bronze_sales AS (
    SELECT 
        CAST(sales_id AS BIGINT) AS sales_id,
        CAST(date_sk AS BIGINT) AS date_sk,
        CAST(product_sk AS BIGINT) AS product_sk,
        CAST(product_sk AS BIGINT) AS customer_sk,
        promotion_sk,
        COALESCE(quantity, 0) AS quantity,
        COALESCE(unit_price, 0) AS unit_price,
        COALESCE(gross_amount, 0) AS gross_amount,
        COALESCE(discount_amount, 0) AS discount_amount,
        COALESCE(net_amount, 0) AS net_amount,
        NULLIF(TRIM(payment_method, 0), '') payment_method,

        -- Metadata Columns 
        _ingested_at,
        source_system
    FROM {{ ref('bronze_sales') }} 
),

-- Remove Deuplicates if Any 
deduplication AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY sales_id ORDER BY _ingested_at DESC) AS row_number
    FROM bronze_sales
),

finally AS (
    SELECT 
        sales_id,
        date_sk,
        product_sk,
        customer_sk,
        promotion_sk,
        quantity,
        unit_price,
        gross_amount,
        discount_amount,
        net_amount,
        payment_method
    FROM deduplication
    WHERE row_number = 1
)

SELECT * FROM finally