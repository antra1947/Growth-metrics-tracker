import pandas as pd
from sqlalchemy import create_engine, text

# Load CSV with null values handled
df = pd.read_csv('orders.csv', na_values=['Not Available', 'unknown'])

# Clean column names
df.columns = df.columns.str.lower().str.replace(' ', '_')
print("Cleaned column names:", df.columns.tolist())

# Derive discount column
df['discount'] = df['list_price'] * df['discount_percent'] * 0.01

# Calculate sale price
df['sale_price'] = df['list_price'] - df['discount']

# Calculate profit
df['profit'] = df['sale_price'] - df['cost_price']

# Convert order_date to datetime
df['order_date'] = pd.to_datetime(df['order_date'], format="%Y-%m-%d")

# Drop unnecessary columns
df.drop(columns=['list_price', 'cost_price', 'discount_percent'], inplace=True)

#  MySQL connection (no password)
username = 'root'
password = ''  # No password
host = 'localhost'
port = '3306'
database = 'test_db'

# Step 1: Connect without database to create it if needed
engine = create_engine(f"mysql+pymysql://{username}:{password}@{host}:{port}")

try:
    with engine.connect() as conn:
        conn.execute(text("CREATE DATABASE IF NOT EXISTS test_db"))
        print("Database 'test_db' created or already exists.")
except Exception as e:
    print("Failed to create database:", e)

# Step 2: Connect to the database and upload the DataFrame
engine = create_engine(f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}")

try:
    df.to_sql(name='orders', con=engine, if_exists='replace', index=False)
    print("Data uploaded to MySQL successfully!")
except Exception as e:
    print("Upload failed:", e)
