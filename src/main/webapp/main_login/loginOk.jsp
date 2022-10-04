
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
				
		LoginDAO ldao = new LoginDAO();
		LoginVO lvo = ldao.isExists(email, pw);
		
		if(lvo==null){
			response.sendRedirect("../main_login/login.jsp?msg=fail");
			/* response.sendRedirect("../main_login/login.jsp"); */
		}else{
			out.println("<h2>"+lvo.getNickname()+"님 환영합니다. </h2>");
			System.out.println(session);
			session.setAttribute("logvo", lvo);
			response.sendRedirect("../main_login/main.jsp");
			
		}
		
	%>

</body>
</html>