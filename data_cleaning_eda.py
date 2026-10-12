import pandas as pd
import numpy as np


df=pd.read_csv('C:\\Users\\alok3\\OneDrive\\Desktop\\Programming  Language\\main_project_2_swiggy_analysis\\order_history_kaggle_data.csv')
# print(df.dtypes)


# print(df.isnull().sum())


# print("Duplicate Order ID:\n",df["Order ID"].duplicated().sum())


# print(df["Order Status"].value_counts())


# print(df["Order Ready Marked"].value_counts())


# print(df["Delivery"].value_counts())


# print(df["City"].value_counts())


# print(df.describe(include="all"))


# print("Unique Restaurant IDs:", df["Restaurant ID"].nunique())


# print("Unique Restaurant Names:", df["Restaurant name"].nunique())


# print(df["Restaurant name"].value_counts())


## Changed datatype of columns, jisme value missing hai usime.
# df['Order Placed At']=pd.to_datetime(df['Order Placed At']) # This is changed the datatype of this column('Order Placed At')

df["Distance_km"]=df["Distance"].str.replace("km","")
### np.Nan is a special value. It is not a function, so don't use ().
# str.replace() is primarily for replacing strings(iska use string ko replace karne me karte hai.)

df["Distance_km"]=df["Distance_km"].replace("<1",np.nan) # isme <1 fix nahi hai ki 1 se kitna km hai, isiliye isko replace karke iske jagah pe 'nan' likh dete hai.
df["Distance_km"]=pd.to_numeric(df["Distance_km"]) ## convert str in float

# print(df["Distance_km"].dtype)


### Order Status
# print(df["Order Status"].value_counts()) # It is correct, there is no ambiguity in this Order Status.

### Order Ready Marked
# print(df["Order Ready Marked"].value_counts())

find_null_kpt=df["KPT duration (minutes)"].isnull().sum()
# print(find_null_kpt)

# print(df[df["KPT duration (minutes)"].isnull()]["Order Status"].value_counts()) # This means: 1. Find rows where KPT is missing.   2. From only those rows, count their Order Status.



### Rider wait time (minutes)
# print(df[df["Rider wait time (minutes)"].isnull()]["Order Status"].value_counts())
# print(df["Rider wait time (minutes)"].unique())
# print(df["Rider wait time (minutes)"].value_counts(dropna=False)) # dropna ka use hum karte hai taki NaN ko show kar sakte agar True kar denge to hide/ignore ho jayega NaN. value_counts() jab count karta hai tab NaN ko bhi include karta hai. Nan means (missing values).


### Rating
# print(df["Rating"].isnull().sum())
# print(df["Rating"].value_counts(dropna=False))



### Review
# print(df["Review"].isnull().sum())
# print(df["Review"].value_counts(dropna=False))



### Cancellation/Rejection
# print(df["Cancellation / Rejection reason"].isnull().sum())
# print(df["Cancellation / Rejection reason"].unique())
# print(df["Cancellation / Rejection reason"].value_counts(dropna=False))



### Restaurant compensation (Cancellation)
# print(df["Restaurant compensation (Cancellation)"].isnull().sum())
# print(df["Restaurant compensation (Cancellation)"].value_counts(dropna=False))
# print(df["Restaurant compensation (Cancellation)"].unique())



### Restaurant penalty(Rejection)
# print(df["Restaurant penalty (Rejection)"].isnull().sum())
# print(df["Restaurant penalty (Rejection)"].unique())
# print(df["Restaurant penalty (Rejection)"].value_counts(dropna=False))



### KPT duration (minutes)
# print(df["KPT duration (minutes)"].isnull().sum())
# print(df["KPT duration (minutes)"].unique())
# print(df["KPT duration (minutes)"].value_counts(dropna=False))



### Customer complaint tag
# print(df["Customer complaint tag"].isnull().sum())
# print(df["Customer complaint tag"].unique())
# print(df["Customer complaint tag"].value_counts(dropna=False).sum())



### Instructions
# print(df["Instructions"].isnull().sum())
# print(df["Instructions"].unique())
# print(df["Instructions"].value_counts(dropna=False))



# print(df.duplicated().sum())
# print(df["Total"].min())

# print(df["Bill subtotal"].min())
# print(df["Restaurant discount (Promo)"].min())
# print(df["Restaurant discount (Flat offs, Freebies & others)"].min())
# print(df["Gold discount"].min())
# print(df["Brand pack discount"].min())
# print(df["Total"].min())
# print(df["Rating"].min())
# print(df["Review"].min())
# print(df["Restaurant compensation (Cancellation)"].min())
# print(df["Restaurant penalty (Rejection)"].min())
# print(df["KPT duration (minutes)"].min())
# print(df["Rider wait time (minutes)"].min())



# categorical_cols = [
#     "Restaurant name",
#     "Subzone",
#     "City",
#     "Order Status",
#     "Delivery",
#     "Order Ready Marked",
#     "Cancellation / Rejection reason",
#     "Customer complaint tag"
# ]

# for col in categorical_cols:
#     print(f"\n------ {col} ------")
#     print(df[col].value_counts(dropna=False))


# cols = [
#     "Restaurant discount (Promo)",
#     "Restaurant discount (Flat offs, Freebies & others)",
#     "Gold discount",
#     "Brand pack discount",
#     "Total",
#     "KPT duration (minutes)",
#     "Rider wait time (minutes)",
#     "Restaurant compensation (Cancellation)",
#     "Restaurant penalty (Rejection)"
# ]
# for c in cols:
#     print(f"\n ------- {c} -------- ")
#     print(df[c].agg(['max','min']))


# cols=["Restaurant discount (Promo)",
#       "Restaurant discount (Flat offs, Freebies & others)",
#       "Gold discount",
#       "Brand pack discount"]
# for c in cols:
#     print(f"\n--------------{c}--------------")
#     print((df[c]>df["Bill subtotal"]).sum())

max_min=df["Bill subtotal"].sub(df["Total"]).agg(["max","min"])
check_bill_total= (df["Total"]>df["Bill subtotal"]).sum()


cols=df[["Bill subtotal",
      "Restaurant discount (Promo)",
      "Restaurant discount (Flat offs, Freebies & others)",
      "Gold discount",
      "Brand pack discount",
      "Total"]]
# print(cols.head(5))


# print(df["KPT duration (minutes)"].agg(["max", "min", "mean", "median"]))

# print(df["Rider wait time (minutes)"].agg(["max", "min", "mean", "median"]))

df["Order Placed At"]=pd.to_datetime(df["Order Placed At"])

# print("Shape:", df.shape)
# print("\nColumns:")
# print(df.columns.tolist())
# print("\nMissing values:")
# print(df.isnull().sum())
# print("\nDuplicate rows:", df.duplicated().sum())

df.to_csv("Food_delivery_cleaned.csv", index=False)
# print("Cleaned dataset saved successfully")


# Data Logic Validation:

check_restau_id=df.groupby("Restaurant ID")["Restaurant name"].nunique() # nunique(): unique values ki count return karta hai. groupby group karta hai hai, jaise har restaurant_ID alag alag hota hai but restaurant_Name to same rahega to check kiya ja rha hai ki ek restaurantID se 1, se jayda restaurantName to nahi hai.

# print(check_restau_id)

check_subzone= df.groupby("Subzone")["City"].nunique()
# print(check_subzone)

check_order_id=df.groupby("Order ID")["Customer ID"].nunique()
# print(check_order_id)

cross_tab_order=pd.crosstab(df["Order Status"],
                  df["Cancellation / Rejection reason"],
                  dropna=False)
# print(cross_tab_order)
#crosstab: Do catergorical columns ke combinations ki frequency/count table banana. crosstab[rows, columns].  dropna=False ka matlab ki NaN ko bhi table mein include karo.

order_rating_cross=pd.crosstab(df["Order Status"],df["Rating"].notna())
# print(order_rating_cross)


# isna()	    True
# notna()	    False
# dropna()	    NaN ko remove/drop karta hai
# dropna=False	NaN ko remove nahi karta → show/count kar sakta hai

order_review_cross=pd.crosstab(df["Order Status"],df["Review"].notna())
# print(order_review_cross)

status_cross_cancel=pd.crosstab(df["Order Status"],
                                 df["Restaurant compensation (Cancellation)"].notna())
status_cross_penalty=pd.crosstab(df["Order Status"],
                                 df["Restaurant penalty (Rejection)"].notna())
# print(status_cross_cancel)


order_ready_cross_kpt=pd.crosstab(df["Order Ready Marked"], df["KPT duration (minutes)"].notna())
# print(order_ready_cross_kpt)

discount_cols = [
    "Restaurant discount (Promo)",
    "Restaurant discount (Flat offs, Freebies & others)",
    "Gold discount",
    "Brand pack discount"
]

df["Total_Discount"] = df[discount_cols].sum(axis=1)

(df["Total_Discount"] > df["Bill subtotal"]).sum()

# print(df["Total_Discount"].agg(["max","min"]))

# print((df["Total_Discount"] > df["Bill subtotal"]).sum())

# print(
#     df[
#         [
#             "Bill subtotal",
#             "Packaging charges",
#             "Restaurant discount (Promo)",
#             "Restaurant discount (Flat offs, Freebies & others)",
#             "Gold discount",
#             "Brand pack discount",
#             "Total"
#         ]
#     ].head(10)
# )



calculated_total = (
    df["Bill subtotal"] + df["Packaging charges"] - df["Total_Discount"])

# print((calculated_total != df["Total"]).sum())

difference = calculated_total - df["Total"]
# print(difference[difference != 0].agg(["min", "max"]))
# print(difference.round(2).value_counts())

# print(df["Order Placed At"].dtype)
# print(df["Order Placed At"].isnull().sum())
# print(df["Order Placed At"].agg(["max","min"]))


### Buisness-oriented EDA
# print("Total Orders:", df["Order ID"].nunique())
# print("Delivered Orders:", (df["Order Status"] == "Delivered").sum())
# print("Total Revenue:", df["Total"].sum())
# print("Average Order Value:", df["Total"].mean())

delivered_aov = df.loc[
    df["Order Status"] == "Delivered",
    "Total"
].mean()
# print("Delivered AOV:", delivered_aov)

# loc ka basic purpose hai:
# DataFrame se specific rows aur columns ko label/condition ke basis par select karna.

# loc condition ke basis par rows select karta hai:
# df.loc[condition, "Total"]
# Meaning: "Jin rows mein condition True hai, un rows ka Total column do."

# df.loc[rows, columns]


non_delivered = (df["Order Status"] != "Delivered").sum()
# print("Non-delivered Orders:", non_delivered)
# print("Non-delivered Rate:", (non_delivered / len(df)) * 100)

# Why len(df)?
# len(df) gives the total number of rows/orders, which is: 21321

# print(df["Order Status"].value_counts())

# status_percentage=df["Order Status"].value_counts(normalize=True)*100
# print(status_percentage)

# value_counts(normalize=True):- Pandas gives the proportion of the total.

# non_delivered_status=df.loc[df["Order Status"]!="Delivered", "Order Status"].value_counts()
# print(non_delivered_status)

# non_delivered_reasons=df.loc[df["Order Status"]!="Delivered", "Cancellation / Rejection reason"].value_counts()
# print(non_delivered_reasons)

# cross_order_reason=pd.crosstab(df["Order Status"], df["Cancellation / Rejection reason"
# ])
# print(cross_order_reason)

# print(df.groupby("Restaurant name")["Total"].agg(["count", "sum", "mean"]).sort_values("sum", ascending=False))
# ascending false means highest value first, matlab output me sum me highest jo hoga voh sabse upar.

# print(pd.crosstab(df["Restaurant name"]
#                   ,df["Order Status"]))


# restaurant_status = pd.crosstab(
#     df["Restaurant name"],
#     df["Order Status"]
# )

# restaurant_status["Total Orders"] = restaurant_status.sum(axis=1)

# restaurant_status["Non-Delivered Rate"] = (
#     (restaurant_status["Total Orders"] - restaurant_status["Delivered"])
#     / restaurant_status["Total Orders"] * 100
# )

# restaurant_status[["Total Orders", "Delivered", "Non-Delivered Rate"]]
# print(restaurant_status)

# 
### Customer Analysis:
customer_summary=df.groupby("Customer ID")["Total"].agg(["count", "sum", "mean"])
customer_summary.columns=["Orders", "Total Spend", "AOV"]
# customer_summary.head()
# print(customer_summary)

# print(customer_summary["Orders"].value_counts().sort_index())

customer_summary["Last Order"]=df.groupby("Customer ID")["Order Placed At"].max()

# print(customer_summary.head())

reference_date=df["Order Placed At"].max() #iska matlab: Dataset me jo sabse latest order date hai, usko reference date bana do.

customer_summary["Recency Days"]=(reference_date - customer_summary["Last Order"]).dt.days

# Recency ka simple meaning hai: # Customer ne last time order kitne din pehle kiya tha.
# Low Recency → customer recently active tha.
# High Recency → customer kaafi time se order nahi kar raha.


# print(customer_summary.head())

customer_summary["First Order"]=df.groupby("Customer ID")["Order Placed At"].min()
customer_summary["Activity Days"]=(customer_summary["Last Order"] - customer_summary["First Order"]).dt.days

# First Order → customer ka sabse pehla order
# Last Order → customer ka sabse recent order
# Activity Days → first aur last order ke beech kitne days

# print(customer_summary.head())


# print(customer_summary.sort_values("Total Spend", ascending=False).head(10)) # Humein dekhna hai customers kitna spend kar rahe hain.

# print(customer_summary[customer_summary["Orders"]>=5].shape[0])
# sabse andar wala Orders column nikalta hai, uske baad har row par condition check hogi, true or false, jo 5 se jayda ya equal hoga voh true, ab outer [] ka kaam hai, sirf un rows ko select karo jahan condition True hai. Then, .shape[0] mean value row wise chahiye: 729, agar .shape[1] hota yani ki column wise.

### Customer_Status:-

customer_status=pd.crosstab(df["Customer ID"], df["Order Status"])
# print(customer_status.head())

customer_status["Total Orders"]=customer_status.sum(axis=1)
# print(customer_status)
# print(customer_status.head())

customer_status["Non-Delivered Orders"]=(customer_status["Total Orders"]-customer_status["Delivered"])

# print(customer_status.head())

customer_status["Non-Delivered Rate"]=(customer_status["Non-Delivered Orders"]/customer_status["Total Orders"])*100
# print(customer_status.head())

### Time/Day Analysis
df["Day"]=df["Order Placed At"].dt.day_name()
# print(df["Day"].value_counts())

# dt kya hai?
# Pandas mein jab koi column datetime type ka hota hai, tab us column se date/time ke different parts nikalne ke liye .dt accessor use karte hain.

df["Hour"]=df["Order Placed At"].dt.hour
# print(df["Day"].value_counts().sort_index(ascending=True))

df["Month"]=df["Order Placed At"].dt.month_name()
# print(df["Month"].value_counts().head())

monthly_revenue=df.groupby(df["Month"])["Total"].sum()
# print(monthly_revenue)

monthly_revenue=df.groupby(df["Month"])["Total"].mean()
# print(monthly_revenue)


### Discount & Revenue Leakage analysis: 
discount_cols = [
    "Restaurant discount (Promo)",
    "Restaurant discount (Flat offs, Freebies & others)",
    "Gold discount",
    "Brand pack discount"
]

# print(df[discount_cols].sum())

# print(df["Total_Discount"].describe()) :describe tell us together avg,median,25%,50%,75%,max.

# print((df["Total_Discount"]>0).sum())

Discount_Percentage=(((df["Total_Discount"]>0).sum())/len(df))*100
# print(Discount_Percentage)

df["Discount_Percentage"]=(df["Total_Discount"]/df["Bill subtotal"])*100
# print(df["Discount_Percentage"].describe())

# for col in discount_cols:
#     print(col, ":", (df[col] > 0).sum())


### Final Buisness EDA section: Delivery & Operations

# print(df["KPT duration (minutes)"].describe())
# print(df["Rider wait time (minutes)"].describe())
# print(df["Distance_km"].describe())
# print(df["Order Ready Marked"].value_counts())




# df.to_csv(
#     "food_delivery_mysql.csv",
#     index=False,
#     na_rep="\\N"
# )


# print(os.path.getsize("food_delivery_mysql.csv"), "bytes")
# print(os.path.exists("food_delivery_mysql.csv"))
# print(os.path.abspath("food_delivery_mysql.csv"))
# print(df["Rating"].isna().sum())

# na_rep means “NA representation” — basically, what should pandas write into the CSV when a value is missing (NaN/None)?
# Why \N?
# MySQL's LOAD DATA understands \N as SQL NULL.

### Connect mysql and python 

# print("Connector working")

import mysql.connector as myconn
conn = myconn.connect(
    host="127.0.0.1",
    user="root",
    password="1234",
    database="food_delivery_analysis" # It is optional.
)

# # print("MySQL connected successfully")
# file_path = r"C:\\Users\\alok3\\OneDrive\\Desktop\\Programming  Language\\main_project_2_swiggy_analysis\\food_delivery_mysql_clean.csv"
# df_mysql = pd.read_csv(
#     file_path,
#     dtype=str,
#     keep_default_na=False
# )
# # print("CSV loaded successfully")
# # print("Shape:", df_mysql.shape)


# columns = [
#     "restaurant_id", "restaurant_name", "subzone", "city", "order_id",
#     "order_placed_at", "order_status", "delivery", "distance",
#     "items_in_order", "instructions", "discount_construct",
#     "bill_subtotal", "packaging_charges", "restaurant_discount_promo",
#     "restaurant_discount_other", "gold_discount", "brand_pack_discount",
#     "total", "rating", "review", "cancellation_rejection_reason",
#     "restaurant_compensation_cancellation", "restaurant_penalty_rejection",
#     "kpt_duration_minutes", "rider_wait_time_minutes", "order_ready_marked",
#     "customer_complaint_tag", "customer_id", "distance_km",
#     "total_discount", "day", "hour", "month", "discount_percentage"
# ]

# placeholders = ", ".join(["%s"] * 35)

# sql = f"""
# INSERT INTO food_orders_raw
# ({", ".join(columns)})
# VALUES ({placeholders})
# """

# rows = list(df_mysql.itertuples(index=False, name=None))

# db_cursor.executemany(sql, rows)
# conn.commit()

# print(f"Successfully inserted {len(rows)} rows!")
