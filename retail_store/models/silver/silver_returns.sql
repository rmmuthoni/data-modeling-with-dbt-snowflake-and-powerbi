WITH bronze_returns AS (
    SELECT 
        sales_id,
        date_sk,
        store_sk,
        product_sk,
        NULLIF(returned_qty, 0) AS returned_quantity,
        TRIM(return_reason) AS return_reason,
        NULLIF(refund_amount, 0) as refund_amount
    FROM {{ ref('bronze_returns') }}
)

SELECT * FROM bronze_returns