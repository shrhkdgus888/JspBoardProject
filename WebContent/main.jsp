<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- javascript 라이브러리 import -->
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="css/common.css">
<link rel="stylesheet" href="css/slider.css">
<script
     src="https://code.jquery.com/jquery-3.6.0.min.js"
     integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
     crossorigin="anonymous"
></script>

<title>JSP 게시판 웹 사이트</title>
</head>
<body>

	<%
		//로그인이 된 사람의 로그인 정보를 담을 수 있도록 해줌.
		String userID = null;
		//현재 세션이 존재한다면 그 값을 그대로 받아서 이용할 수 있도록 함.
		if (session.getAttribute("userID") !=null){
			userID = (String) session.getAttribute("userID");
		}
	
	%>

	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>	
				<span class="icon-bar"></span>	
				<span class="icon-bar"></span>	
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<!-- 현재 접속한 페이지가 main 페이지라는 것을 보여줌 -->
				<!-- <li class="active"><a href="main.jsp">메인</a></li> -->
				<li><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<!-- 접속하기 같은 경우, 로그인이 되어 있지 않은 경우만 나올 수 있도록 함. -->
			<%
				if(userID == null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<!-- active: 현재 선택됨 -->
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>	
				</li>		
			</ul>
			<%
			/* 로그인이 되어있는 경우 보이는 화면 */
				} else {
			%>
						<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>	
				</li>		
			</ul>
			<% 		
				}
			%>
		</div>
	</nav>
	<div class="container">
		<!-- jumbotron : 일반적으로 웹사이트를 소개하는 영역 -->
		<div class="jumbotron">
			<div class="container">
				<h1>웹 사이트 소개</h1>
				<p>해당 사이트는 게시판, 회원관리를 이용할 수 있는 로직을 활용한 웹 사이트입니다.</p>
				<p><a class="btn btn-primary btn-pull" href="#" role="button">자세히 알아보기</a></p>
				<div id="slider">
		            <img class="pic" src="./images/image1.jpg" alt="사막" />
		            <img class="pic" src="./images/image2.jpg" alt="수국" />
		            <img class="pic" src="./images/image3.jpg" alt="해파리" />
		            <img class="pic" src="./images/image4.jpg" alt="코알라" />
		            <img class="pic" src="./images/image5.jpg" alt="등대" />
		            <button type="button" id="prev">이전</button>
		            <button type="button" id="next">이후</button>
		            <p id="page"></p>
		            <div id="dots"></div>
		        </div>
			</div>
		</div>
	</div>

    <script src="js/script.js"></script>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>