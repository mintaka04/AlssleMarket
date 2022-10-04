<%@page import="dao.LikeDAO"%>
<%@page import="vo.LikeVO"%>
<%@page import="org.apache.catalina.ssi.SSIConditional"%>
<%@page import="vo.LoginVO"%>
<%@page import="vo.MyPageVO"%>
<%@page import="dao.MyPageDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
LoginVO user = (LoginVO) session.getAttribute("logvo");
MyPageDAO dao = new MyPageDAO();
LikeDAO ldao = new LikeDAO();

////////////////////////////////////////////////////
// sql 로 질의했을 때 탭에 따른 상품 수

// 판매 상품 갯수, 좋아요 갯수, 구매 갯수, 판매완료 갯수
int sellCount = dao.getSellCount(user.getMno());
int likeCount = dao.getLikeCount(user.getMno());
int buyCount = dao.getBuyCount(user.getMno());
int sellOkCount = dao.getSellOkCount(user.getMno());

System.out.println("SellCount : " + sellCount);
System.out.println("likeCount : " + likeCount);
System.out.println("buyCount : " + buyCount);
System.out.println("sellOkCount : " + sellOkCount);

// 페이징 처리
// 한 페이지에 출력될 글 수 
int pageSize = 8;

// 현 페이지 정보 설정
// 처음에는 페이지 번호가 없으니까 pageNum 파라미터가 null 따라서 1페이지를 보여주기 위해 pageNum 에 1 을 넣기
String pageNum = request.getParameter("pageNum");
if (pageNum == null) {
	pageNum = "1";
}

// 현재 페이지를 계산함 => 현재 페이지는 pageNum 파라미터의 값
int currentPage = Integer.parseInt(pageNum);

// 페이지마다 상품을 보여주는데 DB 에서 가져오는 상품의 시작 번호를 매 페이지마다 pageSize 에 맞춰서 계산함
// ex) pageNum = 1 => = 0 ~ 20
// ex) pageNum = 2 => 21 ~ 40
// 아래는 계산식
int startRow = (currentPage - 1) * pageSize + 1;

//System.out.println("totalCount : "+totalCount);
//System.out.println("startRow : "+startRow);
////////////////////////////////////////////////////////////
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<link rel="stylesheet" href="../resources/css/myPage.css" />
<link rel="stylesheet" href="../resources/css/nav.css" />
<link
	href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap"
	rel="stylesheet">
<jsp:include page="../main_login/mainHead.jsp" />
<style type="text/css">
/*페이징 css  */
#page_control {
	font-weight: bold;
	font-size: 20px;
}

#userImg {
	width: 400px;
	height: 400px;
}

.mySlidesimg {
	margin-top: -25px;
}

.uploadbtn {
	margin-top: 20px;
		font-family: 'godo';
}

.resetdiv {
	margin-top: 20px;
}

#data {
	width: 65.2%;
	height: 40px;
	position: relative;
	margin-bottom: 10px;
	border: none;
		font-family: 'godo';
}

#data2 {
	width: 65.2%;
	height: 40px;
	position: relative;
	margin-bottom: 10px;
	border: none;
		font-family: 'godo';
}

.data3 {
	width: 65.2%;
	height: 300px;
	position: relative;
		font-family: 'godo';
}

#modify {
	position: relative;
	float: right;
}

#tabs-1 {
	height: 950px;
	font-family: 'godo';
}

#tabs-2 {
	height: 950px;
	font-family: 'godo';
}

#tabs-3 {
	height: 950px;
	font-family: 'godo';
}

#tabs-4 {
	height: 950px;
	font-family: 'godo';
}

.size {
	width: 300px;
	height: 300px;
}

.wrap {
	width: 350px;
	height: 500px;
	float: left;
	padding: 30px;
	margin: 2px;
	margin-left: 30px;
}

.stylep {
	text-align: center;
	font-family: 'godo';
}

#pno {
	visibility: hidden;
}

.likebtn {
	width: 15%;
	float: right;
}

.resetimg {
	position: relative;
	left: 360px;
	top: -60px;
}

@font-face {
	font-family: 'godo';
	src: url('../resources/css/GodoB.woff') format('woff');
}

#page_control {
	text-align: center;
	margin-bottom: 30px;
}

.col.mb-2.prodarea {
	padding-right: calc(var(- -bs-gutter-x)* 0.1);
	padding-left: calc(var(- -bs-gutter-x)* 0.1);
	height: 400px;
}

.card.h-100.prodcard {
	height: 350px !important;
}

.card-img-top.prodimg {
	height: 230px;
}

.card-body {
	flex: 1 1 auto;
	padding: auto 0.2rem;
	font-family: 'godo';
}

.mybtns {
	font-family: 'godo';
}

#ptitle {
    font-size:16px;
}

</style>

<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
<script>
	$(function() {
		$("#tabs").tabs();
		
		
	});
	
	var count=0;
	var dotcount=1;
	
	function handleFileSelect() {
 	    //Check File API support
 	    if (window.File && window.FileList && window.FileReader) {

 	        var files = event.target.files; //FileList object
 	        var output = document.getElementById("result");
 	        var outputdot = document.getElementById("dotresult");

 	        for (var i = 0; i < files.length; i++) {
 	            var file = files[i];
 	            //Only pics
 	            if (!file.type.match('image')) continue;
                
 	            var picReader = new FileReader();
 	            picReader.addEventListener("load", function (event) {
 	            	if(count<1){
					var picFile = event.target;
					
					$("#userImg").remove();
               
					var div = document.createElement("div");	
					div.className="mySlides";
					if(count==0){div.style="display:block";}
					div.innerHTML = "<input type='text' style='display:none' name='imgsrc"+count+"' value='" + picFile.result+"'  />"+"<img onclick='viewimg("+count+");' name='img"+count+"' id='mySlidesimg"+count+"' class='mySlidesimg' src='" + picFile.result + "'" + "title='" + picFile.name + "'/>";
					output.insertBefore(div, null);
					count++;
					dotcount++;}
 	            });
 	            //Read the image
				picReader.readAsDataURL(file);
 	            
 	        }
 	    } else {
 	        console.log("Your browser does not support File API");
 	    }
 	}

 	
 	
 	//이미지 클릭시 새창에서 원본사진
 	function viewimg(i){
 		var win = window.open();
 	    win.document.write('<iframe src="' + document.getElementById("mySlidesimg"+i).src  + '" frameborder="0" style="border:0; top:0px; left:0px; bottom:0px; right:0px; width:100%; height:100%;" allowfullscreen></iframe>');
 	}
 	
 	function resetimg(){
 		$(".mySlides").remove();
 		$(".dot").remove();
 		count=0;
 		dotcount=1;
 	}
 	
 	function likeClick(likePno) {
		console.log("like : "+likePno);
		//$(".96").attr("src", "https://dimg.donga.com/ugc/CDB/WEEKLY/Article/5b/b3/22/85/5bb32285000ed2738de6.jpg");
		var $like = $("#"+likePno);
		//console.dir("no : "+$like);
		//console.log(JSON.stringify($like));

		
		
 		$.ajax({
			type: "POST",
			url : "MyPageServlet",
			data: {
				mno : <%=user.getMno()%>,
				pno : likePno
			},
			success : function(result){
				//console.log("likeClass : "+likeClass)
				
				//alert("전송")
				if(result == 1){
					$($like).attr('src','../images/like.png');
				}else if(result == 0){
					$($like).attr("src","../images/nolike.png");
				}else{
					//alert("DB error");
					//autoClosingAlert("#warningMessage", 2000)
				}
			}
		})
 	}
 	
 	
 	
</script>
</head>
<body>
	<jsp:include page="../main_login/mainNav.jsp" />
	<div class="container container2">
		<!-- 이미지사진, 닉네임 상품수 소개창 -->
		<form action="mypageOk.jsp" method="post" style="height: 500px">
			<input type="hidden" name="bno" value="<%=user.getMno()%>" />
			<div id="nav" style="margin-top: 50px;">
				<div class="imgbox">
					<input type="text" name="mno" value="<%=user.getMno()%>"
						style="display: none"></input>
					<!-- v 사진 -->
					<div class="slideshow-container">
						<%
						if (user.getMimg() == null) {
						%>
						<output id="result" />
						<img src="../images/default.png" id="userImg" alt="" />
						</output>
						<%
						} else {
						%>
						<output id="result" />
						<img src="<%=user.getMimg()%>" id="userImg" alt="" />
						</output>
						<%
						}
						%>

					</div>
					<div class="resetdiv">
						<label class="reset-button" for="reset_image"> <img
							src="../images/reset.png" alt="" class="resetimg" />
						</label> <input onclick="resetimg();" type="button" id="reset_image"
							style="display: none" />
					</div>
					<div class="uploadbtn">
						<label class="input-file-button" for="select_img"> 업로드 </label> <input
							accept=".gif, .jpg, .png, .jfif" onchange="handleFileSelect();"
							type="file" id="select_img" name="imageFiles"
							style="display: none" />
					</div>
				</div>

				<input type="text" name="deta" id="data"
					value="닉네임 : <%=user.getNickname()%>" disabled> <input
					type="text" name="deta" id="data2"
					value="총상품수 : <%=dao.getTotalCount(user.getMno())%>" disabled>
				<textarea class="data3" name="introduction"><%=user.getMdetail()%></textarea>
						<label class="input-file-button" for="modify" style="float:right; margin-top:11px"> 수정하기 </label> 
						<input type="submit" value="수정하기" id="modify" style="display:none;"/>
				<%
				System.out.println("USER : " + user.getMdetail());
				%>
				<%
				System.out.println("getTotalCount:" + dao.getTotalCount(user.getMno()));
				%>
			</div>
		</form>

		<div id="tabs">
			<ul>
				<li><a href="#tabs-1">판매목록</a></li>
				<li><a href="#tabs-2">관심목록</a></li>
				<li><a href="#tabs-3">구매목록</a></li>
				<li><a href="#tabs-4">판매완료</a></li>
			</ul>
			<div id="tabs-1">

				<!--판매목록  -->
				<section style="font-family: 'godo';">
					<div class="container px-4 px-lg-5 mt-5">
						<div
							class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">


							<%
							System.out.println(user.getMno());
							ArrayList<MyPageVO> list = dao.selectAll(user.getMno(), startRow, pageSize);
							//System.out.print(likeList);

							for (MyPageVO vo : list) {
							%>

							<div class="col mb-2 prodarea">
								<div class="card h-100 prodcard">
									<a href="../write/detailBoots.jsp?pno=<%=vo.getPNO()%>"> <!-- Product image-->
										<img class="card-img-top prodimg" src="<%=vo.getIMG()%>"
										alt="<%=vo.getTitle()%>" />
									</a>

									<!-- Product details-->
									<div class="card-body">
										<!-- Product name-->
										<div class="prodtitle" id="ptitle"><%=vo.getTitle()%></div>
										<div class="mdetail"></div>
										<div class="mstatus"><%=vo.getSTATUS()%></div>
										<div class="mybtns">
											<a href="sellNO.jsp?pno=<%=vo.getPNO()%>"><input
												type="button" value="판매완료" /></a> <a
												href="../write/modify.jsp?pno=<%=vo.getPNO()%>"><input
												type="button" value="수정" /></a> <a
												href="deleteOk.jsp?pno=<%=vo.getPNO()%>"><input
												type="button" value="삭제" /></a>
										</div>
									</div>
								</div>
							</div>


							<%
							}
							%>

						</div>
					</div>
					<div id="page_control">
						<%
					if (sellCount != 0) {
						////////////////////////////////////////////////////////////////
						// 페이징 처리
						// 전체 페이지수 계산
						// 
						int pageCount = sellCount / pageSize + (sellCount % pageSize == 0 ? 0 : 1);

						// 한 페이지에 보여줄 페이지 블럭
						int pageBlock = 8;

						// 한 페이지에 보여줄 페이지 블럭 시작번호 계산
						int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;

						// 한 페이지에 보여줄 페이지 블럭 끝 번호 계산
						int endPage = startPage + pageBlock - 1;
						if (endPage > pageCount) {
							endPage = pageCount;
						}
					%>

						<%
					if (startPage > pageBlock) {
					%>
						<a href="mypage.jsp?pageNum=<%=startPage - pageBlock%>">Prev</a>
						<%
					}
					%>

						<%
					for (int i = startPage; i <= endPage; i++) {
					%>
						<a href="mypage.jsp?pageNum=<%=i%>"><%=i%></a>
						<%
					}
					%>

						<%
					if (endPage < pageCount) {
					%>
						<a href="mypage.jsp?pageNum=<%=startPage + pageBlock%>">Next</a>
						<%
					}
					%>
						<%
					}
					%>
					</div>
				</section>
			</div>

			<div id="tabs-2">
				<!-- 관심목록  -->
				<section style="font-family: 'godo';">
					<div class="container px-4 px-lg-5 mt-5">
						<div
							class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">


							<%
				ArrayList<MyPageVO> list4 = dao.likeAll(user.getMno(), startRow, pageSize);

				for (MyPageVO vo : list4) {
				%>

							<div class="col mb-2 prodarea">
								<div class="card h-100 prodcard">
									<a href="../write/detailBoots.jsp?pno=<%=vo.getPNO()%>"> <!-- Product image-->
										<img class="card-img-top prodimg" src="<%=vo.getIMG()%>"
										alt="<%=vo.getTitle()%>" onclick="likeClick(<%=vo.getPNO()%>)" />
									</a>
									<div>
										<img src="../images/like.png" class="likebtn"
											id="<%=vo.getPNO()%>" alt=""
											onclick="likeClick(<%=vo.getPNO()%>)" />
									</div> 
									
									<input type="hidden" name="pno" id="pno" value="" />

									<!-- Product details-->
									<div class="card-body">
										<!-- Product name-->
										<div class="prodtitle" id="ptitle"><%=vo.getTitle()%></div>
										<div class="mdetail"></div>
										<div class="mstatus"><%=vo.getSTATUS()%></div>

									</div>
								</div>
							</div>



							<%
				}
				%>
						</div>
					</div>

					<div id="page_control">
						<%
					if (likeCount != 0) {
						////////////////////////////////////////////////////////////////
						// 페이징 처리
						// 전체 페이지수 계산
						// 
						int pageCount = likeCount / pageSize + (likeCount % pageSize == 0 ? 0 : 1);

						// 한 페이지에 보여줄 페이지 블럭
						int pageBlock = 10;

						// 한 페이지에 보여줄 페이지 블럭 시작번호 계산
						int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;

						// 한 페이지에 보여줄 페이지 블럭 끝 번호 계산
						int endPage = startPage + pageBlock - 1;
						if (endPage > pageCount) {
							endPage = pageCount;
						}
					%>

						<%
					if (startPage > pageBlock) {
					%>
						<a href="mypage.jsp?pageNum=<%=startPage - pageBlock%>">Prev</a>
						<%
					}
					%>

						<%
					for (int i = startPage; i <= endPage; i++) {
					%>
						<a href="mypage.jsp?pageNum=<%=i%>"><%=i%></a>
						<%
					}
					%>

						<%
					if (endPage < pageCount) {
					%>
						<a href="mypage.jsp?pageNum=<%=startPage + pageBlock%>">Next</a>
						<%
					}
					%>
						<%
					}
					%>
					</div>
			</div>
			<div id="tabs-3">
				<!--구매목록  -->
				<section style="font-family: 'godo';">
					<div class="container px-4 px-lg-5 mt-5">
						<div
							class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">


							<%
				ArrayList<MyPageVO> list2 = dao.buyAll(user.getMno(), startRow, pageSize);

				for (MyPageVO vo : list2) {
				%>

							<div class="col mb-2 prodarea">
								<div class="card h-100 prodcard">
									<a href="../write/detailBoots.jsp?pno=<%=vo.getPNO()%>"> 
									<!-- Product image-->
										<img class="card-img-top prodimg" src="<%=vo.getIMG()%>"
										alt="<%=vo.getTitle()%>" />
									</a>

									<!-- Product details-->
									<div class="card-body">
										<!-- Product name-->
										<div class="prodtitle" id="ptitle"><%=vo.getTitle()%></div>
										<div class="mdetail"></div>
										<div class="mstatus"><%=vo.getSTATUS()%></div>

									</div>
								</div>
							</div>



							<%
				}
				%>
						</div>
					</div>
				
				<div id="page_control">
					<%
					if (buyCount != 0) {
						////////////////////////////////////////////////////////////////
						// 페이징 처리
						// 전체 페이지수 계산
						// 
						int pageCount = buyCount / pageSize + (buyCount % pageSize == 0 ? 0 : 1);

						// 한 페이지에 보여줄 페이지 블럭
						int pageBlock = 10;

						// 한 페이지에 보여줄 페이지 블럭 시작번호 계산
						int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;

						// 한 페이지에 보여줄 페이지 블럭 끝 번호 계산
						int endPage = startPage + pageBlock - 1;
						if (endPage > pageCount) {
							endPage = pageCount;
						}
					%>

					<%
					if (startPage > pageBlock) {
					%>
					<a href="mypage.jsp?pageNum=<%=startPage - pageBlock%>">Prev</a>
					<%
					}
					%>

					<%
					for (int i = startPage; i <= endPage; i++) {
					%>
					<a href="mypage.jsp?pageNum=<%=i%>"><%=i%></a>
					<%
					}
					%>

					<%
					if (endPage < pageCount) {
					%>
					<a href="mypage.jsp?pageNum=<%=startPage + pageBlock%>">Next</a>
					<%
					}
					%>
					<%
					}
					%>
				</div>

			</div>
			<div id="tabs-4">
				<!-- 판매완료  -->
				<section style="font-family: 'godo';">
					<div class="container px-4 px-lg-5 mt-5">
						<div
							class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">


							<%
				ArrayList<MyPageVO> list3 = dao.sellComplete(user.getMno(), startRow, pageSize);

				for (MyPageVO vo : list3) {
				%>

							<div class="col mb-2 prodarea">
								<div class="card h-100 prodcard">
									<a href="../write/detailBoots.jsp?pno=<%=vo.getPNO()%>"> <!-- Product image-->
										<img class="card-img-top prodimg" src="<%=vo.getIMG()%>"
										alt="<%=vo.getTitle()%>" onclick="likeClick(<%=vo.getPNO()%>)" />
									</a>

									<!-- Product details-->
									<div class="card-body">
										<!-- Product name-->
										<div class="prodtitle" id="ptitle"><%=vo.getTitle()%></div>
										<div class="mdetail"></div>
										<div class="mstatus"><%=vo.getSTATUS()%></div>
										<a href="sellOK.jsp?pno=<%=vo.getPNO() %>"><input type="button" value="판매중" /></a>

									</div>
								</div>
							</div>



							<%
				}
				%>
						</div>
					</div>
					<div id="page_control">
						<%
					if (sellOkCount != 0) {
						////////////////////////////////////////////////////////////////
						// 페이징 처리
						// 전체 페이지수 계산
						// 
						int pageCount = sellOkCount / pageSize + (sellOkCount % pageSize == 0 ? 0 : 1);

						// 한 페이지에 보여줄 페이지 블럭
						int pageBlock = 10;

						// 한 페이지에 보여줄 페이지 블럭 시작번호 계산
						int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;

						// 한 페이지에 보여줄 페이지 블럭 끝 번호 계산
						int endPage = startPage + pageBlock - 1;
						if (endPage > pageCount) {
							endPage = pageCount;
						}
					%>

						<%
					if (startPage > pageBlock) {
					%>
						<a href="mypage.jsp?pageNum=<%=startPage - pageBlock%>">Prev</a>
						<%
					}
					%>

						<%
					for (int i = startPage; i <= endPage; i++) {
					%>
						<a href="mypage.jsp?pageNum=<%=i%>"><%=i%></a>
						<%
					}
					%>

						<%
					if (endPage < pageCount) {
					%>
						<a href="mypage.jsp?pageNum=<%=startPage + pageBlock%>">Next</a>
						<%
					}
					%>
						<%
					}
					%>
					</div>
			</div>
		</div>
	</div>
	<br />
	<br />
	<br />
	<!-- Footer-->
	<style>
.m-0>p {
	font-size: 16px;
}

.m-0>span {
	font-size: 12px;
}

.m-0>.container {
	padding-right: var(- -bs-gutter-x, 0rem);
	padding-left: var(- -bs-gutter-x, 5rem);
}

footer {
	padding: 50px;
	border-top: 1px solid rgb(229, 229, 229);
}
</style>
	<footer class="m-0">
		<div class="container" style="width: 1024px; display: flex;">
			<div class="m-0 text-left"
				style="display: flex; flex-direction: column; width: 100%;">
				<p>알쓸장터(주) 사업자 정보</p>
				<span>created by team spring, located at Seoul Korea</span><br /> <span>대표이사
					: 홍수민</span> <span>사업자 등록번호 : 199388204729 | 통신판매업신고 :
					2022-서울종로-2768</span> <span>E-mail : helpme@google.com |
					alsslemail@google.com</span> <span>주소 : 서울특별시 종로구, 통의동 8 | Fax :
					02-3438-4995</span>
			</div>

			<div class="m-0 text-left"
				style="display: flex; flex-direction: column; width: 100%;">
				<p>Customer Service : 1588 - 2939</p>
				<span>운영시간 : 9시 ~ 18시 (주말 / 공휴일 휴무, 점심시간 13시 ~ 14시)</span>

			</div>
		</div>
		<br />
		<p class="m-0 text-center" style="font-size: 12px;">Copyright
			&copy; Your Website 2022</p>
	</footer>
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="../resources/js/scripts.js"></script>


</body>
</html>