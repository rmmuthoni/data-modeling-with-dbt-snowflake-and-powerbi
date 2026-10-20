WITH bronze_store AS (
    SELECT 
        *
    FROM {{ ref('bronze_store') }}
),

cleaned_bronze_store AS (
    SELECT
        store_sk,
        store_code,
        TRIM(store_name) AS store_name,
        TRIM(city) AS city,
        TRIM(state_province) AS state_province,
        TRIM(region) AS region,
        TRIM(country) AS country,
        CAST(open_date AS date) AS open_date,
        CAST(NULLIF(TRIM(sq_ft), 0) AS INTEGER) AS square_ft
    FROM bronze_store
)

SELECT * FROM cleaned_bronze_store