# 🛡️ Insurance Portfolio, Claims & Risk Analytics Using SQL

## 📌 Project Overview

This project is an end-to-end **SQL-based Insurance Analytics project** designed to analyze insurance portfolio performance, customer risk, premium revenue, claims, fraud patterns, and profitability.

The project uses a **realistic simulated insurance dataset** and SQL queries to transform raw insurance data into meaningful business insights that can support **risk management, pricing decisions, claims optimization, customer retention, and portfolio performance**.

---

## 🎯 Business Objective

The primary objective is to understand:

* How the insurance portfolio is performing
* Which policy types generate the most premium
* Which segments have higher claim frequency and severity
* How claims impact portfolio profitability
* Which customers and policies carry higher risk
* How fraud affects claims
* How agents contribute to premium generation
* What factors are driving insurance losses
* Where management can take corrective action

---

## 🗂️ Dataset Structure

The database contains **6 relational tables**:

| Table       | Description                                                     |
| ----------- | --------------------------------------------------------------- |
| `Customers` | Customer demographics, income, location and segments            |
| `Policies`  | Policy details, premium, sum assured, risk and status           |
| `Claims`    | Claim amounts, status, reasons, processing and fraud indicators |
| `Payments`  | Premium payment transactions and payment status                 |
| `Agents`    | Agent information and performance                               |
| `Dim_Date`  | Date, month, quarter and financial-year information             |

### 🔗 Key Relationships

```text
Customers
    │
    ├── Policies ──── Agents
    │      │
    │      ├── Claims
    │      │
    │      └── Payments
    │
    └── Claims / Payments

Dim_Date → Policies
Dim_Date → Claims
Dim_Date → Payments
```

---

## 🔍 Analysis Performed

The project contains **12 major analytical areas**:

### 1. Data Validation & Quality Checks

* Duplicate detection
* NULL value checks
* Referential integrity
* Data consistency checks

### 2. Portfolio & Policy Analysis

* Total policies
* Policy status
* Policy type distribution
* Customer coverage
* Sum assured analysis

### 3. Premium & Revenue Analysis

* Total premium
* Average premium
* Premium by policy type
* Premium by customer segment
* Premium contribution analysis

### 4. Claims Analysis

* Total claims
* Claim amounts
* Approved amounts
* Claim status
* Claim types
* Claim reasons

### 5. Claim Frequency & Severity

* Claim frequency
* Average claim amount
* Claim severity
* Claim frequency by policy type and risk category

### 6. Loss Ratio & Profitability

* Loss ratio
* Premium vs claim amount
* Policy-level profitability indicators
* Risk-based profitability analysis

### 7. Customer Risk Analysis

* Customer segments
* Risk categories
* Customer claim behavior
* High-risk customer identification

### 8. Policy Risk Analysis

* Risk category performance
* Policy-level claim patterns
* High-risk policy segments

### 9. Fraud Analysis

* Fraud claim identification
* Fraud rate
* Fraud-related claim amounts
* Fraud exposure analysis

### 10. Agent Performance

* Policies sold
* Premium generated
* Average premium per policy
* Regional agent performance

### 11. Time & Seasonality Analysis

* Monthly trends
* Quarterly trends
* Yearly performance
* Claim and premium seasonality

### 12. Business Insights & Recommendations

The final analysis converts SQL findings into actionable business insights related to:

* Risk management
* Pricing and underwriting
* Claims management
* Fraud monitoring
* Customer retention
* Portfolio optimization

---

## 🛠️ Tools & Technologies

* **MySQL**
* **SQL**
* **MySQL Workbench**

### SQL Concepts Used

* `SELECT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* `HAVING`
* `CASE`
* `JOIN`
* `LEFT JOIN`
* `CTE`
* Aggregate Functions
* Subqueries
* Date Functions
* Conditional Aggregation
* KPI Calculations

---

## 📈 Key Business KPIs

The project calculates important insurance KPIs including:

* Total Policies
* Total Customers
* Total Premium
* Total Claims
* Total Claim Amount
* Approved Claim Amount
* Claim Frequency
* Claim Severity
* Loss Ratio
* Claim Approval Ratio
* Fraud Rate
* Average Claim Processing Time
* Premium per Policy

---

## 💡 Business Impact

The analysis can help an insurance business:

* Identify high-risk policy segments
* Monitor claim frequency and severity
* Detect potential fraud exposure
* Evaluate portfolio profitability
* Improve underwriting and pricing decisions
* Optimize claims processing
* Evaluate agent performance
* Improve customer retention strategies
* Support data-driven management decisions

---

## 📁 Project Structure

```text
Insurance-Portfolio-Claims-Risk-Analytics/
│
├── README.md
│
├── SQL/
│   ├── 01_Data_Validation.sql
│   ├── 02_Portfolio_Policy_Analysis.sql
│   ├── 03_Premium_Revenue_Analysis.sql
│   ├── 04_Claims_Analysis.sql
│   ├── 05_Claim_Frequency_Severity.sql
│   ├── 06_Loss_Ratio_Profitability.sql
│   ├── 07_Customer_Risk_Analysis.sql
│   ├── 08_Policy_Risk_Analysis.sql
│   ├── 09_Fraud_Analysis.sql
│   ├── 10_Agent_Performance.sql
│   ├── 11_Time_Seasonality_Analysis.sql
│   └── 12_Business_Insights_Recommendations.sql
│
└── Dataset/
    ├── Customers.csv
    ├── Policies.csv
    ├── Claims.csv
    ├── Payments.csv
    ├── Agents.csv
    └── Dim_Date.csv
```

---

## 🚀 Project Workflow

```text
Raw Insurance Data
        ↓
Data Validation
        ↓
Data Exploration
        ↓
SQL Analysis
        ↓
KPI Calculation
        ↓
Risk & Claims Analysis
        ↓
Fraud & Profitability Analysis
        ↓
Business Insights
        ↓
Recommendations
```

---

## 📌 Project Type

**Portfolio Project | Insurance Analytics | SQL | BFSI Analytics**

> **Note:** This project uses a realistic simulated dataset created for learning, portfolio development, and analytical demonstration. It does not represent the actual data or performance of any real insurance company.

---

## 👤 Author

**Ankar G**

Data Analytics | SQL | Excel | Python | Power BI | Tableau

---

⭐ If you found this project useful, feel free to explore the SQL analysis and datasets included in the repository.
