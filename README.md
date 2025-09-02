
# Growth Metrics Tracker (Python + MySQL Project)

## Overview

**Growth Metrics Tracker** is a Python-based ETL workflow that processes order data, performs analytics, and integrates seamlessly with MySQL for larger-scale data handling. It’s an efficient solution for getting your data into databases and querying insights via SQL.

---

## Features

* **CSV Data Ingestion & Cleaning**
  Reads `orders.csv`, handles missing values (`'Not Available'`, `'unknown'`), and normalizes column formats.

* **Derived Metrics**
  Calculates key columns like:

* **discount**: computed from `list_price × discount_percent`

* **sale\_price**: derived by subtracting discount from list price

* **profit**: the final calculated margin

* **Date Handling**
  Converts `order_date` into proper datetime format for downstream analysis

* **MySQL Backend Integration**

* Creates the `test_db` database if it doesn’t exist

* Uploads processed data into the `orders` table using SQLAlchemy + `pymysql`

---

## Tech Stack

* **Language**: Python
* **Libraries**:

  * `pandas` — for data cleaning and manipulation
  * `sqlalchemy` & `pymysql` — for database connectivity and operations

---

## Repository Structure

```
Growth Metrics Tracker/
│
├─ flowAnalysis.py     # Main ETL and upload Python script
├─ orders.csv          # Source CSV with raw data
├─ querries.sql        # Collection of SQL queries for analysis
└─ README.md           # This document
```

---

## How to Use

1. **Install dependencies**

   ```bash
   pip install pandas sqlalchemy pymysql
   ```

2. **Run the Python script**

   ```bash
   python flowAnalysis.py
   ```

   * This reads and processes the CSV
   * Connects to local MySQL (no password config expected), creates `test_db`, and uploads the data to the `orders` table

3. **Analyze via MySQL Workbench**
   Load `querries.sql` in your MySQL Workbench or CLI and execute to retrieve insights like:

   * Top-selling products
   * Regional metrics
   * Month-over-month growth comparisons, and more

---
