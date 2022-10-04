<%@page import="vo.ChatVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.ChatDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>

<script>
	$(function(){
		$("#btn").on("click", function(){
			  window.resizeTo(630, 700);
			
		})
		
		
	})
</script>
</head>
<body>
	<h2>테스트중...</h2>
	<button type="button" id="btn" onclick="location.href='./chatCheck.jsp?pno=1'">상품 목록에서 넘어오는 페이지</button>
	<br>
	<button type="button" id="btn" onclick="location.href='./chatCheck.jsp'">어디서든 alssleTalk</button>
	<%
		ArrayList<ChatVO> roomList = new ChatDAO().chatRoomList(1);
		int rno = roomList.get(0).getRno();
		
		ArrayList<String> img = new ArrayList<String>();
		
	%>
	<h1><%=rno %></h1>
	<a href="./chat.jsp?rno=<%=rno %>"><%=rno %></a>
	
	<!-- 로그인 정보
	scott@naver.com 1111
	smith@google.com 2222
	south@daum.net 3333
	imymemine@daum.net 1556 -- 15
	lalisa@google.com 1334 -- 13
	twicelove@daum.net 8888 -- 8
	
	
	-->
	
</body>
</html>