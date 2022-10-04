<%@page import="dao.MyPageDAO"%>
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
  String p =request.getParameter("pno");
  
      if(p !=null){
    	  int pno = Integer.parseInt(p);
      
    	    MyPageDAO dao =new MyPageDAO();
    	      
    	    dao.deletAll(pno);
    	  
      }
      
    //목록페이지로 리다이렉트
    		response.sendRedirect("../main_login/main.jsp");
  
  %>
        
</body>
</html>