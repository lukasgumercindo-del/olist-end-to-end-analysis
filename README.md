📦 Olist E-Commerce Analytics

Análise de Dados End-to-End: Ingestão, Modelagem Relacional, Diagnóstico de Gargalos Logísticos e Visualização Executiva.

Python PostgreSQL Power BI Data Analytics

📌 Visão Geral do Projeto

Este projeto realiza uma análise completa de inteligência de negócios (End-to-End) sobre o ecossistema de e-commerce da Olist no Brasil. O objetivo principal foi compreender a dinâmica de faturamento da empresa e investigar a fundo a causa raiz das taxas de atraso nas entregas, fornecendo diagnósticos orientados a dados para a tomada de decisão estratégica.

💡 Destaque do Projeto: Mais do que extrair métricas de vendas, a análise identificou que o estado do Rio de Janeiro (RJ) apresentava uma taxa crítica de atrasos (12,17%) e realizou um Deep Dive que provou que o principal gargalo logístico está na rota de envios originados em São Paulo (SP) para o RJ, com impressionantes 15,50% de atraso.

🎯 Principais Métricas de Negócio (KPIs)
Faturamento Total	Total de Pedidos	Ticket Médio	Pedidos Atrasados
R$ 16,01 Mi	99.441	R$ 160,99	~7.000 (7%)
📐 Arquitetura & Pipeline de Dados

O fluxo de desenvolvimento foi dividido em 4 etapas estruturadas, garantindo governança, reprodutibilidade e alta performance no processamento dos dados:

Ingestão e Tratamento (Python): Carregamento das bases relacionais brutas (CSVs do Olist) para o banco de dados PostgreSQL utilizando Pandas e SQLAlchemy.
Modelagem & Tratamento SQL (PostgreSQL): Criação da View analítica unificada vw_pedidos_analitico com consolidação de tabelas de pedidos, itens e clientes, tratamento de valores nulos e cálculos operacionais (diferença de dias úteis e flags de atraso).
Análise Exploratória & Deep Dive (SQL): Execução de consultas analíticas avançadas (agrupamentos, subqueries, CTEs e filtros agregados com HAVING) para investigar gargalos por região.
Visualização de Dados (Power BI): Construção de um Dashboard Executivo interativo conectado diretamente ao PostgreSQL para apresentação de métricas e filtros dinâmicos.
🔎 Principais Insights & Storytelling de Negócio
1. O Gargalo do Rio de Janeiro (RJ)

Ao analisar o desempenho logístico por estado (considerando apenas estados com volume estatisticamente relevante de pedidos, via HAVING COUNT > 100), o Rio de Janeiro destacou-se negativamente como o estado com a maior taxa de atrasos do país:

Total de Pedidos Atrasados para RJ: 1.503 pedidos
Taxa de Atraso (%): 12,17% (quase o dobro da média nacional)
2. Causa Raiz: A Rota Logística SP ➔ RJ

A suposição inicial era de que regiões mais distantes (como Norte e Nordeste) causariam a maior parte dos atrasos no RJ. Porém, a investigação profunda cruzando o Estado do Vendedor (Origem) com o Estado do Cliente (Destino = RJ) revelou um achado crítico:

Estado Vendedor (Origem)	Estado Cliente (Destino)	Total Pedidos	Pedidos Atrasados	Taxa de Atraso (%)
São Paulo (SP)	Rio de Janeiro (RJ)	8.188	1.269	15,50%

📌 Diagnóstico Executivo: Como São Paulo concentra a maior fatia de vendedores e volume de vendas do e-commerce, o gargalo na malha rodoviária e no processamento logístico da rota SP ➔ RJ impacta severamente a percepção de qualidade da Olist no estado do Rio de Janeiro.

📁 Estrutura do Repositório
olist-data-analysis/
├── 01_create_views.sql                 # Script SQL de modelagem e criação da View analítica
├── 02_business_queries.sql             # Consultas SQL para análise de faturamento, atrasos e Deep Dive
├── dashboard_analise_vendas_olist.pbix  # Dashboard executivo desenvolvido no Power BI
├── assets/
│   └── dashboard_preview.png           # Imagem/Print do Dashboard para exibição no README
└── README.md                           # Documentação completa do projeto
🛠️ Tecnologias Utilizadas
Python 3: Pandas, SQLAlchemy, psycopg2
Banco de Dados: PostgreSQL / pgAdmin 4
Linguagem SQL: DDL, DML, Window Functions, Aggregate Functions (SUM, COUNT, ROUND, HAVING)
Business Intelligence: Power BI Desktop (Conexão nativa PostgreSQL)
