package bbs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import bbs.BbsDao;
import common.JdbcUtil;

public class BbsDao {
	
	private JdbcUtil ju;
	//UserDao�� ������ �ɶ�, ju�� JdbcUtil.getInstance()�� �Ѵ�.
	public BbsDao() {
		ju = JdbcUtil.getInstance();
	}
	//getDate() : ���� �ð�
	public String getDate() {
		Connection con = null;
		ResultSet rs = null;
//		String query = "select systimestamp from dual";
//		String query = "select to_char(sysdate, 'YYYY-MM-DD HH:MI:SS') from dual";
		String query = "select SYSDATE FROM BBS";
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//query���� ���� �غ�ܰ�� �غ��Ŵ.
			PreparedStatement pstmt = con.prepareStatement(query);
			//query���� ����������, ������ ����� �����´�.
			rs = pstmt.executeQuery();
			if(rs.next()) {
				//���� �ð� ���� ��ȯ��.
				return rs.getString(1);
			}
		}catch(Exception e) {
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
			if(rs !=null) {
				try {
					rs.close(); //Ǯ�� ��ȯ
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
		}
		return ""; //�����ͺ��̽� ����
	}
	
	
	//getNext() : �� �������� �ۼ��� ���� ��ȣ 	
	public int getNext() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//���� �������� ���� ���� �������� ������
		String query = "select bbsID from BBS order by bbsID desc";
		try {
			con = ju.getConnection();
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			//����� �ִ� ���
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			
			return 1; //ù��° �Խù��� ���
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
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
			if(rs !=null) {
				try {
					rs.close(); //Ǯ�� ��ȯ
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
		
		return -1;//�����ͺ��̽� ����
	}
	
	//����(C)
	public int write(String bbsTitle, String userID, String bbsContent) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//������ ��, ����� ������
		//������ �����Ͱ� �ƴ�, Bbs�κ��� ���޹��� �����Ͱ� ���� ������ ���ε� ����ó��
		String query = "insert into \"BBS\" (\"BBSID\", \"BBSTITLE\",\"USERID\",\"REGDATE\",\"BBSCONTENT\", \"BBSAVAILABLE\") values (?,?,?,?,?,?)";
//		String query = "INSERT INTO BBS VALUES(?,?,?,?,?,?)";	
		//������ ������ ���н� ���� Ȯ���ϱ� ���� �� ����(������ ���������� �۵������� ret = 1;)
		//int ret = -1; 
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//con���κ��� PreparedStatement(query)�� pstmt������ ������.
			pstmt = con.prepareStatement(query);
			//ù��° �Ķ���Ϳ��� ���� getBbsTitle�� ������.
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
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
		
		return -1; //�����ͺ��̽� ����
	}
	
	public ArrayList<Bbs> getList(int pageNumber){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//���̴� �Խñ��� 10���� ������ ��, bbsAvailable�� ���� 1�� bbsID�� ������������(������ 10�� ������) ������.
		String query = "SELECT * FROM (SELECT * FROM BBS WHERE bbsID < ? and BBSAVAILABLE = 1 order by bbsID desc) WHERE ROWNUM <=10";
		//BbsŬ�������� ������ �ν��Ͻ��� ������ �� �ִ� ls(list)�� �ϳ� ����, new ArrayList<>�� Bbs�� �����.
		ArrayList<Bbs> ls = new ArrayList<Bbs>();
		
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//con���κ��� PreparedStatement(query)�� pstmt������ ������.
			pstmt = con.prepareStatement(query);
			//���� ����ǥ�� �� ����
				//getNext() : �� �������� �� ���� ��ȣ
				// 			- ex) ���࿡ ���� �Խñ��� 5����, getNext���� 6�̴�.
				//pageNumber : �� ������ ��
			//���� : getNext�� ���� 6�� ����, pageNumber ���� -1�� �ϰԵǸ�, 5�� �ȴ�.
			//		�ᱹ 5���� ���� �ִٸ�, pageNumber�� ���� Limit�� 10�� �س��ұ⶧���� 10���� �����Ƿ�
			//		���������� 1�� �ȴ�. ��, (6 - (1 - 1) * 10)�� ���̴�. 
			pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
			rs = pstmt.executeQuery();
			System.out.println("getList rs�� Ȯ�� : " + rs);
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setRegDate(rs.getTimestamp(4));
//				new Date(rs.getDate(4).getTime());
//				bbs.setRegdate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				ls.add(bbs);
			}
				
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
			if(rs !=null) {
				try {
					rs.close(); //Ǯ�� ��ȯ
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
		}
		//����� ��ȯ
		return ls;
		
	}

	//����¡ó�� �Լ�
	//	- Ư���� �������� �����ϴ����� ���� nextPage�Լ��� ������ִ� ��.		
		//Ex. �Խñ� 10�� �� page 1��
		//    �Խñ� 11�� �� page 2��
		//    �Խñ� 20�� �� page 2��
		//    �Խñ� 22�� �� page 3��
	public boolean nextPage(int pageNumber) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
//		���̴� �Խñ��� 10���� ������ ��, bbsAvailable�� ���� 1�� bbsID�� ������������(������ 10�� ������) ������.
//		String query = "select * from (select * from bbs where bbsid <? and bbsAvailable=1 order by bbsID desc) where rownum<=10";
		String query = "select * from bbs where bbsID < ? and bbsAvailable = 1";
//		BbsŬ�������� ������ �ν��Ͻ��� ������ �� �ִ� ls(list)�� �ϳ� ����, new ArrayList<>�� Bbs�� �����.
//		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//con���κ��� PreparedStatement(query)�� pstmt������ ������.
			pstmt = con.prepareStatement(query);
			//���� ����ǥ�� �� ����
				//getNext() : �� �������� �� ���� ��ȣ
				// 			- ex) ���࿡ ���� �Խñ��� 5����, getNext���� 6�̴�.
				//pageNumber : �� ������ ��
			//���� : getNext�� ���� 6�� ����, pageNumber ���� -1�� �ϰԵǸ�, 5�� �ȴ�.
			//		�ᱹ 5���� ���� �ִٸ�, pageNumber�� ���� Limit�� 10�� �س��ұ⶧���� 10���� �����Ƿ�
			//		���������� 1�� �ȴ�. ��, (6 - (1 - 1) * 10)�� ���̴�. 
			pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
			rs = pstmt.executeQuery();
			// ���࿡ ����� 1���� �����Ѵٸ�, 
			if(rs.next()) {
				//������������ �Ѿ �� ����.
				return true; 
			}
				
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
		//������������ �Ѿ �� ����.(�Խñ��� ���� �� �̻� �������� �������� ����)
		return false; 
	}
	//�ϳ��� �� ������ �ҷ���.
	//	- Ư���� ���̵�(bbsID,���� ���̵�(��ȣ))�� �ش��ϴ� �Խñ��� �ҷ���.
	public Bbs getBbs(int bbsID) {
		

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//���ε� ������ Ư���� ����(���� ���̵�(��ȣ))�� ��� ��� ����(�Խñ��� �ҷ���)�� �����Ҽ� �ְ� ��.
		String query = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//con���κ��� PreparedStatement(query)�� pstmt������ ������.
			pstmt = con.prepareStatement(query);
			//���� ����ǥ�� �� ����
			//	- bbsID�� 2(�Խñ� 2��)�̵� 7(�Խñ� 7��)�̵� ���� �־� �Խñ��� �״�� ������. 
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			// ���࿡ ����� �����Ѵٸ�,
			if(rs.next()) {
					//�Խñ��� �ҷ���
					Bbs bbs = new Bbs();
					bbs.setBbsID(rs.getInt(1));
					bbs.setBbsTitle(rs.getString(2));
					bbs.setUserID(rs.getString(3));
					bbs.setRegDate(rs.getTimestamp(4));
//					new Date(rs.getDate(4).getTime());
//					bbs.setRegdate(rs.getString(4));
					bbs.setBbsContent(rs.getString(5));
					bbs.setBbsAvailable(rs.getInt(6));
					//�Խñ� ��Ҹ� bbs�� ���, �Խñ��� ��ȯ��.
					return bbs;
			}
				
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
		//�Խñ��� �������� ����.
		return null; 
		
	}
	//�Խñ� ����
	//  - Ư���� ��ȣ�� �Ű������� ���� ����� �������� ������.
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//������ ��, ����� ������
		//Ư���� ���̵�(bbsID)�� �ش��ϴ� ����(bbsTitle)�� ����(bbsContent)�� �ٲ��ش�.
		String query = "UPDATE BBS SET bbsTitle = ?, bbsContent= ? WHERE bbsID = ?";
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//con���κ��� PreparedStatement(query)�� pstmt������ ������.
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
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
		//�����ϸ� 0�̻��� ���� ��ȯ
		return -1; //�����ͺ��̽� ����
		
	}
	public int delete(int bbsID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//������ ��, ����� ������
		//���� �����ϴ��� ���� ������ �������� �� �ֵ��� bbsAvailable���� 0���� �ٲ۴�.
		String query = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			//con���� jdbcutil�� ���� getConnection ��.
			con = ju.getConnection();
			//con���κ��� PreparedStatement(query)�� pstmt������ ������.
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, bbsID);
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
		//�����ϸ� 0�̻��� ���� ��ȯ
		return -1; //�����ͺ��̽� ����
		
	}
}

