-- Cleaning the customer data
SELECT 
    *
FROM {{ ref('bronze_customer') }}