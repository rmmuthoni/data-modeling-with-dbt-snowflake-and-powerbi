WITH silver_returns AS (
    SELECT 
        sales_id,
        date_sk,
        store_sk,
        product_sk,
        returned_quantity,
        return_reason,
        refund_amount
    FROM {{ ref('silver_returns') }}
),

bronze_date AS (
    SELECT 
        date_sk,
        date
    FROM {{ ref('bronze_date') }}
),

cleaned_returns AS (
    SELECT
        silver_returns.sales_id,
        bronze_date.date AS return_date,
        silver_returns.store_sk,
        silver_returns.product_sk,
        silver_returns.returned_quantity,
        silver_returns.return_reason,
        silver_returns.refund_amount
    FROM silver_returns
    LEFT JOIN bronze_date USING(date_sk)
)

SELECT * FROM cleaned_returns