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
<jsp:setProperty name="user" property="userName"/>
<jsp:setProperty name="user" property="userGender"/>
<jsp:setProperty name="user" property="userEmail"/>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		//세션종료
		session.invalidate();
	%>
	<script>
		location.href = 'main.jsp';
	</script>
</body>
</html>