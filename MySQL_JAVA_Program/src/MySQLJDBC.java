import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

public class MySQLJDBC {

	public static void main(String[] args) {

		try {
			// db.properties 불러오기
			Properties prop = new Properties();
			prop.load(new FileInputStream("mydb.properties"));
			String url = prop.getProperty("url");
			String user = prop.getProperty("user");
			String password = prop.getProperty("password");

			// JDBC 드라이버 등록
			Class.forName("com.mysql.cj.jdbc.Driver");

			// DB 연결
			System.out.println("Connecting to database...");
			Connection conn = DriverManager.getConnection(url, user, password);

			Statement stmt = conn.createStatement();

			// 예제1
			ResultSet rs = stmt.executeQuery("SELECT * FROM instructor"); // query 일 때만 executeQuery() 사용 / 결과를 rs에 넣어줌
			// executeUpdate() -> update, insert, delete, create table, etc. 에 사용

			System.out.println("\n\n예제1");
			while (rs.next()) {
				System.out.println(
						rs.getString("dept_name") + " | " +
								rs.getString(2) + " | " +
								rs.getString(3) + " | " +
								rs.getDouble("salary"));
				// DB에 지정된 타입에 맞게 getXxx를 사용해서 가져오기
			}

			// 실습1
			rs = stmt.executeQuery("select name from instructor where dept_name = 'Comp. Sci.' and salary > 70000");

			System.out.println("\n\n실습1");
			while (rs.next()) {
				System.out.println(rs.getString("name"));
				// DB에 지정된 타입에 맞게 getXxx를 사용해서 가져오기
			}

			// 실습2
			rs = stmt.executeQuery("select name, course_id\n" +
					"from instructor, teaches\n" +
					"where instructor.ID = teaches.ID and\n" +
					" instructor.dept_name = 'Biology'");

			System.out.println("\n\n실습2");
			while (rs.next()) {
				System.out.println(rs.getString("name") + " | " + rs.getString("course_id"));
				// DB에 지정된 타입에 맞게 getXxx를 사용해서 가져오기
			}

			// 실습3
			System.out.println("\n\n실습3 - salary 1.05배 하기");
			stmt.executeUpdate("update instructor set salary = salary * 1.05;");

			stmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}