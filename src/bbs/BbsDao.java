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
	//UserDao가 생성이 될때, ju에 JdbcUtil.getInstance()를 한다.
	public BbsDao() {
		ju = JdbcUtil.getInstance();
	}
	//getDate() : 현재 시간
	public String getDate() {
		Connection con = null;
		ResultSet rs = null;
//		String query = "select systimestamp from dual";
//		String query = "select to_char(sysdate, 'YYYY-MM-DD HH:MI:SS') from dual";
		String query = "select SYSDATE FROM BBS";
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//query문을 실행 준비단계로 준비시킴.
			PreparedStatement pstmt = con.prepareStatement(query);
			//query문을 실행했을때, 나오는 결과를 가져온다.
			rs = pstmt.executeQuery();
			if(rs.next()) {
				//현재 시간 값을 반환함.
				return rs.getString(1);
			}
		}catch(Exception e) {
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
			if(rs !=null) {
				try {
					rs.close(); //풀에 반환
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
		}
		return ""; //데이터베이스 오류
	}
	
	
	//getNext() : 그 다음으로 작성될 글의 번호 	
	public int getNext() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//가장 마지막에 쓰인 글을 가져오는 쿼리문
		String query = "select bbsID from BBS order by bbsID desc";
		try {
			con = ju.getConnection();
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			//결과가 있는 경우
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			
			return 1; //첫번째 게시물인 경우
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
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
			if(rs !=null) {
				try {
					rs.close(); //풀에 반환
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
		
		return -1;//데이터베이스 오류
	}
	
	//삽입(C)
	public int write(String bbsTitle, String userID, String bbsContent) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//삽입할 때, 사용할 쿼리문
		//정해진 데이터가 아닌, Bbs로부터 전달받은 데이터가 들어가기 때문에 바인딩 변수처리
		String query = "insert into \"BBS\" (\"BBSID\", \"BBSTITLE\",\"USERID\",\"REGDATE\",\"BBSCONTENT\", \"BBSAVAILABLE\") values (?,?,?,?,?,?)";
//		String query = "INSERT INTO BBS VALUES(?,?,?,?,?,?)";	
		//쿼리문 보내기 실패시 값을 확인하기 위해 값 설정(쿼리가 정상적으로 작동했으면 ret = 1;)
		//int ret = -1; 
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//con으로부터 PreparedStatement(query)를 pstmt변수에 참조함.
			pstmt = con.prepareStatement(query);
			//첫번째 파라미터에는 값중 getBbsTitle을 셋팅함.
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
		
		return -1; //데이터베이스 오류
	}
	
	public ArrayList<Bbs> getList(int pageNumber){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//보이는 게시글을 10개로 제한한 뒤, bbsAvailable의 값이 1인 bbsID을 내림차순으로(위에서 10개 까지만) 정렬함.
		String query = "SELECT * FROM (SELECT * FROM BBS WHERE bbsID < ? and BBSAVAILABLE = 1 order by bbsID desc) WHERE ROWNUM <=10";
		//Bbs클래스에서 나오는 인스턴스를 보관할 수 있는 ls(list)를 하나 만들어서, new ArrayList<>에 Bbs를 담아줌.
		ArrayList<Bbs> ls = new ArrayList<Bbs>();
		
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//con으로부터 PreparedStatement(query)를 pstmt변수에 참조함.
			pstmt = con.prepareStatement(query);
			//위의 물음표에 들어갈 내용
				//getNext() : 그 다음으로 들어갈 글의 번호
				// 			- ex) 만약에 현재 게시글이 5개면, getNext값은 6이다.
				//pageNumber : 총 페이지 값
			//설명 : getNext는 숫자 6을 갖고, pageNumber 뒤의 -1을 하게되면, 5가 된다.
			//		결국 5개의 글이 있다면, pageNumber는 위에 Limit를 10로 해놓았기때문에 10보다 작으므로
			//		총페이지는 1이 된다. 즉, (6 - (1 - 1) * 10)의 식이다. 
			pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
			rs = pstmt.executeQuery();
			System.out.println("getList rs값 확인 : " + rs);
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
			if(rs !=null) {
				try {
					rs.close(); //풀에 반환
					}
						catch(SQLException e) {
							e.printStackTrace();
						}
			}
		}
		//결과값 반환
		return ls;
		
	}

	//페이징처리 함수
	//	- 특정한 페이지가 존재하는지에 대해 nextPage함수로 물어봐주는 것.		
		//Ex. 게시글 10개 → page 1개
		//    게시글 11개 → page 2개
		//    게시글 20개 → page 2개
		//    게시글 22개 → page 3개
	public boolean nextPage(int pageNumber) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
//		보이는 게시글을 10개로 제한한 뒤, bbsAvailable의 값이 1인 bbsID을 내림차순으로(위에서 10개 까지만) 정렬함.
//		String query = "select * from (select * from bbs where bbsid <? and bbsAvailable=1 order by bbsID desc) where rownum<=10";
		String query = "select * from bbs where bbsID < ? and bbsAvailable = 1";
//		Bbs클래스에서 나오는 인스턴스를 보관할 수 있는 ls(list)를 하나 만들어서, new ArrayList<>에 Bbs를 담아줌.
//		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//con으로부터 PreparedStatement(query)를 pstmt변수에 참조함.
			pstmt = con.prepareStatement(query);
			//위의 물음표에 들어갈 내용
				//getNext() : 그 다음으로 들어갈 글의 번호
				// 			- ex) 만약에 현재 게시글이 5개면, getNext값은 6이다.
				//pageNumber : 총 페이지 값
			//설명 : getNext는 숫자 6을 갖고, pageNumber 뒤의 -1을 하게되면, 5가 된다.
			//		결국 5개의 글이 있다면, pageNumber는 위에 Limit를 10로 해놓았기때문에 10보다 작으므로
			//		총페이지는 1이 된다. 즉, (6 - (1 - 1) * 10)의 식이다. 
			pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
			rs = pstmt.executeQuery();
			// 만약에 결과가 1개라도 존재한다면, 
			if(rs.next()) {
				//다음페이지로 넘어갈 수 있음.
				return true; 
			}
				
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
		//다음페이지로 넘어갈 수 없음.(게시글이 없어 더 이상 페이지가 존재하지 않음)
		return false; 
	}
	//하나의 글 내용을 불러옴.
	//	- 특정한 아이디(bbsID,글의 아이디(번호))에 해당하는 게시글을 불러옴.
	public Bbs getBbs(int bbsID) {
		

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//바인딩 변수가 특정한 숫자(글의 아이디(번호))인 경우 어떠한 행위(게시글을 불러옴)를 시행할수 있게 함.
		String query = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//con으로부터 PreparedStatement(query)를 pstmt변수에 참조함.
			pstmt = con.prepareStatement(query);
			//위의 물음표에 들어갈 내용
			//	- bbsID에 2(게시글 2번)이든 7(게시글 7번)이든 값을 넣어 게시글을 그대로 가져옴. 
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			// 만약에 결과가 존재한다면,
			if(rs.next()) {
					//게시글을 불러옴
					Bbs bbs = new Bbs();
					bbs.setBbsID(rs.getInt(1));
					bbs.setBbsTitle(rs.getString(2));
					bbs.setUserID(rs.getString(3));
					bbs.setRegDate(rs.getTimestamp(4));
//					new Date(rs.getDate(4).getTime());
//					bbs.setRegdate(rs.getString(4));
					bbs.setBbsContent(rs.getString(5));
					bbs.setBbsAvailable(rs.getInt(6));
					//게시글 요소를 bbs에 담아, 게시글을 반환함.
					return bbs;
			}
				
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
		//게시글이 존재하지 않음.
		return null; 
		
	}
	//게시글 수정
	//  - 특정한 번호의 매개변수로 들어온 제목과 내용으로 수정함.
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//수정할 때, 사용할 쿼리문
		//특정한 아이디(bbsID)에 해당하는 제목(bbsTitle)과 내용(bbsContent)을 바꿔준다.
		String query = "UPDATE BBS SET bbsTitle = ?, bbsContent= ? WHERE bbsID = ?";
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//con으로부터 PreparedStatement(query)를 pstmt변수에 참조함.
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
		//성공하면 0이상의 값을 반환
		return -1; //데이터베이스 오류
		
	}
	public int delete(int bbsID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		//수정할 때, 사용할 쿼리문
		//글을 삭제하더라도 글의 정보가 남아있을 수 있도록 bbsAvailable값만 0으로 바꾼다.
		String query = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			//con에는 jdbcutil로 부터 getConnection 함.
			con = ju.getConnection();
			//con으로부터 PreparedStatement(query)를 pstmt변수에 참조함.
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, bbsID);
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
		//성공하면 0이상의 값을 반환
		return -1; //데이터베이스 오류
		
	}
}

