<%@page import="vo.ProductVO"%>
<%@page import="org.apache.coyote.Request"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.ParamPart"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.FilePart"%>
<%@page import="com.oreilly.servlet.multipart.MultipartParser"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="vo.LoginVO"%>
<%@page import="dao.ProductDAO"%>
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
        int mno = Integer.parseInt(request.getParameter("mno"));
        String category = request.getParameter("category");
        String title = request.getParameter("title");
        int price = Integer.parseInt(request.getParameter("price"));
        String loc = request.getParameter("tradeArea");
        String direct = request.getParameter("direct");
        String delivery = request.getParameter("delivery");
        String trade = "";
        if(direct==null && delivery==null){
            trade="";
        }else if(direct==null){
            trade=delivery;
        }else if(delivery==null){
            trade=direct;
        }else{
            trade=delivery+","+direct;
        }
        String fee = request.getParameter("deliveryFee");
        String detail = request.getParameter("detail");

        ProductDAO dao = new ProductDAO();
        dao.write(mno, category, title, price, loc, trade, fee, detail);
        for(int i=0;i<10;i++){
        	String imgsrc = request.getParameter("imgsrc"+i);
        	if(imgsrc!=null){
		        dao.imgsave(imgsrc);
        	}
    	}
        response.sendRedirect("../main_login/main.jsp");
    %>
</body>
</html>