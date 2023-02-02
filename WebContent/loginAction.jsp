<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDao" %>
<!-- JavaScript 사용 -->
<%@ page import="java.io.PrintWriter" %>
<!--  요청한 정보를 한글이 들어올수 있게끔 utf-8로 셋팅 -->
<% request.setCharacterEncoding("utf-8"); %>
<!-- Bean객체 생성 / User user = new User();와 같은 뜻 -->
<jsp:useBean id="user" class="user.User" scope="page" />
<!-- useBean 액션태그로 생성한 자바빈 객체에 대해서 프로퍼티(필드)에 값을 설정 -->
<!-- property 속성에 * 를 사용하면 프로퍼티와 동일한 이름의 파라미터를 이용하여 setter 메서드를 생성한 모든 프로퍼티(필드)에 대해 값을 설정 -->
<%-- <jsp:setProperty="userID" name="user"/>
<jsp:setProperty="userPassword" name="user"/>
<jsp:setProperty="userName" name="user"/>
위의 동일한 내용 --%>
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
	//로그인이 된 유저는 로그인 페이지에 들어갈 수 없도록 함.
		String userID = null;
		//현재 세션이 존재한다면 그 값을 그대로 받아서 이용할 수 있도록 함.
			//userID에 해당 세션 값((String) session.getAttribute("userID");)를 넣어줌
			//즉, userID라는 변수가 자신에게 할당된 세션을 담을수 있도록 함.
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			//또 다시 로그인 할 수 없도록, 메인페이지로 이동하도록 함.
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		UserDao userDao = new UserDao();
		//login.jsp에서 입력한 값을 가져와 그 값을 UserDao클래스 내부의 로그인 함수에 넣어서 실행해준다. 
		int result = userDao.login(user.getUserID(), user.getUserPassword());
		//로그인 성공
		if (result == 1){
			//세션에 값 저장하기 , session.setAttribute(String name(키 값), Object value(저장할 값));
			session.setAttribute("userID",user.getUserID());
			PrintWriter script = response.getWriter();
			script.println("<script>");
			//로그인 성공시 main.jsp로 이동
			script.println("alert('로그인 성공!')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		//로그인 실패(비밀번호가 틀렸을 때)
		else if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			//로그인 실패시 1. 문구 띄우기
			script.println("alert('비밀번호가 틀립니다.')");
			//로그인 실패시 2. 이전페이지로 돌려보내기
			script.println("history.back()");
			script.println("</script>");
		}
		//아이디가 존재하지 않을 때
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			//로그인 실패시 1. 문구 띄우기
			script.println("alert('아이디가 존재하지 않습니다.')");
			//로그인 실패시 2. 이전페이지로 돌려보내기
			script.println("history.back()");
			script.println("</script>");
		}
		//db오류발생
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			//로그인 실패시 1. 문구 띄우기
			script.println("alert('데이터베이스 오류가 발생되었습니다.')");
			//로그인 실패시 2. 이전페이지로 돌려보내기
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>