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
			int pno = Integer.parseInt(request.getParameter("pno"));
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
			dao.updateOne(pno, title, category, loc, price, trade, detail, fee);
			//response.sendRedirect("main.jsp");
	%>
</body>
</html>