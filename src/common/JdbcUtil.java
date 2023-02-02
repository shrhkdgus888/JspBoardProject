package common;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class JdbcUtil {
	private static JdbcUtil instance = new JdbcUtil();
	//context.xml에서 생성된 DataSource 객체를 사용하기 위한 객체 선언
	private static DataSource ds;
	
	static {
		try {
			Class.forName("oracle.jdbc.OracleDriver");
			System.out.println("드라이버로딩성공!");
			InitialContext ctx = new InitialContext();
			//Context정보를 JNDI경로에서 jdbc/TestDB의 이름을 가진 정보를 찾아와서 ds(DataSource)에 참조하도록 함
			ds = (DataSource)ctx.lookup("java:comp/env/jdbc/TestDB");
			System.out.println("Connection Pool 생성");
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}catch(NamingException e) {
			e.printStackTrace();
			}
		}


	private JdbcUtil() {}
	public static JdbcUtil getInstance() {
		return instance;
	}
	public Connection getConnection() throws SQLException{
		//ds를 통해 Con이 필요할때 반환함.
		return ds.getConnection();//Pool의 커넥션을 반환함.
	}
}
