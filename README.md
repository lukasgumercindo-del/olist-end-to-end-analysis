# 📦 Olist E-Commerce Analytics

> Análise de dados end-to-end sobre o ecossistema de e-commerce da Olist: ingestão, modelagem relacional, diagnóstico de gargalos logísticos e visualização executiva.

![Python](https://img.shields.io/badge/Python-3-blue) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791) ![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811) ![Status](https://img.shields.io/badge/Status-Concluído-brightgreen)

---

## 📌 Sobre o Projeto

Este projeto foi desenvolvido para fins de portfólio em Data Analytics, com o objetivo de simular uma análise de negócio real sobre a base pública da **Olist**, maior marketplace do Brasil.

A proposta ia além de extrair métricas de vendas: o foco central foi investigar a **causa raiz das taxas de atraso nas entregas**, indo do dado bruto até um diagnóstico executivo acionável — o tipo de entrega que um analista de dados apresentaria à liderança de uma empresa.

**Principal achado:** o estado do Rio de Janeiro apresentava uma taxa de atraso quase 2x acima da média nacional (12,17%). Ao investigar a fundo, identifiquei que o gargalo não estava nas regiões mais distantes do país, como seria intuitivo supor, mas sim na própria rota São Paulo → Rio de Janeiro, com 15,50% de atraso — revelando um problema operacional na malha logística mais movimentada do e-commerce brasileiro.

---

## 🎯 KPIs Principais

| Métrica | Valor |
|---|---|
| Faturamento Total | R$ 16,01 Mi |
| Total de Pedidos | 99.441 |
| Ticket Médio | R$ 160,99 |
| Pedidos Atrasados | ~7.000 (7%) |

---

## 🔎 Insights de Negócio

### 1. O Gargalo do Rio de Janeiro

Analisando o desempenho logístico por estado (filtrando apenas estados com volume relevante, via `HAVING COUNT > 100`), o RJ se destacou como o estado com pior desempenho de entrega do país:

- **1.503 pedidos atrasados**
- **Taxa de atraso: 12,17%** — quase o dobro da média nacional

### 2. Causa Raiz: a rota SP → RJ

A hipótese inicial era de que regiões mais distantes (Norte/Nordeste) explicariam a maior parte dos atrasos. Cruzando o estado do vendedor (origem) com o estado do cliente (destino = RJ), o achado foi outro:

| Origem (Vendedor) | Destino (Cliente) | Pedidos | Atrasados | Taxa de Atraso |
|---|---|---|---|---|
| São Paulo (SP) | Rio de Janeiro (RJ) | 8.188 | 1.269 | **15,50%** |

**Diagnóstico:** como São Paulo concentra a maior parte dos vendedores e do volume de vendas do e-commerce nacional, gargalos na malha logística dessa rota específica impactam desproporcionalmente a percepção de qualidade da Olist no RJ.

---

## 🧱 Pipeline de Dados

| Etapa | Ferramenta | Descrição |
|---|---|---|
| 1. Ingestão | Python (Pandas, SQLAlchemy, psycopg2) | Carga dos CSVs brutos da Olist para o PostgreSQL |
| 2. Modelagem | PostgreSQL | Criação da view analítica `vw_pedidos_analitico`, unificando pedidos, itens e clientes, com tratamento de nulos e cálculo de flags de atraso |
| 3. Análise Exploratória | SQL (CTEs, subqueries, `HAVING`) | Investigação de gargalos logísticos por região |
| 4. Visualização | Power BI | Dashboard executivo interativo, conectado nativamente ao PostgreSQL |

---

## 🛠️ Tecnologias

- **Python 3** — Pandas, SQLAlchemy, psycopg2
- **PostgreSQL** / pgAdmin 4
- **SQL** — DDL, DML, Window Functions, Aggregate Functions (`SUM`, `COUNT`, `ROUND`, `HAVING`)
- **Power BI Desktop** — conexão nativa com PostgreSQL

---

## 📁 Estrutura do Repositório
olist-data-analysis/
├── 01_create_views.sql                  # Modelagem e criação da view analítica
├── 02_business_queries.sql              # Consultas de faturamento, atrasos e deep dive
├── dashboard_analise_vendas_olist.pbix   # Dashboard executivo (Power BI)
└── README.md

---

## 🚀 Como Executar

```bash
# 1. Clone o repositório
git clone https://github.com/lukasgumercindo-del/olist-data-analysis.git

# 2. Carregue os dados brutos no PostgreSQL (via script Python ou import manual)

# 3. Rode o script de modelagem
psql -U seu_usuario -d seu_banco -f 01_create_views.sql

# 4. Abra o dashboard_analise_vendas_olist.pbix no Power BI
#    e atualize a fonte de dados apontando para o seu servidor local
```

> **Nota:** para rodar localmente, é necessário ter um servidor PostgreSQL configurado e substituir `seu_usuario` / `seu_banco` pelas suas credenciais.

---

<p align="center"><i>Desenvolvido para fins de portfólio em Data Analytics</i></p>
