<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- javascript 라이브러리 import -->
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDao" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	/* a태그와 a태그에 마우스포인터를 글 제목위에 올릴때 미관상 검정색으로 스타일 처리함. */
	a, a:hover{
		/* 검정색 */
		color: #000000;
		text-decoration: none;
	}

</style>
</head>
<body>
	<%
		//로그인이 된 사람의 로그인 정보를 담을 수 있도록 해줌.
		String userID = null;
		//현재 세션이 존재한다면 그 값을 그대로 받아서 이용할 수 있도록 함.
		if (session.getAttribute("userID") !=null){
			userID = (String) session.getAttribute("userID");
		}
		//현재 게시판이 몇번째 페이지인지 알려줌.
			//int pageNumber = 1; 기본페이지
		int pageNumber = 1;
		//pageNumber에 파라미터 값이 있다면,
		if(request.getParameter("pageNumber") != null){
			//모든 파라미터는 정수형으로 가져옴.
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
			<!-- 게시판의 목록들이 홀짝으로 색상이 변경되어 보이는 형태 -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<!-- table의 가장 윗줄, 각각의 속성들을 알려줌 -->
				<thead>
					<!-- table row, table의 하나의 행(row) --> 
					<tr>
						<th style="backgroud-color : #eeeeee; text-align: center;">번호</th>
						<th style="backgroud-color : #eeeeee; text-align: center;">제목</th>
						<th style="backgroud-color : #eeeeee; text-align: center;">작성자</th>
						<th style="backgroud-color : #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				
				<tbody>
					<!-- 게시글 목록 출력 --> 
					<%
						/* 게시글 목록 출력을 위한 인스턴스 생성함 */
						BbsDao bbsDao = new BbsDao();
						/* 현재의 페이지에서 가져온 리스트(게시글 목록) */
						ArrayList<Bbs> ls = bbsDao.getList(pageNumber);
						/* 가져온 리스트(게시글 목록)을 출력함 */
						for(int i = 0; i <ls.size(); i++){
					%>		
					<!--각각의 게시글에 대한 내용 -->
					<tr>
						<td><%= ls.get(i).getBbsID() %></td>
						<!-- 게시글의 제목을 누르면 num(매개변수)를 통해 글 내용을 볼 수 있도록 함-->
						<!-- replaceAll : 크로스사이트 스크립트 대응 -->
						<td><a href="view.jsp?bbsID=<%= ls.get(i).getBbsID() %>"><%= ls.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
						<td><%= ls.get(i).getUserID() %></td>
						<!-- substring을 이용하여, 필요한 날짜형의 형태로 사용함 -->
						<!-- ex) substring(11, 13) 11번 문자부터 13번 문자까지 잘라오겠다. -->
						<td><%= ls.get(i).getRegDate() %></td>
					</tr>		
					<% 		
						}
					%>
				</tbody>
			</table>
			<!-- page를 보여주는 부분 -->
			<%
				//pageNumber가 1이 아니라면 → 전부 2page 이상이기 때문에 이전페이지로 돌아갈 수 있는 것이 필요함.
				if(pageNumber != 1){
			%>		
					<!-- 이전페이지로 돌아가기 -->
					<a href="bbs.jsp?pageNumber=<%=pageNumber - 1%>" class="btn btn-success btn-arraw-left">이전</a>
			<% 	
				//다음페이지(pageNumber + 1)가 존재한다면, 
				} if(bbsDao.nextPage(pageNumber + 1)){
			%>
					<!-- 다음페이지로 넘어가기 -->
					<a href="bbs.jsp?pageNumber=<%=pageNumber + 1%>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
			<!-- pull-right: 하나의 버튼이 오른쪽에 고정될 수 있도록 함. -->
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>