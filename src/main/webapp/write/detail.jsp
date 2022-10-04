<%@page import="dao.LikeDAO"%>
<%@page import="vo.LikeVO"%>
<%@page import="javax.swing.plaf.basic.BasicInternalFrameTitlePane.SystemMenuBar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="vo.ImageVO"%>
<%@page import="dao.ImageDAO"%>
<%@page import="vo.ProductVO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="vo.LoginVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../resources/css/detail.css?ver=1" />
<link rel="stylesheet" href="../resources/css/nav.css" />
<jsp:include page="../main_login/mainHead.jsp"/>
<style>
	
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
	<% 
		int count1=1;
		int count2=1;
		Object obj = session.getAttribute("logvo");
		if(obj != null){
		LoginVO vo = (LoginVO)obj;
		
		int pno = Integer.parseInt(request.getParameter("pno"));
		ProductDAO dao = new ProductDAO();
		ProductVO pvo = dao.selectOne(pno);
		
		ImageDAO idao = new ImageDAO();
		ArrayList<ImageVO> imgList = idao.imgSelect(pno);
		
		LikeDAO ldao = new LikeDAO();
		LikeVO lvo = ldao.isLike(vo.getMno(), pvo.getPno());
		//System.out.println(lvo.getMno()); 
		//System.out.println(lvo.getPno()); 
	%>
	
	var count=0;
	var dotcount=1;

	var slideIndex = 1;
	showSlides(slideIndex);
	
	// 다음, 이전 제어
	function plusSlides(n) {
	  showSlides(slideIndex += n);
	}
	
	// 사진 제어
	function currentSlide(n) {
	  showSlides(slideIndex = n);
	}
	
	function showSlides(n) {
	  var i;
	  var slides = document.getElementsByClassName("mySlides");
	  var dots = document.getElementsByClassName("dot");
	  if (n > slides.length) {slideIndex = 1} 
	  if (n < 1) {slideIndex = slides.length}
	  for (i = 0; i < slides.length; i++) {
	      slides[i].style.display = "none"; 
	  }
	  for (i = 0; i < dots.length; i++) {
	      dots[i].className = dots[i].className.replace(" active", "");
	  }
	  slides[slideIndex-1].style.display = "block"; 
	  dots[slideIndex-1].className += " active";
	}
	
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
					var picFile = event.target;
					var div = document.createElement("div");
					var span = document.createElement("span");
					div.className="mySlides";
					span.className="dot";
					span.id="dot"+dotcount;
					console.log(dotcount);
					span.onclick=function(){
						var testString = span.id;
						var regex = /[^0-9]/g;				// 숫자가 아닌 문자열을 선택하는 정규식
						var result = testString.replace(regex, "");	// 원래 문자열에서 숫자가 아닌 모든 문자열을 빈 문자로 변경
						currentSlide(result);
					}
					if(count==0){div.style="display:block";}
					div.innerHTML = "<img onclick='viewimg("+count+");' id='mySlidesimg"+count+"' class='mySlidesimg' src='" + picFile.result + "'" + "title='" + picFile.name + "'/>";
					output.insertBefore(div, null);
					outputdot.insertBefore(span, null);
					count++;
					dotcount++;
 	            });
 	            //Read the image
				picReader.readAsDataURL(file);
 	        }
 	    } else {
 	        console.log("Your browser does not support File API");
 	    }
 	}

 	document.getElementById('select_img').addEventListener('change', handleFileSelect, false);
 	
 	//이미지 클릭시 새창에서 원본사진
 	function viewimg(i){
 		var win = window.open();
 	    win.document.write('<iframe src="' + document.getElementById("mySlidesimg"+i).src  + '" frameborder="0" style="border:0; top:0px; left:0px; bottom:0px; right:0px; width:100%; height:100%;" allowfullscreen></iframe>');
 	}
 	
 	function change_action(val){
 		if(val=="마이페이지"){
 			document.header.action="mypage.jsp";
 			document.header.submit();
 		}
 		if(val=="판매하기"){
 			document.header.action="write.jsp";
 			document.header.submit();
 		}
 		if(val=="로그아웃"){
 			document.header.action="main.jsp";
 			document.header.submit();
 		}
 		if(val=="알쓸톡"){
 			document.header.action="alssleTalk.jsp";
 			document.header.submit();
 		}
 	}
 	
 	function dotSelect(id){
 			document.getElementById(id);
			var testString = id;
			var regex = /[^0-9]/g;				// 숫자가 아닌 문자열을 선택하는 정규식
			var result = testString.replace(regex, "");	// 원래 문자열에서 숫자가 아닌 모든 문자열을 빈 문자로 변경
			currentSlide(parseInt(result));
			slideIndex=parseInt(result);
 	}
 	
 	function likeClick() {
 		$.ajax({
			type: "POST",
			url : "detailServlet",
			data: {
				mno : <%= vo.getMno()%>,
				pno : <%= pvo.getPno()%>,
			},
			success : function(result){
				//alert("전송")
				if(result == 1){
					$(".likebtn").attr('src','../images/like.png');
				}else if(result == 0){
					$(".likebtn").attr("src","../images/nolike.png");
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
    	
	<jsp:include page="../main_login/mainNav.jsp"/>
	<div class=container>
		<!-- header form -->
<%-- 		<form action="search.jsp" method="get" name="header">
			<!-- header -->
			<div id=header>
				<img src="../images/icon.png" alt="" id="icon"/>
				<input type="text" name="search" id="search" placeholder="검색창"/>
				<input type="submit" value="검색" />
				<input type="button" value="알쓸톡" id="talk" onclick="change_action(this.value);"/>
				<select name="" id="userOption" onchange="change_action(this.value);">
					<option value="" disabled selected><%= vo.getNickname()  %>님 환영합니다</option>
					<option value="마이페이지">마이페이지</option>
					<option value="판매하기">판매하기</option>
					<option value="로그아웃">로그아웃</option>
				</select>
			</div>
		</form> --%>
		
		<!-- body form -->
		<form action="modifyOK.jsp" method="get" enctype="multipart/form-data" style="margin-top:50px">
			<div class="imgbox">
				<input type="text" name="mno" value="<%= vo.getMno() %>" style="display:none"></input>
				<input type="text" name="pno" value="<%= pvo.getPno() %>" style="display:none"></input>
				<!-- 상품 사진 -->
				<div class="slideshow-container">
					<output id="result"/>
						<%
							for(ImageVO ivo : imgList){
								if(count1==1){
						%>
								<div class="mySlides" style="display:block">
							    	<img src="<%= ivo.getImg() %>" alt="" id="mySlidesimg<%= count1 %>" class="mySlidesimg" onclick="viewimg(<%= count1 %>)"/>
								</div>
						<%
									count1++;
								}else{
						%>
									<div class="mySlides">
								    	<img src="<%= ivo.getImg() %>" alt="" id="mySlidesimg<%= count1 %>" class="mySlidesimg" onclick="viewimg(<%= count1 %>)"/>
									</div>
						<%
									count1++;
									}
							}
						%>
						<div class="likebtndiv">
						<%
							try{
								
								if(lvo.getMno()==vo.getMno() && lvo.getPno()==pvo.getPno()){
						%>
									<img src="../images/like.png" class="likebtn" alt="" onclick="likeClick()"/>
						<% 
								}else{
								
						%>
									<img src="../images/nolike.png" class="likebtn" alt="" onclick="likeClick()"/>
						<%
								}
							}catch(NullPointerException e){
								%>
									<img src="../images/nolike.png" class="likebtn" alt="" onclick="likeClick()"/>
								<%
							}
						%>
						</div>
					</output>
						<!-- 다음, 이전 이미지 버튼 -->
					<a class="prev" onclick="plusSlides(-1)">&#10094;</a>
					<a class="next" onclick="plusSlides(1)">&#10095;</a>
					<!-- 현재 이미지를 알려주는 하단의 점 -->
				</div>
				<div class="dotCollection" style="height:30px;">
					<output id="dotresult"/>
						<%
							for(ImageVO ivo : imgList){
						%>
							<span class="dot" id="dot<%= count2 %>" onclick="dotSelect(this.id);"></span>
						<%
								count2++;
							}
						%>
					</output> 
				</div>
				<div class="uploadbtn">
				<a href="../chatting/chatCheck.jsp?pno=<%= pvo.getPno() %>">
					<label class="input-file-button">
						알쓸톡하기
					</label>
				</a>
				</div>
			</div>
			
			
			
			<!-- 정보선택칸 -->
			<div class="selectInfo">
				<div>
					<!-- 카테고리 -->
					<div class="selectInfoDivSelect">카테고리</div>
					<div class="inputdiv" id="category" ><%= pvo.getCategory() %></div>
				</div>
				<div>
					<!-- 제목 -->
					<div class="selectInfoDivSelect">제목</div>
					<div class="inputdiv" id="title" ><%= pvo.getTitle() %></div>
				</div>
				
				<div>
					<!-- 가격 -->
					<div class="selectInfoDivSelect">가격</div>
					<div class="inputdiv" id="price" ><%= pvo.getPrice() %></div>
				</div>
				
				<div>
					<!-- 배송비 -->
					<div class="selectInfoDivSelect">택배비</div>
					<div class="inputdiv" id="tradeFee" >택배비<%= pvo.getFee() %></div>
				</div>

				<div>
					<!-- 거래지역 -->
					<div class="selectInfoDivSelect">거래지역</div>
					<div class="inputdiv" id="tradeLoc" ><%= pvo.getLoc() %></div>
				</div>
				
				<div>
					<!-- 직거래 여부 -->
					<div class="selectInfoDivSelect">거래방법</div>
					<div class="inputdiv" id="tradeWay" ><%= pvo.getTrade() %></div>
				</div>
				
			</div>
			
			<!-- 상세설명 및 등록버튼 -->
			<div class="detail">
				<div id="detail" style="border:1px solid black;"><%= pvo.getPdetail() %></div>
			</div>
			<%
				if(vo.getEmail().equals("master")){
					
			%>
					<div class="master">
						<a href="../write/deleteOk.jsp?pno=<%= pvo.getPno() %>">
							<label class="input-file-button">
								삭제
							</label>
						</a>
					</div>
			<%
				}
			%>
		</form>
	</div>
	<div style="margin-top : 50px">
		<jsp:include page="../main_login/mainFooter.jsp"/>
	</div>
	<script>
	<%
		}else{
			int pno = Integer.parseInt(request.getParameter("pno"));
			ProductDAO dao = new ProductDAO();
			ProductVO pvo = dao.selectOne(pno);
			
			ImageDAO idao = new ImageDAO();
			ArrayList<ImageVO> imgList = idao.imgSelect(pno);
		%>
		
		var count=0;
		var dotcount=1;

		var slideIndex = 1;
		showSlides(slideIndex);
		
		// 다음, 이전 제어
		function plusSlides(n) {
		  showSlides(slideIndex += n);
		}
		
		// 사진 제어
		function currentSlide(n) {
		  showSlides(slideIndex = n);
		}
		
		function showSlides(n) {
		  var i;
		  var slides = document.getElementsByClassName("mySlides");
		  var dots = document.getElementsByClassName("dot");
		  if (n > slides.length) {slideIndex = 1} 
		  if (n < 1) {slideIndex = slides.length}
		  for (i = 0; i < slides.length; i++) {
		      slides[i].style.display = "none"; 
		  }
		  for (i = 0; i < dots.length; i++) {
		      dots[i].className = dots[i].className.replace(" active", "");
		  }
		  slides[slideIndex-1].style.display = "block"; 
		  dots[slideIndex-1].className += " active";
		}
		
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
						var picFile = event.target;
						var div = document.createElement("div");
						var span = document.createElement("span");
						div.className="mySlides";
						span.className="dot";
						span.id="dot"+dotcount;
						console.log(dotcount);
						span.onclick=function(){
							var testString = span.id;
							var regex = /[^0-9]/g;				// 숫자가 아닌 문자열을 선택하는 정규식
							var result = testString.replace(regex, "");	// 원래 문자열에서 숫자가 아닌 모든 문자열을 빈 문자로 변경
							currentSlide(result);
						}
						if(count==0){div.style="display:block";}
						div.innerHTML = "<img onclick='viewimg("+count+");' id='mySlidesimg"+count+"' class='mySlidesimg' src='" + picFile.result + "'" + "title='" + picFile.name + "'/>";
						output.insertBefore(div, null);
						outputdot.insertBefore(span, null);
						count++;
						dotcount++;
	 	            });
	 	            //Read the image
					picReader.readAsDataURL(file);
	 	        }
	 	    } else {
	 	        console.log("Your browser does not support File API");
	 	    }
	 	}

	 	document.getElementById('select_img').addEventListener('change', handleFileSelect, false);
	 	
	 	//이미지 클릭시 새창에서 원본사진
	 	function viewimg(i){
	 		var win = window.open();
	 	    win.document.write('<iframe src="' + document.getElementById("mySlidesimg"+i).src  + '" frameborder="0" style="border:0; top:0px; left:0px; bottom:0px; right:0px; width:100%; height:100%;" allowfullscreen></iframe>');
	 	}
	 	
	 	function change_action(val){
	 		if(val=="마이페이지"){
	 			document.header.action="mypage.jsp";
	 			document.header.submit();
	 		}
	 		if(val=="판매하기"){
	 			document.header.action="write.jsp";
	 			document.header.submit();
	 		}
	 		if(val=="로그아웃"){
	 			document.header.action="main.jsp";
	 			document.header.submit();
	 		}
	 		if(val=="알쓸톡"){
	 			document.header.action="alssleTalk.jsp";
	 			document.header.submit();
	 		}
	 	}
	 	
	 	function dotSelect(id){
	 			document.getElementById(id);
				var testString = id;
				var regex = /[^0-9]/g;				// 숫자가 아닌 문자열을 선택하는 정규식
				var result = testString.replace(regex, "");	// 원래 문자열에서 숫자가 아닌 모든 문자열을 빈 문자로 변경
				currentSlide(parseInt(result));
				slideIndex=parseInt(result);
	 	}

	</script>
	</head>
	<body>
	    	
		<jsp:include page="../main_login/mainNav.jsp"/>
		<div class=container>
			<!-- header form -->
	<%-- 		<form action="search.jsp" method="get" name="header">
				<!-- header -->
				<div id=header>
					<img src="../images/icon.png" alt="" id="icon"/>
					<input type="text" name="search" id="search" placeholder="검색창"/>
					<input type="submit" value="검색" />
					<input type="button" value="알쓸톡" id="talk" onclick="change_action(this.value);"/>
					<select name="" id="userOption" onchange="change_action(this.value);">
						<option value="" disabled selected><%= vo.getNickname()  %>님 환영합니다</option>
						<option value="마이페이지">마이페이지</option>
						<option value="판매하기">판매하기</option>
						<option value="로그아웃">로그아웃</option>
					</select>
				</div>
			</form> --%>
			
			<!-- body form -->
			<form action="modifyOK.jsp" method="get" enctype="multipart/form-data" style="margin-top:50px">
				<div class="imgbox">
					<input type="text" name="pno" value="<%= pvo.getPno() %>" style="display:none"></input>
					<!-- 상품 사진 -->
					<div class="slideshow-container">
						<output id="result"/>
							<%
								for(ImageVO ivo : imgList){
									if(count1==1){
							%>
									<div class="mySlides" style="display:block">
								    	<img src="<%= ivo.getImg() %>" alt="" id="mySlidesimg<%= count1 %>" class="mySlidesimg" onclick="viewimg(<%= count1 %>)"/>
									</div>
							<%
										count1++;
									}else{
							%>
										<div class="mySlides">
									    	<img src="<%= ivo.getImg() %>" alt="" id="mySlidesimg<%= count1 %>" class="mySlidesimg" onclick="viewimg(<%= count1 %>)"/>
										</div>
							<%
										count1++;
										}
								}
							%>
							<div class="likebtndiv">
								<img src="../images/nolike.png" class="likebtn" alt=""/>
							</div>
						</output>
							<!-- 다음, 이전 이미지 버튼 -->
						<a class="prev" onclick="plusSlides(-1)">&#10094;</a>
						<a class="next" onclick="plusSlides(1)">&#10095;</a>
						<!-- 현재 이미지를 알려주는 하단의 점 -->
					</div>
					<div class="dotCollection" style="height:30px;">
						<output id="dotresult"/>
							<%
								for(ImageVO ivo : imgList){
							%>
								<span class="dot" id="dot<%= count2 %>" onclick="dotSelect(this.id);"></span>
							<%
									count2++;
								}
							%>
						</output> 
					</div>
					<div class="uploadbtn">
					<a href="../chatting/chatCheck.jsp?pno=<%= pvo.getPno() %>">
						<label class="input-file-button">
							알쓸톡하기
						</label>
					</a>
					</div>
				</div>
				
				
				
				<!-- 정보선택칸 -->
				<div class="selectInfo">
					<div>
						<!-- 카테고리 -->
						<div style="width:5rem; float:left;">카테고리</div>
						<div class="inputdiv" id="category" ><%= pvo.getCategory() %></div>
					</div>
					<div>
						<!-- 제목 -->
						<div style="width:5rem; float:left;">제목</div>
						<div class="inputdiv" id="title" ><%= pvo.getTitle() %></div>
					</div>
					
					<div>
						<!-- 가격 -->
						<div style="width:5rem; float:left;">가격</div>
						<div class="inputdiv" id="price" ><%= pvo.getPrice() %></div>
					</div>
					
					<div>
						<!-- 거래지역 -->
						<div style="width:5rem; float:left;">거래지역</div>
						<div class="inputdiv" id="tradeLoc" ><%= pvo.getLoc() %></div>
					</div>
					
					<div>
						<!-- 직거래 여부 -->
						<div style="width:5rem; float:left;">거래방법</div>
						<div class="inputdiv" id="tradeWay" ><%= pvo.getTrade() %></div>
					</div>
					
					<div>
						<!-- 배송비 -->
						<div style="width:5rem; float:left;">택배비</div>
						<div class="inputdiv" id="tradeFee" ><%= pvo.getFee() %></div>
					</div>
				</div>
				
				<!-- 상세설명 및 등록버튼 -->
				<div class="detail">
					<div id="detail" style="border:1px solid black;"><%= pvo.getPdetail() %></div>
				</div>
			</form>
		</div>
		<div style="margin-top : 50px">
			<jsp:include page="../main_login/mainFooter.jsp"/>
		</div>
	<%
		}
	%>
</body>
</html>