<%@page import="vo.LoginVO"%>
<%@page import="dao.LoginDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

 <%
     request.setCharacterEncoding("UTF-8");
 
     String introduction =request.getParameter("introduction");
     String imgsrc = request.getParameter("imgsrc0");
       // out.println(txt +"님 안녕하세요");
          
       //  out.println("<h1>"+introduction+"<h1>");
         
        LoginDAO dao = new LoginDAO();
         
        LoginVO user = (LoginVO)session.getAttribute("logvo");
        //   System.out.println("mno : "+user.getMno());
           user.setMdetail(introduction);
           user.setMimg(imgsrc);
           
         dao.updateOne(introduction, user.getMno());
         dao.imgOne(user.getMno(),imgsrc);
       //   System.out.println("introduction : "+introduction);
       //    System.out.println("Mdetail : "+user.getMdetail());
         response.sendRedirect("mypage.jsp");
    %> 