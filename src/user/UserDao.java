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
	//�����Լ��� �־��� ������� Dao class�� ���� ���������� ������ ��

public class UserDao {

	private JdbcUtil ju;
	//UserDao�� ������ �ɶ�, ju�� JdbcUtil.getInstance()�� �Ѵ�.
	public UserDao() {
		ju = JdbcUtil.getInstance();
	}
	
	public int login(String userID, String userPassword) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//�������� ������ ���� �ʿ��� Ŭ�������� ����
		String query = "SELECT \"userPassword\" FROM \"USER\" WHERE \"userID\" = ?";
		
		try {
			conn = ju.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword))
					return 1; // �α��� ����
					
				else
					return 0; // ��й�ȣ ����ġ
			}
			return -1; // ���̵� ����
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
		return -2; //�����ͺ��̽� ���� 	

	}
	public int join(User user) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//ȸ�������� ��, ����� ������
		//������ �����Ͱ� �ƴ�, User�ηκ��� ���޹��� �����Ͱ� ���� ������ ���ε� ����ó��
		String qurey = "insert into \"USER\" (\"userID\", \"userPassword\",\"userName\",\"userGender\",\"userEmail\") values (?, ?, ?, ?, ?)";
		//������ ������ ���н� ���� Ȯ���ϱ� ���� �� ����(������ ���������� �۵������� ret = 1;)
		int ret = -1; 
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//con���κ��� PreparedStatement(query)�� pstmt������ ������.
			pstmt = con.prepareStatement(qurey);
			//�Ķ���Ϳ��� user���� getUserID�� ������.
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
					con.close(); //Ǯ�� ��ȯ
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
			if(pstmt !=null) {
				try {
					pstmt.close(); //Ǯ�� ��ȯ
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
		}
		//�����ͺ��̽� ����
		return ret;
	}
	
}
