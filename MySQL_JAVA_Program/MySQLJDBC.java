import java.io.FileInputStream;
import java.util.Properties;
import java.sql.*;

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
			ResultSet rs = stmt.executeQuery("SELECT * FROM instructor");

			while (rs.next()) {
				System.out.println(
						rs.getString("dept_name") + " | " +
								rs.getString(2) + " | " +
								rs.getString(3) + " | " +
								rs.getDouble("salary"));
			}

			stmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
