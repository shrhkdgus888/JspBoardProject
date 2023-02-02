<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- javascript 라이브러리 import -->
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
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			//글이 없어, bbs.jsp로 다시 돌아감.
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		//매개변수 및 기본셋팅(현재 수정하고자 하는 id값(게시글의 번호) : bbsID)
		int bbsID = 0;
		//넘어온 "bbsID"라는 매개변수가 존재한다면,
		if(request.getParameter("bbsID") !=null){
			//어떤 특정한 게시글을 눌렀을 때, 'bbsID=번호'가 넘어왔다면 그것을 이용해서 처리함.
			//		ex)http://localhost:8090/toyproject/view.jsp?bbsID=4
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		//현재 수정하고자 하는 글의 번호가 없다면, 유효하지 않은 글이라고 알림.
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
		//현재 작성한 글이 작성한 사람 본인인지 확인함.(세션관리필요)
		//userID : 현재 접속해있는 유저(세션이 있는 값)/ getUserID : 게시글을 작성한 사람의 값
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			//글의 수정권한이 없어, bbs.jsp로 다시 돌아감.
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
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
		</div>
	</nav>
	
	<div class="container">
		<div class="row">
		<!-- form태그를 이용하여 action페이지로 보내줄 수 있도록함. 
		         즉, 글 제목과 글 내용은 updateAction.jsp로 보내짐으로써, 글이 수정될 수 있게끔 해준다. -->
		<form method="post" action="updateAction.jsp?bbsID=<%=bbsID%>">
			<!-- 게시판의 목록들이 홀짝으로 색상이 변경되어 보이는 형태 -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<!-- table의 가장 윗줄, 각각의 속성들을 알려줌 -->
				<thead>
					<!-- tr(table row), table의 하나의 행(row) -->
					<!-- colspan="2", 총 2개만큼의 열을 사용할 수 있도록 함 -->
					<tr>
						<th colspan="2" style="backgroud-color : #eeeeee; text-align: center;">게시판 글수정</th>

					</tr>
				</thead>
				
				<tbody>
					<!-- tr태그로 글 제목과 내용을 각각 묶어줘서 한줄씩 들어갈 수 있게끔 해준다. -->
					<tr>
						<!-- input태그 : 특정 정보를 action페이지로 전달하기 위해 사용함. -->
						<%-- value="<%= bbs.getBbsTitle() : 글을 수정하는 페이지이기 때문에, 자신의 수정전 게시글(제목)을 보여줌 --%>
						<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" 
						value="<%= bbs.getBbsTitle() %>"> </td>
					</tr>
					<!-- tr태그로 글 제목과 내용을 각각 묶어줘서 한줄씩 들어갈 수 있게끔 해준다. -->
					<tr>
						<%-- value="<%= bbs.getBbsTitle() : 글을 수정하는 페이지이기 때문에, 자신의 수정전 게시글(내용)을 보여줌 --%>	
						<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea></td>
					</tr>
				</tbody>
			</table>
			<!-- 글쓰기 버튼 -->
			<!-- pull-right: 하나의 버튼이 오른쪽에 고정될 수 있도록 함. -->			
			<input type="submit" class="btn btn-primary pull-right" value="글수정">		
		</form>
		</div>
	
	</div>
	
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>