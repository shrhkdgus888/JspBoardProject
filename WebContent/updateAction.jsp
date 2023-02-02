<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDao" %>
<%@ page import="bbs.Bbs" %>

<!-- JavaScript 사용 -->
<%@ page import="java.io.PrintWriter" %>
<!--  요청한 정보를 한글이 들어올수 있게끔 utf-8로 셋팅 -->
<% request.setCharacterEncoding("utf-8"); %>


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
			//글의 수정권한이 있을때,
		} else {
			//bbsTitle, bbsContent이라는 매개변수로 넘어온 값들을 널값인지 체크함.
			if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
				//bbsTitle, bbsContent 빈칸체크
				|| request.getParameter("bbsTitle").equals("")|| request.getParameter("bbsContent").equals("")){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
				//게시판에 빈칸없을 때
			} else {
				BbsDao bbsDao = new BbsDao();
				int result = bbsDao.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
				//데이터베이스 오류
				if (result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정을 실패하였습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				//글쓰기 성공
				else{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					//글쓰기 성공시 문구 띄우기
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
			
		}

	%>
</body>
</html>