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
    payment_method,

    -- Metadata Columns 
    current_timestamp() AS _ingested_at,
    'snowflake_raw' AS source_system
FROM {{ source('source', 'fact_sales') }}