<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- Navigation-->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<div class="container px-4 px-lg-5">

		<%
		request.setCharacterEncoding("UTF-8");
		String id = request.getParameter("id");
		%>

		<a class="navbar-brand" href="#!"><img
			src="../images/alssleIcon.png" alt="" width="30px" />알쓸장터 환영합니다.</a>
		<div class="nav_search" style="margin: auto">
			<input type="text" placeholder="검색어를 입력하세요"
				style="width: 100%; border: 1px solid #bbb; border-radius: 8px; padding: 10px 12px; font-size: 14px;">
			<img id="searchimg"
				src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png">
		</div>

		<form class="d-flex">
			<button class="btn btn-outline-dark" type="submit">
				<i class="bi-cart-fill me-1"></i>
				<%=URLDecoder.decode(id, "UTF-8")%>님 <span
					class="badge bg-dark text-white ms-1 rounded-pill">0</span>
			</button>
		</form>
	</div>
	</div>
</nav>