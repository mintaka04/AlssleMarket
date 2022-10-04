<%@page import="vo.LoginVO"%>
<%@page import="dao.LoginDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
		request.setCharacterEncoding("UTF-8");
		
		String email = request.getParameter("email");
		String pw = request.getParameter("pw");
		String nickname = request.getParameter("nickname");
		String pnum = request.getParameter("pnum");
		
		LoginDAO ldao = new LoginDAO();
		ldao.insertOne(email, pw, nickname, pnum);
		response.sendRedirect("../main_login/login.jsp");
	%>

</body>
</html>