<%@page import="dao.UserDAO"%>
<%@page import="org.apache.catalina.ssi.SSIConditional"%>
<%@page import="vo.LoginVO"%>
<%@page import="vo.MyPageVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
//LoginVO user = (LoginVO) session.getAttribute("logvo");
String mum = request.getParameter("mno");
int mno = Integer.parseInt(mum);

UserDAO dao = new UserDAO();
LoginVO user = dao.userone(mno);

////////////////////////////////////////////////////
// sql 로 질의했을 때 탭에 따른 상품 수

// 판매 상품 갯수, 좋아요 갯수, 구매 갯수, 판매완료 갯수
int sellCount = dao.getSellCount(user.getMno());

System.out.println("SellCount : " + sellCount);

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
<jsp:include page="../main_login/mainHead.jsp" />
<style type = "text/css">
/*페이징 css  */
#page_control {
	font-weight: bold;
	font-size: 20px;
	text-align: center;
	margin-bottom: 30px;
}

#userImg {
	width: 400px;
	height: 400px;
}

#data {
	width: 65.2%;
	height: 40px;
	position: relative;
	margin-bottom: 10px;
	border: none;
	font-family : 'godo';
}

#data2 {
	width: 65.2%;
	height: 40px;
	position: relative;
	margin-bottom: 10px;
	border: none;
	font-family : 'godo';
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
	font-weight: bold;
}

#pno {
	visibility: hidden;
}

#ptitle {
font-family : 'godo';
font-size : 16px;
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

#maintt{
		text-align : center;
		font-size : 25px;
		font-family : 'godo';
	}
	
	@font-face {
	  font-family : 'godo';
	  src : url('../resources/css/GodoB.woff') format('woff');
	}

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
.data3{
	width: 65.2%;
    height: 300px;
    resize: none;
    padding: 0.5rem;
    font-family : 'godo';
}
a{
	color:black !important;
}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
<script>
	$(function() {
		$("#tabs").tabs();

	});

	var count = 0;
	var dotcount = 1;

	function handleFileSelect() {
		//Check File API support
		if (window.File && window.FileList && window.FileReader) {

			var files = event.target.files; //FileList object
			var output = document.getElementById("result");
			var outputdot = document.getElementById("dotresult");

			for (var i = 0; i < files.length; i++) {
				var file = files[i];
				//Only pics
				if (!file.type.match('image'))
					continue;

				var picReader = new FileReader();
				picReader
						.addEventListener(
								"load",
								function(event) {
									if (count < 1) {
										var picFile = event.target;

										$("#userImg").remove();

										var div = document.createElement("div");
										div.className = "mySlides";
										if (count == 0) {
											div.style = "display:block";
										}
										div.innerHTML = "<input type='text' style='display:none' name='imgsrc"+count+"' value='" + picFile.result+"'  />"
												+ "<img onclick='viewimg("
												+ count
												+ ");' name='img"
												+ count
												+ "' id='mySlidesimg"
												+ count
												+ "' class='mySlidesimg' src='"
												+ picFile.result
												+ "'"
												+ "title='"
												+ picFile.name
												+ "'/>";
										output.insertBefore(div, null);
										count++;
										dotcount++;
									}
								});
				//Read the image
				picReader.readAsDataURL(file);

			}
		} else {
			console.log("Your browser does not support File API");
		}
	}

	//이미지 클릭시 새창에서 원본사진
	function viewimg(i) {
		var win = window.open();
		win.document
				.write('<iframe src="'
						+ document.getElementById("mySlidesimg" + i).src
						+ '" frameborder="0" style="border:0; top:0px; left:0px; bottom:0px; right:0px; width:100%; height:100%;" allowfullscreen></iframe>');
	}

	function resetimg() {
		$(".mySlides").remove();
		$(".dot").remove();
		count = 0;
		dotcount = 1;
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
					<input type="text" name="mno" value="<%=user.getMno()%>"
						style="display: none"></input>
					<!-- v 사진 -->
					<div class="slideshow-container" style="float:left;">
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
					<div>
						<input type="text" name="deta" id="data"
								value="닉네임 : <%=user.getNickname()%>" disabled /> 
						<input type="text" name="deta" id="data2"
								value="총상품수 : <%=dao.getSellCount(user.getMno())%>" disabled />
						<textarea class="data3" name="introduction"><%= user.getMdetail()%></textarea>

					</div>
				</div>
		</form>

			<!--판매목록  -->
				<section style="font-family : 'godo';">
				<div id = "maintt"><판매목록></div>
					<div class="container px-4 mt-5">
						<div
							class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">


							<%
							//System.out.println(user.getMno());
							ArrayList<MyPageVO> list = dao.userAll(user.getMno(), startRow, pageSize);

							//	System.out.print(likeList);

							for (MyPageVO vo : list) {
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
				<a
					href="userPage.jsp?mno=<%=mno%>&pageNum=<%=startPage - pageBlock%>">Prev</a>
				<%
				}
				%>

				<%
				for (int i = startPage; i <= endPage; i++) {
				%>
				<a href="userPage.jsp?mno=<%=mno%>&pageNum=<%=i%>"><%=i%></a>
				<%
				}
				%>

				<%
				if (endPage < pageCount) {
				%>
				<a
					href="userPage.jsp?mno=<%=mno%>&pageNum=<%=startPage + pageBlock%>">Next</a>
				<%
				}
				%>
				<%
				}
				%>
			</div>
		</section>
		</div>
	<br />
	<br />
	<br />

	<!-- Footer-->

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