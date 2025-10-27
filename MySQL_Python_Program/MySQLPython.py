import pymysql
import csv
from dotenv import load_dotenv
import os

# .env 파일 로드
load_dotenv()

# 환경 변수 가져오기
DB_HOST = os.getenv('DB_HOST')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_NAME = os.getenv('DB_NAME')

# Connection
con = pymysql.connect(
    host=DB_HOST,
    user=DB_USER,
    password=DB_PASSWORD,
    db=DB_NAME,
    charset='utf8'
)

cursorObject = con.cursor()
print("connect successful!!")

sqlQuery = "select ID, name, salary from instructor"
cursorObject.execute(sqlQuery)
rows = cursorObject.fetchall()

for row in rows:
    print(row[0], ",", row[1], ",", row[2])

sqlQuery = "select ID, name, salary from instructor where salary>70000"
cursorObject.execute(sqlQuery)
rows = cursorObject.fetchall()

con.commit()
con.close()
