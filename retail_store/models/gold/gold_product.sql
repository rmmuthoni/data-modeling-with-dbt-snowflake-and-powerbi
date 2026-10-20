WITH silver_product AS (
    SELECT 
        product_sk,
        product_code,
        product_name,
        department,
        category,
        supplier_sk,
        list_price,
        unit_of_measure
    FROM {{ ref('silver_product') }}
),

returns_by_product AS (
    SELECT 
        product_sk,
        COUNT(*) as total_returns,
        SUM(returned_quantity) AS total_returned_quantity
    FROM {{ ref('silver_returns') }}
    GROUP BY 1
),

finally AS (
    SELECT 
        *,
        list_price * total_returned_quantity AS total_value_of_returned_products
    FROM silver_product 
    LEFT JOIN returns_by_product USING(product_sk)
)

SELECT * FROM finally