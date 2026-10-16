SELECT 
    sales_id, 
    sum(gross_amount) AS gross_amount, 
    sum(net_amount) AS net_amount
FROM {{ ref('bronze_sales') }}
GROUP BY 1
HAVING sum(gross_amount) < 0 AND sum(net_amount) < 0