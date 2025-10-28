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
DB_NAME = os.getenv('DB_NAME_HW')

# Connection - 연결
con = pymysql.connect(
    host=DB_HOST,
    user=DB_USER,
    password=DB_PASSWORD,
    db=DB_NAME,
    charset='utf8'
)

cursorObject = con.cursor() # sql을 DBMS에 보내고 결과를 받아오는 역할
print("connect successful!!")

sqlQuery = "select * from BikeRental where cnt > 5000"
cursorObject.execute(sqlQuery) # 객체를 통해서 SQL을 보내고 결과를 받아옴
rows = cursorObject.fetchall() # 받아온 결과를 추출해서 rows에 저장하기

print("\n\n문제1")
for row in rows: # 하나하나 튜플에 접근하여 각각의 속성값을 가져옴
    for v in row:
        print(v, end=' ')
    print()

print("\n\n문제2 - bike_over_5000.csv에 결과 저장하기")

with open("bike_over_5000.csv", "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file) # 파일에 CSV 데이터를 쓰는 객체 생성하기
    writer.writerows(rows) # 생성한 객체에 메서드 호출해서 쓰기

# disConnection - 연결 해제
con.commit()
con.close()