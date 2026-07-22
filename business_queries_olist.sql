SELECT 'orders' AS tabela, COUNT(*) AS total FROM raw_orders
UNION ALL
SELECT 'customers', COUNT(*) FROM raw_customers
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw_order_items
UNION ALL
SELECT 'products', COUNT(*) FROM raw_products;

SELECT 
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_delivered_customer_date,
	dias_atraso
FROM raw_orders
WHERE foi_atrasado = 1
LIMIT 10;

SELECT 
	o.order_status,
	COUNT(DISTINCT o.order_id) AS total_pedidos,
	ROUND(SUM(p.payment_value):: NUMERIC, 2) AS faturamento_total
FROM raw_orders o
JOIN raw_order_payments p ON o.order_id = p.order_id
GROUP BY o.order_status
ORDER BY faturamento_total DESC;

CREATE OR REPLACE VIEW vw_pedidos_analitico AS
SELECT 
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp AS data_compra,
    o.order_delivered_customer_date AS data_entrega,
    o.order_estimated_delivery_date AS data_estimada,
    o.dias_atraso,
    o.foi_atrasado,
    COALESCE(p.faturamento_total, 0) AS valor_total_pedido,
    COALESCE(p.total_parcelas, 1) AS total_parcelas
FROM raw_orders o
LEFT JOIN raw_customers c 
    ON o.customer_id = c.customer_id
LEFT JOIN (
    SELECT 
        order_id, 
        SUM(payment_value) AS faturamento_total,
        MAX(payment_installments) AS total_parcelas
    FROM raw_order_payments
    GROUP BY order_id
) p ON o.order_id = p.order_id;

SELECT
	customer_state AS estado,
	COUNT(DISTINCT order_id) AS total_pedidos,
	ROUND(AVG(valor_total_pedido)::NUMERIC, 2) AS faturamento_total
FROM vw_pedidos_analitico
WHERE order_status = 'delivered'
GROUP BY customer_state
ORDER BY faturamento_total DESC
LIMIT 5;

SELECT 
	p.foi_atrasado,
	COUNT(DISTINCT p.order_id) AS qtd_pedidos,
	ROUND(AVG(r.review_score):: NUMERIC, 2) AS nota_media_satisfacao
FROM vw_pedidos_analitico p
JOIN raw_order_reviews r ON p.order_id = r.order_id
GROUP BY p.foi_atrasado;

SELECT
	DATE_TRUNC('month', data_compra):: DATE AS mes,
	COUNT(DISTINCT order_id) AS total_pedido,
	ROUND(SUM(valor_total_pedido)::NUMERIC, 2) AS faturamento_total,
	ROUND(AVG(valor_total_pedido)::NUMERIC, 2) ticket_medio
FROM vw_pedidos_analitico
WHERE order_status = 'delivered'
GROUP BY DATE_TRUNC('month', data_compra)
ORDER BY mes ASC;

SELECT 
	p.customer_state AS estado,
	COUNT(DISTINCT p.order_id) AS total_pedido,
	SUM(p.foi_atrasado) AS pedidos_atrasado,
	ROUND((SUM(p.foi_atrasado)::NUMERIC / COUNT(DISTINCT p.order_id)) *100, 2) AS pct_atraso,
	ROUND(AVG(r.review_score)::NUMERIC, 2) AS nota_media_cliente
FROM vw_pedidos_analitico p
LEFT JOIN raw_order_reviews r ON p.order_id = r.order_id
WHERE p.order_status = 'delivered'
GROUP BY p.customer_state
HAVING COUNT(DISTINCT p.order_id) > 100
LIMIT 
ORDER BY pct_atraso DESC;


SELECT 
	payment_type AS tipo_pagamento,
	COUNT(DISTINCT order_id) AS qtd_pedidos,
	ROUND(SUM(payment_value)::NUMERIC, 2) AS faturamento_total,
	ROUND(AVG(payment_installments)::NUMERIC, 1) AS media_parcelas
FROM raw_order_payments
GROUP BY payment_type
ORDER BY faturamento_total DESC;

SELECT
	s.seller_state AS estado_vendedor,
	COUNT(DISTINCT p.order_id) AS total_pedidos_para_rj,
	SUM(p.foi_atrasado) AS pedido_atrasado,
	ROUND((SUM(p.foi_atrasado)::NUMERIC / COUNT(DISTINCT p.order_id)) *100, 2) AS pct_atraso
FROM vw_pedidos_analitico p
JOIN raw_order_items i ON p.order_id = i.order_id
JOIN raw_sellers s ON i.seller_id = s.seller_id
WHERE p.customer_state = 'RJ'
AND p.order_status = 'delivered'
GROUP BY s.seller_state
HAVING COUNT(DISTINCT p.order_id) > 50
ORDER BY pct_atraso DESC;
	