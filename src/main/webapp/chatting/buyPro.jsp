<%@page import="dao.MyPageDAO"%>
<%@page import="dao.ChatDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=UTF-8");
	
	int pno = Integer.parseInt(request.getParameter("pno"));
	String buyUser = request.getParameter("buyUser");
	int rno = Integer.parseInt(request.getParameter("rno"));
	
	System.out.println("pno : "+pno);
	System.out.println("buyUser : "+buyUser);
	System.out.println("rno : "+rno);
	
	new ChatDAO().buyProduct(buyUser, pno);
	new MyPageDAO().sellUp(pno);
	
	response.sendRedirect("chat.jsp?rno="+rno);
	
%>