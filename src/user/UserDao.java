package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.JdbcUtil;
import user.UserDao;

//User Database Access object
	//메인함수에 있었던 개념들을 Dao class에 따로 범용적으로 정의한 것

public class UserDao {

	private JdbcUtil ju;
	//UserDao가 생성이 될때, ju에 JdbcUtil.getInstance()를 한다.
	public UserDao() {
		ju = JdbcUtil.getInstance();
	}
	
	public int login(String userID, String userPassword) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//쿼리들을 날리기 위해 필요한 클래스들을 정리
		String query = "SELECT \"userPassword\" FROM \"USER\" WHERE \"userID\" = ?";
		
		try {
			conn = ju.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword))
					return 1; // 로그인 성공
					
				else
					return 0; // 비밀번호 불일치
			}
			return -1; // 아이디가 없음
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		return -2; //데이터베이스 오류 	

	}
	public int join(User user) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//회원가입할 때, 사용할 쿼리문
		//정해진 데이터가 아닌, User로로부터 전달받은 데이터가 들어가기 때문에 바인딩 변수처리
		String qurey = "insert into \"USER\" (\"userID\", \"userPassword\",\"userName\",\"userGender\",\"userEmail\") values (?, ?, ?, ?, ?)";
		//쿼리문 보내기 실패시 값을 확인하기 위해 값 설정(쿼리가 정상적으로 작동했으면 ret = 1;)
		int ret = -1; 
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//con으로부터 PreparedStatement(query)를 pstmt변수에 참조함.
			pstmt = con.prepareStatement(qurey);
			//파라미터에는 user값중 getUserID을 셋팅함.
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally {
			if(con !=null) {
				try {
					con.close(); //풀에 반환
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
			if(pstmt !=null) {
				try {
					pstmt.close(); //풀에 반환
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
		}
		//데이터베이스 오류
		return ret;
	}
	
}
