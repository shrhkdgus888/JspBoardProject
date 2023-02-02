<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- javascript 라이브러리 import -->
<!-- 글의 내용을 볼수있는 jsp -->
<%@ page import="java.io.PrintWriter" %>
<!-- db객체 -->
<%@ page import="bbs.Bbs" %>
<!-- db접근객체 -->
<%@ page import="bbs.BbsDao" %>
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
		//매개변수 및 기본셋팅
		int bbsID = 0;
		//넘어온 "bbsID"라는 매개변수가 존재한다면,
		if(request.getParameter("bbsID") !=null){
			//어떤 특정한 게시글을 눌렀을 때, 'bbsID=번호'가 넘어왔다면 그것을 이용해서 처리함.
			//		ex)http://localhost:8090/toyproject/view.jsp?bbsID=4
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			//글이 없어, bbs.jsp로 다시 돌아감.
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		//getBbs(bbsID)를 실행해서 유효한 글(0값이 아니라면)이라면 구체적인 정보를 Bbs bbs라는 인스턴스안에 담을수 있도록함.
		//게시글의 번호(게시글 아이디 값=getBbs(bbsID))을 가지고, 해당글(Bbs bbs)을 가져옴
		Bbs bbs = new BbsDao().getBbs(bbsID);
	
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
	<!--보여지기만 하면 되는 부분이기 때문에 form태그 따로 없음.-->
	<div class="container">
		<div class="row">
			<!-- 게시판의 목록들이 홀짝으로 색상이 변경되어 보이는 형태 -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<!-- table의 가장 윗줄, 각각의 속성들을 알려줌 -->
				<thead>
					<!-- tr(table row), table의 하나의 행(row) -->
					<!-- colspan="3", 총 3개만큼의 열을 사용할 수 있도록 함 -->
					<tr>
						<th colspan="3" style="backgroud-color : #eeeeee; text-align: center;">게시판 글보기</th>

					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td style="width: 20%">글 제목</td>
						<td colspan="2"><%=bbs.getBbsTitle()%></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%=bbs.getUserID()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%=bbs.getRegDate()%></td>
					</tr>
					<tr>
						<td>내용</td>
						<!-- replaceAll : 공백, 특수문자가 보일 수 있도록 처리함 -->
						<td colspan="2" style="min-height: 200px; text-align: left;"><%=bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
					</tr>
				</tbody>
			</table>
			<!-- 목록으로 돌아가기 -->
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<!-- 현재 게시글에 접속한 작성자(현재사용자)가 본인이라면, 글을 수정할 수 있도록 함 --> 
			<%
			/*참고 : if(userID !=null && userID(현재사용자).equals(bbs.getUserID(글의 작성자)))) */
				if(userID !=null && userID.equals(bbs.getUserID())){
					//해당 bbsID를 가져가서 수정할 수 있도록 함.
			%>		
					<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a> 
					<!-- onclick="return confirm : 삭제하기전 확인메세지 -->
					<a onclick="return confirm('삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a> 
			<% 		
				}	
			%>
			<!-- 글쓰기 버튼 -->
			<!-- pull-right: 하나의 버튼이 오른쪽에 고정될 수 있도록 함. -->			
			<input type="submit" class="btn btn-primary pull-right" value="글쓰기">		
		</div>
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>