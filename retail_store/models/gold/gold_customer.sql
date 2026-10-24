{{
  config(
    materialized = 'incremental',
    unique_key = 'customer_code',
    incremental_strategy = 'merge'
    )
}}

WITH silver_customer_details AS (
    SELECT 
        *
    FROM {{ ref('silver_customer') }}
    {% if is_incremental() %}
      WHERE signup_date > (SELECT MAX(signup_date) FROM {{ this }})
    {% endif %}
),


silver_sales_aggregated AS (
    SELECT 
        customer_sk,
        MAX(date_sk) AS max_date_sk,
        MIN(date_sk) AS min_date_sk,
        SUM(quantity) AS total_quantity,
        SUM(gross_amount) AS total_gross_amount,
        SUM(net_amount) AS total_net_amount
    FROM {{ ref('silver_sales') }}
    GROUP BY customer_sk
),

bronze_date AS (
    SELECT 
        date_sk,
        date,
        month_name,
        year
    FROM {{ ref('bronze_date') }}
),

customer_sales_summary AS (
    SELECT 
        silver_customer_details.customer_sk,
        silver_customer_details.customer_code,
        silver_customer_details.full_name,
        silver_customer_details.first_name,
        silver_customer_details.last_name,
        silver_customer_details.gender,
        silver_customer_details.phone,
        silver_customer_details.email,
        silver_customer_details.signup_date,
        silver_customer_details.loyalty_tier,
        silver_sales_aggregated.max_date_sk AS max_date_sk,
        silver_sales_aggregated.min_date_sk AS min_date_sk,
        COALESCE(silver_sales_aggregated.total_quantity, 0) AS total_quantity,
        COALESCE(silver_sales_aggregated.total_gross_amount, 0) AS total_gross_amount,
        COALESCE(silver_sales_aggregated.total_net_amount, 0) AS lifetime_value,
        _ingested_at,
        _source_system
    FROM silver_customer_details
    LEFT JOIN silver_sales_aggregated USING(customer_sk)
),

finally AS (
    SELECT 
        customer_sales_summary.customer_sk AS customer_sk,
        customer_sales_summary.customer_code AS customer_code,
        customer_sales_summary.full_name,
        first_name,
        last_name,
        customer_sales_summary.phone,
        customer_sales_summary.email,
        customer_sales_summary.signup_date,
        customer_sales_summary.loyalty_tier,
        total_gross_amount,
        lifetime_value,
        gender,
        bronze_date_max.date AS most_recent_order_date,
        bronze_date_min.date AS first_order_date,
         _ingested_at,
        _source_system
    FROM customer_sales_summary
    LEFT JOIN bronze_date AS bronze_date_max 
        ON bronze_date_max.date_sk = customer_sales_summary.max_date_sk
    LEFT JOIN bronze_date AS bronze_date_min
        ON bronze_date_min.date_sk = customer_sales_summary.min_date_sk
)

SELECT * FROM finally