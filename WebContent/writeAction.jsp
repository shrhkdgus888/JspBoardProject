<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDao" %>
<!-- JavaScript 사용 -->
<%@ page import="java.io.PrintWriter" %>
<!--  요청한 정보를 한글이 들어올수 있게끔 utf-8로 셋팅 -->
<% request.setCharacterEncoding("utf-8"); %>
<!-- Bean객체 생성 / Bbs bbs = new Bbs();와 같은 뜻 -->
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<!-- useBean 액션태그로 생성한 자바빈 객체에 대해서 프로퍼티(필드)에 값을 설정 -->
<!-- property 속성에 * 를 사용하면 프로퍼티와 동일한 이름의 파라미터를 이용하여 setter 메서드를 생성한 모든 프로퍼티(필드)에 대해 값을 설정 -->
<%-- <jsp:setProperty="bbsTitle" name="bbs"/>
<jsp:setProperty="bbsContent" name="bbs"/>
위의 동일한 내용 --%>
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		//로그인이 된 유저는 회원가입 페이지에 들어갈 수 없도록 함.
		String userID = null;
		//현재 세션이 존재한다면 그 값을 그대로 받아서 이용할 수 있도록 함.
			//userID에 해당 세션 값((String) session.getAttribute("userID");)를 넣어줌
			//즉, userID라는 변수가 자신에게 할당된 세션을 담을수 있도록 함.
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			//로그인이 되어있지 않아, 로그인페이지로 이동함.
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		//로그인이 되어있는 상태
		} else{
			//게시판에 빈칸있을 때
			if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
				//게시판에 빈칸없을 때
			} else {
				BbsDao bbsDao = new BbsDao();
				int result = bbsDao.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
				//데이터베이스 오류
				if (result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패하였습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				//글쓰기 성공
				else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					//글쓰기 성공시 문구 띄우기
					script.println("alert('작성이 완료되었습니다.')");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
			
		}

	%>
</body>
</html>