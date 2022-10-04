<%@page import="dao.LoginDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String email = request.getParameter("email");
	String result="";
	if(email!=null){
		LoginDAO dao = new LoginDAO();
		result = dao.isExists(email);
	}else{
		result = "false";
	}
	out.println(result);
%>