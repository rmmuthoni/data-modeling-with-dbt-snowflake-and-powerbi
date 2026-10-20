WITH bronze_customer AS (
    SELECT * FROM {{ ref('bronze_customer') }}
),

cleaned_customer AS (
    SELECT 
        TRIM(customer_code) AS customer_code,
        TRIM(customer_sk) AS customer_sk,
        NULLIF(TRIM(first_name), '') AS first_name,
        NULLIF(TRIM(last_name), '') AS last_name,
        gender,
        REGEXP_REPLACE(phone, '[^0-9+]', '') AS phone,
        NULLIF(TRIM(email), '') AS email,
        
        CASE
            WHEN loyalty_tier = 'None' THEN 'Retail Mass' ELSE loyalty_tier
        END AS loyalty_tier,

        signup_date,
        _ingested_at,
        _source_system
    FROM bronze_customer
),

-- Remove any duplicated customer record
deduplicated_customer AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY customer_code ORDER BY _ingested_at DESC) AS row_number
    FROM cleaned_customer
),

finally AS (
    SELECT 
        customer_code,
        customer_sk,
        first_name,
        last_name,
        CONCAT(first_name, ' ', last_name) AS full_name,
        gender,
        phone,
        email,
        loyalty_tier,
        signup_date
    FROM deduplicated_customer 
    WHERE row_number = 1
)

SELECT * FROM finally