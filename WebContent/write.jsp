<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- javascript 라이브러리 import -->
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
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
				<li><a href="main.jsp">메인</a></li>
				<!-- 현재 접속한 페이지가 bbs(게시판) 페이지라는 것을 보여줌 -->
				<li class="active"><a href="bbs.jsp">게시판</a></li>
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
		<div class="row">
		<!-- form태그를 이용하여 action페이지로 보내줄 수 있도록함. 
		         즉, 글 제목과 글 내용은 writeAction.jsp로 보내짐으로써, 글이 등록될 수 있게끔 해준다. -->
		<form method="post" action="writeAction.jsp">
			<!-- 게시판의 목록들이 홀짝으로 색상이 변경되어 보이는 형태 -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<!-- table의 가장 윗줄, 각각의 속성들을 알려줌 -->
				<thead>
					<!-- tr(table row), table의 하나의 행(row) -->
					<!-- colspan="2", 총 2개만큼의 열을 사용할 수 있도록 함 -->
					<tr>
						<th colspan="2" style="backgroud-color : #eeeeee; text-align: center;">게시판 글쓰기 양식</th>

					</tr>
				</thead>
				
				<tbody>
					<!-- tr태그로 글 제목과 내용을 각각 묶어줘서 한줄씩 들어갈 수 있게끔 해준다. -->
					<tr>
						<!-- input태그 : 특정 정보를 action페이지로 전달하기 위해 사용함. -->
						<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"></td>
					</tr>
					<!-- tr태그로 글 제목과 내용을 각각 묶어줘서 한줄씩 들어갈 수 있게끔 해준다. -->
					<tr>	
						<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>
					</tr>
				</tbody>
			</table>
			<!-- 글쓰기 버튼 -->
			<!-- pull-right: 하나의 버튼이 오른쪽에 고정될 수 있도록 함. -->			
			<input type="submit" class="btn btn-primary pull-right" value="글쓰기">		
		</form>
		</div>
	
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>