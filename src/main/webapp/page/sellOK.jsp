<%@page import="dao.MyPageDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  
  
  
  <%
 //판매중으로 바꾸끼
  
  
  String p =request.getParameter("pno");
  
      if(p !=null){
    	  int pno = Integer.parseInt(p);
      
    	  MyPageDAO dao =new MyPageDAO();
    	      
    	    dao.sellDown(pno);
    	    
    	  
      }
      
    //목록페이지로 리다이렉트
    		response.sendRedirect("mypage.jsp");
  
  %>