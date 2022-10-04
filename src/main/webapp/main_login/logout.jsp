<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.removeAttribute("logvo");
	response.sendRedirect("../main_login/main.jsp");
%>