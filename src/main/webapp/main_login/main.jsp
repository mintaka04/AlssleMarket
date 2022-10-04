<%@page import="vo.LoginVO"%>
<%@page import="vo.MainProdVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="mainHead.jsp"/>
<style type = "text/css">
	@font-face {
	  font-family : 'godo';
	  src : url('../resources/css/GodoB.woff') format('woff');
	}
</style>	

</head>
<style>
	.search {
	  position: relative;
	  width: 900px;
	  margin : 50px auto;
	}
	#searchtext {
	  width: 100%;
	  border: 3px solid #d80c18;
	  border-radius: 8px;
	  padding: 10px 12px;
	  font-size: 15px;
	  font-family : 'godo';
	}
	#searchtext:focus{
		border: 3px solid #d80c18;
	}
	#searchimg {
	  position : absolute;
	  width: 17px;
	  top: 10px;
	  right: 12px;
	  margin: 0;
	  padding-top: 4px;
	}		
	#ptitle{
	 overflow: hidden;
	 text-overflow: ellipsis;
	 white-space: nowrap;
	}	
	.mdetail{
		margin-top : 5px;
	}
	.prodprice{
		float : left;
		font-size : 14px;
		font-weight : bold;
		
	}
	.diffdate{
		padding-top : 2px;
		text-align : right;
		font-size : 12px;
		color : gray;
	}
	.prodtitle{
		font-size : 12px;
	}	
	.col.mb-2.prodarea{
		padding-right : calc(var(--bs-gutter-x) * 0.1);
		padding-left : calc(var(--bs-gutter-x) * 0.1);
		height : 300px;
	}
	.card.h-100.prodcard{
		height : 300px;
	}
	.card-img-top.prodimg{
		height : 230px;
	}
	.card-body{
		padding : auto 0.2rem;
	}
	
	
	
 	.navbar-nav.mb-2.mb-lg-0.mainnav{
		flex-direction : row;
	} 
	.nav-link.sbtn, .nav-item.dropdown.sbtn{
		margin-left : 15px;
	}
	
	
	#maintt{
		text-align : center;
		font-size : 25px;
		font-weight : bold;
	}
</style>
<script>
	function prodTime(diffSec){
		var sec = diffSec;
		if(sec < 60 ) return '방금 전';
		var min = sec / 60;
		if(min < 60 ) return Math.floor(min)+'분 전';
		var hours = min / 60;
		if(hours < 24 ) return Math.floor(hours)+'시간 전';
		var days = hours / 24;
		if(days < 7) return Math.floor(days)+'일 전';
		var weeks = days / 7;
		if(weeks < 5) return Math.floor(weeks)+'주 전';
		var months = days/ 30;
		if(months < 12) return Math.floor(months)+'개월 전';
		var years = days / 365;
		return Math.floor(years)+'년 전';
	}
	
	function searchData(){
		var search = document.getElementById("searchtext").value;
		location.href = "../result/result.jsp?searchenter="+search;
	}
</script>
<body>

	<jsp:include page="mainNav.jsp"/>	
	<jsp:include page="mainHeader.jsp"/>

	<div class="search">
	  <input id = "searchtext" type="text" placeholder="검색어 입력" onkeypress="if(event.keyCode==13){searchData();}" >
	  <img id = "searchimg" src="../images/searchicon.png" onclick="searchData()" >
	</div>
<!-- Section-->
        <section class="py-5" style="font-family : 'godo'";>	
		<div id = "maintt">인기상품</div>
            <div class="container px-4 px-lg-5 mt-5">
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-4 row-cols-xl-5 justify-content-center">


<%
ProductDAO dao = new ProductDAO();
	ArrayList<MainProdVO> mlist = dao.selectMain();
	for(MainProdVO vo : mlist){
%>
	
	                   <div class="col mb-2 prodarea" >
                        <div class="card h-100 prodcard">
                            <a href="../write/detailBoots.jsp?pno=<%=vo.getPno()%>">
                            <!-- Product image-->
                            	<img class="card-img-top prodimg" src="<%=vo.getImg() %>" alt="<%=vo.getTitle() %>" />
                            </a>
                            <!-- Product details-->
                            <div class="card-body">
                                    <!-- Product name-->
                                    <div class="prodtitle" id ="ptitle"><%=vo.getTitle() %></div>
                                    <div class = "mdetail">
	                                    <div class = "prodprice">
		                                    <!-- Product price-->
		                                    <%=vo.getPrice() %>원
	                                    </div>
	                                    
	                                   <div class = "diffdate" id="date<%=vo.getPno()%>">
	                                   		<%=vo.getDiffSec() %>
	                                   </div>
	                                   <script>
												var caldate = prodTime("<%=vo.getDiffSec() %>");
												document.getElementById("date<%=vo.getPno()%>").innerHTML = caldate;
										</script>                                    
                                    </div>
                            </div>
                        </div>
                    </div>

<%
	}
%>
                </div>
            </div>
        </section>
        <jsp:include page="mainFooter.jsp"/>
</body>
</html>