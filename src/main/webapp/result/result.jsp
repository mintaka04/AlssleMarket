<%@page import="dao.SearchDAO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.lang.reflect.Array"%>
<%@page import="lombok.var"%>
<%@page import="vo.MainProdVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=UTF-8");
	
	SearchDAO daoSearch = new SearchDAO();
	ProductDAO daoPro = new ProductDAO();

	// 넘어온 파라미터
	String searchenter = request.getParameter("searchenter");
	String minprice = request.getParameter("minprice");
	String maxprice	= request.getParameter("maxprice");
	String radio = request.getParameter("radio");
	String order = request.getParameter("order");
	String category = request.getParameter("category");
////////////////////////////////////////////////////
	// sql 로 질의했을 때 확인되는 전체 상품 수
	int totalCount = 0;
	
	// 페이징 처리
	// 한 페이지에 출력될 글 수 : 이게 변경되면 페이지에서 보이는 게시글 수가 변경됨
	int pageSize = 20;
	
	// 현 페이지 정보 설정
	// 처음에는 페이지 번호가 없으니까 pageNum 파라미터가 null 따라서 1페이지를 보여주기 위해 pageNum 에 1 을 넣기
	String pageNum = request.getParameter("pageNum");
		if(pageNum == null){
			pageNum = "1";
		}
	

	// 현재 페이지를 계산함 => 현재 페이지는 pageNum 파라미터의 값
	int currentPage = Integer.parseInt(pageNum);
	// 페이지마다 상품을 보여주는데 DB 에서 가져오는 상품의 시작 번호를 매 페이지마다 pageSize 에 맞춰서 계산함
	// ex) pageNum = 1 => = 0 ~ 20
	// ex) pageNum = 2 => 21 ~ 40
	// 아래는 계산식
	int startRow = (currentPage-1)*pageSize + 1;
	
	
	//System.out.println("totalCount : "+totalCount);
	//System.out.println("startRow : "+startRow);
	
	// 검색 결과 가져와서 저장
	ArrayList<MainProdVO> rlist = daoSearch.selectFilter(searchenter, minprice, maxprice, radio, order, category, startRow, pageSize);
	
	// 검색결과에 따른 전체 검색 갯수 저장
	totalCount = daoSearch.getSearchTotal(searchenter, minprice, maxprice, radio, category);
	//System.out.println("totalCount : "+totalCount);

	/* // 검색어 파라미터 가져오기
	if(searchenter !=null){
		//totalCount = daoSearch.searchTotal();
	} */
////////////////////////////////////////////////////////////		
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="resultHead.jsp" />
<style type = "text/css">
	@font-face {
	  font-family : 'godo';
	  src : url('../resources/css/GodoB.woff') format('woff');
	}
</style>
</head>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>

	#header{
		padding-top : 3rem;
		padding-bottom : 3rem;
	}

.filtertitle {
	float : left;
	color: black;
	width : 50px;
	text-align : center;
	margin-left : 20px;
	margin-right : 15px;
	font-size : 20px;
	font-family : 'godo';
}


/* 검색창 */
	.search {
	  position: relative;
	  width: 900px;
	  margin : 50px auto;
	  font-family : 'godo';
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
	}		

/* 필터관련div */
	#catdiv{
		float : left;
		margin : 5px 20px;
	}
	#pricediv{
		float : left;
		width : 480px;
		text-align : center;
	}
	#timediv{
		float : left;
		width : 380px;
		text-align : center;
	}
	#priceselect{
		float : left;
	}
	#timeselect{
		float : left;
	}
	
/* 필터적용버튼 */
	#filtersetbtn{
		color : white;
		background-color : #d80c18;
		border : 0;
		font-family : 'godo';
		width : 80px;
		height : 40px;
		border-radius: 5px;
		margin-left : 25px;
	}
	#filtersetbtn:hover{
		background-color : #d80c1855;
	}

/* 상품관련css */
	#ptitle{
	 overflow: hidden;
	 text-overflow: ellipsis;
	 white-space: nowrap;
	 font-family: 'godo';
	 font-size : 16px;
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




	/* 라디오버튼둥근거숨기기 */
	input[type=radio]{
		display : none;
		margin : 10px;
	}
	input[type=radio] + label{
		display : inline-block;
		padding : 4px 12px;
		background-color : white;
		color : #d80c18;
	}
	input[type=radio]:checked + label{
		background-color : #d80c18;
		color : white;
		border-radius: 5px;
		
	}
	

	
	/* ..에 대한 검색결과 */
	#searchresulttxt{
		float : left;
		margin-bottom : 10px;
	}	
	
	/* 정렬버튼들 */
	#button-sorting{
		text-align : right;
		padding-top : 15px;
	}
	.bso{
		background-color : rgba(0, 0, 0, 0);
		color : #d80c1855;
		font-size : 15px;
		border : 0;
		padding : 5px 10px;
		font-weight : bold;
		border-radius : 5px;
	}
	.bso:hover{
		color : white;
		background-color : #d80c1855;
	}
	
	
	#ppp{
		clear : both;
	}
	
	
	/* 페이징영역 */
	#page_control{
		text-align : center;
		margin-bottom : 30px;
	}
	.pagingbutton{
		color : gray;
		border : 0.2px solid gray;
		background-color : white;
		width : 45px;
		height : 45px;
		font-size :23px; 
		padding : auto;
		margin : 5px 5px;
		
	}
	.pagingbutton:hover{
		color : white;
		background-color : #d80c18;
		border : 0;
	}
	
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>

	/* 날짜 간격 출력 함수 */
	function prodTime(diffSec) {
		var sec = diffSec;
		if (sec < 60)
			return '방금 전';
		var min = sec / 60;
		if (min < 60)
			return Math.floor(min) + '분 전';
		var hours = min / 60;
		if (hours < 24)
			return Math.floor(hours) + '시간 전';
		var days = hours / 24;
		if (days < 7)
			return Math.floor(days) + '일 전';
		var weeks = days / 7;
		if (weeks < 5)
			return Math.floor(weeks) + '주 전';
		var months = days / 30;
		if (months < 12)
			return Math.floor(months) + '개월 전';
		var years = days / 365;
		return Math.floor(years) + '년 전';
	}
	
	/* 검색시 호출되는 함수 ->필터x, 정렬x인 상태*/
	function searchData(){
		var search = document.getElementById("searchtext").value;
		location.href = "../result/result.jsp?searchenter="+search;
	}
	
	/* 필터 적용시 호출->정렬x인 상태 */
	function filterurlmaker(){
		console.log("함수도착");
		searchenter = document.getElementById("searchtext").value;
		minprice = document.getElementById("lowprice").value.trim();
		maxprice = document.getElementById("highprice").value.trim();
		radio = $('input[name = "timeradio"]:checked').val();
		category = $('select[name="category"]').val();
		
		
		location.href = "../result/result.jsp?searchenter="+"<%=searchenter%>"
							+"&minprice="+minprice+"&maxprice="+maxprice
							+"&radio="+radio+"&category="+category;
	}
	
	/* 정렬 클릭시 호출->필터 유지 */
	function orderdate(){
		console.log("최신순정렬함수");
		order = "최신순";
		location.href = "../result/result.jsp?searchenter="+"<%=searchenter%>"
							+"&minprice="+"<%=minprice%>"+"&maxprice="+"<%=maxprice%>"
							+"&radio="+"<%=radio%>"+"&category="+"<%=category%>"
							+"&order="+order;
	}
	function orderhp(){
		console.log("높은가격순정렬함수");
		order = "높은가격순";
		location.href = "../result/result.jsp?searchenter="+"<%=searchenter%>"
							+"&minprice="+"<%=minprice%>"+"&maxprice="+"<%=maxprice%>"
							+"&radio="+"<%=radio%>"+"&category="+"<%=category%>"
							+"&order="+order;
	}
	function orderlp(){
		console.log("낮은가격순정렬함수");
		order = "낮은가격순";
		location.href = "../result/result.jsp?searchenter="+"<%=searchenter%>"
							+"&minprice="+"<%=minprice%>"+"&maxprice="+"<%=maxprice%>"
							+"&radio="+"<%=radio%>"+"&category="+"<%=category%>"
							+"&order="+order;
	}
	
</script>
<body>
	<jsp:include page="../main_login/mainNav.jsp" />
	<jsp:include page="resultHead.jsp" />

	<!-- Header-->
	<header id = "headertag">
		<!-- 필터위아래줄 -->
		<div class="container px-2 px-lg-5 my-2" style="border-bottom:1px solid rgb(229, 229, 229);">

			<!-- 검색창 -->
			<div class="search">
			  <input id = "searchtext" type="text" placeholder="검색어 입력" onkeypress="if(event.keyCode==13){searchData();}" >
			  <img id = "searchimg" src="../images/searchicon.png" onclick="searchData()" >
			</div>

			<!-- 필터 영역 -->
			<div id="filterdiv">
			
				
				<!-- 카테고리필터 영역-->
				<div id = "catdiv">
					<select name = "category" id = "catcat">
						<option value = "none">카테고리 선택</option>
						<option value = "디지털기기">디지털기기</option>
						<option value = "생활가전">생활가전</option>
						<option value = "가구/인테리어">가구/인테리어</option>
						<option value = "유아동">유아동</option>
						<option value = "생활/가공식품">생활/가공식품</option>
						<option value = "패션/잡화">패션/잡화</option>
						<option value = "게임/취미">게임/취미</option>
						<option value = "반려동물용품">반려동물용품</option>
						<option value = "도서/티켓/음반">도서/티켓/음반</option>
						<option value = "기타 중고물품">기타 중고물품</option>
					</select>
				</div>
				
				<!-- 가격필터 영역 -->
				<div id="pricediv">
					<div class="filtertitle" id="pricetitle">가격</div>
					<div id="priceselect">
						<input type="text" class="inputprice" id="lowprice" placeholder = "낮은가격입력">
						<span>~</span>
						<input type="text" class="inputprice" id="highprice" placeholder = "높은가격입력">
					</div>
				</div>
				
				<!-- 기간필터 영역-->
				<div id="timediv">
					<div class="filtertitle" id="timetitle">기간</div>
					<div id="timeselect">
						<input type="radio" name="timeradio" id="opt1" value="전체">
							<label for="opt1"><span>전체</span></label> 
						<input type="radio" name="timeradio" id="opt2" value="1일"> 
							<label for="opt2"><span>1일</span></label> 
						<input type="radio" name="timeradio" id="opt3" value="7일"> 
							<label for="opt3"><span>7일</span></label> 
						<input type="radio" name="timeradio" id="opt4" value="1달"> 
							<label for="opt4"><span>1달</span></label> 
						<input type="radio" name="timeradio" id="opt5" value="3달"> 
							<label for="opt5"><span>3달</span></label>
					</div>
				</div>
				
				<!-- 필터 적용 버튼 -->
				<input id = "filtersetbtn" type="button" value="필터적용" onclick="filterurlmaker();" />
			</div> 
			<br />
			<br />
		</div>
		
	</header>

<script>

	/* 필터적용시 가격유지 */
	if(!isNaN("<%=minprice%>")){
		document.getElementById("lowprice").value = "<%=minprice%>";
	}
	if(!isNaN("<%=maxprice%>")){
		document.getElementById("highprice").value = "<%=maxprice%>";
	}
	
	/* 필터적용시 기간유지 */
	var rrrrr = document.getElementsByName('timeradio');
	for(var i = 0; i < rrrrr.length; i++){
		if(rrrrr[i].value == "<%=radio%>"){
			console.log(rrrrr[i].value);
			rrrrr[i].checked = true;
		}
	}
	
	/* 필터적용시 카테고리 유지 */
	var ccc = document.getElementById('catcat');
	switch("<%=category%>"){
		case "디지털기기" : 
			ccc.options[1].selected = true;
			break;
		case "생활가전" :
			ccc.options[2].selected = true;
			break;
		case "가구/인테리어" :
			ccc.options[3].selected = true;
			break;
		case "유아동" : 
			ccc.options[4].selected = true;
			break;
		case "생활/가공식품" : 
			ccc.options[5].selected = true;
			break;
		case "패션/잡화" : 
			ccc.options[6].selected = true;
			break;
		case "게임/취미" : 
			ccc.options[7].selected = true;
			break;
		case "반려동물용품" :
			ccc.options[8].selected = true;
			break;
		case "도서/티켓/음반" : 
			ccc.options[9].selected = true;
			break;
		case "기타 중고물품" : 
			ccc.options[10].selected = true;
			break;
	}
</script>

	<!-- Section-->
	<section class="py-5">
		<div class="container px-4 px-lg-5 mt-5">
		
			<!-- 상품위 영역 -->
			<div id = "upperproduct">
				<!-- 검색어영역 -->
				<div class="text-left text-white"  id = "searchresulttxt">
					<h1 class="display-4 fw-bolder" style="font-size: 2em; color : black">
						"<%=searchenter%>"에 대한 검색결과
					</h1>
				</div>
			
				<!-- 정렬 영역-->
				<div id = "button-sorting">
					<input type="button"  class = "bso" id="bydate" name="date" value="최신순" onclick="orderdate();"/>
					<input type="button" class = "bso" id="byhigh" name="highPrice" value="높은가격순" onclick="orderhp();"/>
					<input type="button" class = "bso" id="bylow" name="lowPrice" value="낮은가격순" onclick="orderlp();"/>
				</div>
			</div>
			
			<script>
				if("<%=order%>"=="최신순"){
					var babc = document.getElementById("bydate");
					babc.style.backgroundColor = "#d80c1855";
					babc.style.color = "white";
				}
				if("<%=order%>"=="높은가격순"){
					var babc = document.getElementById("byhigh");
					babc.style.backgroundColor = "#d80c1855";
					babc.style.color = "white";
				}
				if("<%=order%>"=="낮은가격순"){
					var babc = document.getElementById("bylow");
					babc.style.backgroundColor = "#d80c1855";
					babc.style.color = "white";
				}
			</script>
			
			<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-4 row-cols-xl-5 justify-content-center" id = "ppp">

				<%
				for (MainProdVO vo : rlist) {
				%>



				<div class="col mb-2 prodarea">
					<div class="card h-100 prodcard">
						<a href="../write/detailBoots.jsp?pno=<%=vo.getPno()%>"> 
						<!-- Product image-->
							<img class="card-img-top prodimg" src="<%=vo.getImg()%>"
							alt="<%=vo.getTitle()%>" />
						</a>

						<!-- Product details-->
						<div class="card-body">
							<!-- Product name-->
							<div class="prodtitle" id="ptitle"><%=vo.getTitle()%></div>
							<div class="mdetail">
								<div class="prodprice">
									<!-- Product price-->
									<%=vo.getPrice()%>원
								</div>

								<div class="diffdate" id="date<%=vo.getPno()%>">
									<%=vo.getDiffSec()%>
								</div>
								<script>
										var caldate = prodTime("<%=vo.getDiffSec()%>");
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
	
	
	<!-- 페이징 영역 -->
	<div id="page_control">
		<%if(totalCount != 0){ 
			////////////////////////////////////////////////////////////////
			// 페이징 처리
			// 전체 페이지수 계산
			// 
			int pageCount = totalCount / pageSize + (totalCount%pageSize==0?0:1);
			
			// 한 페이지에 보여줄 페이지 블럭
			int pageBlock = 10;
			
			// 한 페이지에 보여줄 페이지 블럭 시작번호 계산
			int startPage = ((currentPage-1)/pageBlock)*pageBlock+1;
			
			// 한 페이지에 보여줄 페이지 블럭 끝 번호 계산
			int endPage = startPage + pageBlock-1;
			if(endPage > pageCount){
				endPage = pageCount;
			}	
		%>
	    
		<% if(startPage>pageBlock){ %>
			<a href="result.jsp?pageNum=<%=startPage-pageBlock%>">
				<input type="button" class = "pagingbutton" value="Prev" />
			</a>
		<%} %>
	    
		<% for(int i=startPage;i<=endPage;i++){ %>
			<a style = "text-decoration : none" href="result.jsp?pageNum=<%=i%>&searchenter=<%=searchenter%>&min=<%=minprice%>&max=<%=maxprice%>&radio=<%=radio%>&order=<%=order%>&category=<%=category%>">
				<input type="button" class = "pagingbutton" value="<%=i%>"/>
			</a>
		<%} %>
	    
		<% if(endPage<pageCount){ %>
			<a href="result.jsp?pageNum=<%=startPage+pageBlock%>">
				<input type="button" class = "pagingbutton" value="Next" />		
			</a>
		<%} %>
		<%} %>
	</div>
	
	<jsp:include page="../main_login/mainFooter.jsp" />

</body>
</html>