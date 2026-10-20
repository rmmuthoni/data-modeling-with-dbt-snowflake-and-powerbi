WITH bronze_product AS (
    SELECT 
        product_sk,
        TRIM(product_code) AS product_code,
        TRIM(product_name) AS product_name,
        TRIM(department) AS department,
        TRIM(category) AS category,
        TRIM(supplier_sk) AS supplier_sk,
        NULLIF(list_price, 0) AS list_price,
        TRIM(uom) AS unit_of_measure
    FROM {{ ref('bronze_product') }}
)

SELECT * FROM bronze_product

