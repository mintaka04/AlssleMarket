<%@page import="vo.LoginVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
Object obj = session.getAttribute("logvo");
if (obj != null) {
	LoginVO vo = (LoginVO) obj;

%>

<!-- Logined Navigation-->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<div class="container px-4 px-lg-5">

		<a class="navbar-brand" href="../main_login/main.jsp"><img
			src="../images/alssleIcon.png" alt="" width="30px"/>알쓸장터        </a>


		<div class="search">
			<input id="searchtext" type="text" placeholder="검색어를 입력해주세요"
				onkeypress="if(event.keyCode==13){searchData();}" style="width :700px"> <img
				id="searchimg"
				src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"
				onclick="searchData()" >
		</div>

		<ul class="navbar-nav mb-2 mb-lg-0 mainnav">
			<li class="nav-item"><a class="nav-link"
				href="../chatting/chatCheck.jsp">알쓸톡</a></li>
			<li class="nav-item dropdown sbtn"><a
				class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
				role="button" data-bs-toggle="dropdown" aria-expanded="false"> <%=vo.getNickname()%>님
					환영합니다
			</a>
				<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
					<li><a class="dropdown-item" href="../page/mypage.jsp">마이페이지</a></li>
					<li><a class="dropdown-item" href="../write/write.jsp">판매하기</a></li>
					<li><hr class="dropdown-divider" /></li>
					<li><a class="dropdown-item" href="../main_login/logout.jsp">로그아웃</a></li>
				</ul></li>
		</ul>

	</div>
</nav>


<%
} else {
%>

<!-- Not Logined Navigation-->
<nav class="navbar navbar-expand-lg navbar-light bg-light">

	<div class="container px-4 px-lg-5">
		<a class="navbar-brand" href="#!" style="font-size: 1.3em;"><img
			src="../images/alssleIcon.png" alt="" width="30px" />알쓸장터        </a>

		<div class="search">
			<input id="searchtext" type="text" placeholder="검색어를 입력해주세요"
				onkeypress="if(event.keyCode==13){searchData();}" style="width :600px"> 
			<img id = "searchimg" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png" onclick="searchData()" >
		</div>

		<ul class="navbar-nav mb-2 mb-lg-0 mainnav">
			<li class="nav-item"><a class="nav-link active"
				href="../main_login/login.jsp">알쓸톡</a></li>
			<li><a class="nav-link sbtn" href="../main_login/login.jsp">로그인/회원가입</a></li>
		</ul>
	</div>
</nav>

<%
}
%>
