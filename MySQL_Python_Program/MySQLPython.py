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

sqlQuery = "select ID, name, salary from instructor"
cursorObject.execute(sqlQuery) # 객체를 통해서 SQL을 보내고 결과를 받아옴
rows = cursorObject.fetchall() # 받아온 결과를 추출해서 rows에 저장하기

print("\n\n예제1")
for row in rows: # 하나하나 튜플에 접근하여 각각의 속성값을 가져옴
    print(row[0], ",", row[1], ",", row[2])


# 실습 1
sqlQuery = ("select ID, name, salary "
            "from instructor "
            "where dept_name = 'Comp. Sci.' and salary>70000")
cursorObject.execute(sqlQuery)
rows = cursorObject.fetchall()

print("\n\n실습1")
for row in rows:
    print(row[0], ",", row[1], ",", row[2])
for row in rows:
    print(row[0], ",", row[1], ",", row[2])

# 실습 2
sqlQuery = ("select name, course_id "
            "from instructor, teaches "
            "where instructor.ID = teaches.ID and instructor.dept_name = 'Biology'")
cursorObject.execute(sqlQuery)
rows = cursorObject.fetchall()

print("\n\n실습2")
for row in rows:
    print(row[0], ",", row[1])

# 실습 3
print("\n\n실습3 - salary 1.05배 업데이트 하기")
sqlQuery = ("update instructor "
            "set salary = salary * 1.05;")
cursorObject.execute(sqlQuery)
rows = cursorObject.fetchall()

# disConnection - 연결 해제
con.commit()
con.close()