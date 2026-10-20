SELECT 
    customer_code,
    customer_sk,
    first_name,
    last_name,
    gender,
    phone,
    email,
    loyalty_tier,
    signup_date,

    -- Metdadata Columns 
    current_timestamp() AS _ingested_at,
    'snowflake_raw' as _source_system
FROM {{ source('source', 'dim_customer') }}