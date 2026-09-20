# 📊 Olist E-Commerce Performance & Operational Bottleneck Analysis

[![Looker Studio Dashboard](https://img.shields.io/badge/Looker_Studio-Interactive_Dashboard-blue?style=for-the-badge&logo=google)](https://datastudio.google.com/s/q1fsQTlZyn0)
[![Notion Portfolio Case Study](https://img.shields.io/badge/Notion-Executive_Case_Study-000000?style=for-the-badge&logo=notion)](https://app.notion.com/p/Logistics-and-Financial-Diagnosis-of-Olist-Brazil-SLA-LTV-Optimization-3dc0102a9013805b9d14dc1c8f17a04d?source=copy_link)
[![SQL Engine](https://img.shields.io/badge/BigQuery-SQL_Data_Transformation-4285F4?style=for-the-badge&logo=googlecloud)](./sql/queries.sql)

---

## Executive Summary

This project presents an end-to-end data analytics and business strategy evaluation of **Olist**, Brazil's largest e-commerce marketplace integrator. By joining and modeling 100k+ transactional records, customer reviews, seller metrics, and geolocation data via BigQuery SQL, this analysis diagnoses key operational friction points impacting Customer Satisfaction (CSAT) and identifies strategic levers for long-term Customer Lifetime Value (LTV) retention.

The complete executive presentation is hosted interactively in **Looker Studio** and structured as a 4-page diagnostic report for C-level stakeholders.

---

## Key Business Insights & Findings

| Strategic Pillar | Diagnostic Summary | Strategic Impact |
| --- | --- | --- |
| **Commercial Dynamics** | Rapid onboarding of active sellers with flat customer retention. LTV diverges significantly after first purchase. | Customer LTV plateaus around `$140`, while cumulative Seller LTV scales up to `$5k+`. |
| **Operational Bottlenecks** | Logistics SLA failure is the primary driver of 1-star reviews. Carrier transit time accounts for 80%+ of total delivery delay. | CSAT directly drops from 4.8 to 1.2 as handling + transit time exceeds 15 days. |
| **Geospatial Imbalance** | Extreme concentration of Supply in the Southeast (SP/RJ/MG) serving distributed Demand across Brazil. | High shipping tariffs and long transit delays to North/Northeast states. |
| **Transactional Mix** | Heavy reliance on Credit Card and Boleto Bancário, with ~70% of credit sales concentrated in 1–8 installments. | Opportunities to optimize payment processing fees and installment incentives. |

---

## Interactive Dashboard Architecture (Looker Studio)

The dashboard is structured into 4 executive modules:

1. **Page 1: Commercial Dynamics**
   - `Cohort Divergence: Customer vs. Seller Cumulative LTV`
   - `Seller Revenue Concentration (ABC Analysis)`
   - `Seller Order Volume Concentration (ABC Analysis)`

2. **Page 2: Operational Bottlenecks & CSAT Impact**
   - `CSAT Score Distribution (% of Orders)`
   - `Fulfillment Time Breakdown by CSAT Score (1–5 Stars)`
   - `Route Concentration by GMV (Pareto ABC Analysis)`
   - `Top Logistics Routes Breakdown (Class A)`

3. **Page 3: Geospatial Bottleneck**
   - `Seller Supply Density (Active Sellers GMV)` vs. `Customer Demand Density (Order GMV)`
   - `State-Level Seller GMV (Supply Distribution)` vs. `State-Level Customer GMV (Demand Distribution)`

4. **Page 4: Transactional Dynamics & Category Performance**
   - `GMV Distribution by Payment Method`
   - `Credit Installment Structure (GMV Share)`
   - `Granular Installment Breakdown (1 to 8 Payments)`
   - `Product Category Concentration (Pareto ABC Analysis)` & `Class A Categories GMV Breakdown`

---

## Repository Structure
