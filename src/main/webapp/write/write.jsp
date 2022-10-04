<%@page import="dao.ProductDAO"%>
<%@page import="vo.LoginVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" href="../resources/css/write.css" />
<link rel="stylesheet" href="../resources/css/nav.css" />
<jsp:include page="../main_login/mainHead.jsp"/>
<style type="text/css">
	@font-face {
		font-family : 'godo';
		src : url('../resources/css/GodoB.woff') format('woff');
	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
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
			 	    	//사진 10장 제한
			 	    	if(count<10){
							var picFile = event.target;
							var div = document.createElement("div");
							var span = document.createElement("span");
							div.className="mySlides";
							span.className="dot";
							span.id="dot"+dotcount;
							span.onclick=function(){
								var testString = span.id;
								var regex = /[^0-9]/g;				// 숫자가 아닌 문자열을 선택하는 정규식
								var result = testString.replace(regex, "");	// 원래 문자열에서 숫자가 아닌 모든 문자열을 빈 문자로 변경
								currentSlide(parseInt(result));
								slideIndex=parseInt(result);
							}
							if(count==0){div.style="display:block";}
							div.innerHTML = "<input type='text' style='display:none' name='imgsrc"+count+"' value='" + picFile.result+"'  />"+"<img onclick='viewimg("+count+");' name='img"+count+"' id='mySlidesimg"+count+"' class='mySlidesimg' src='" + picFile.result + "'" + "title='" + picFile.name + "'/>";
							output.insertBefore(div, null);
							outputdot.insertBefore(span, null);
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
 	
 	function resetimg(){
 		$(".mySlides").remove();
 		$(".dot").remove();
 		count=0;
 		dotcount=1;
 	}
 	
</script>
</head>
<body>
	<% 
		Object obj = session.getAttribute("logvo");
		if(obj != null){
		LoginVO vo = (LoginVO)obj;
	%>
    	
	<jsp:include page="../main_login/mainNav.jsp"/>
	<div class=container style="font-family:'godo';">
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
		<form action="writeOk.jsp" method="post" style="margin-top:50px" >
			<div class="inputContainer">
				<div class="imgbox">
					<input type="text" name="mno" value="<%= vo.getMno() %>" style="display:none"></input>
					<!-- 상품 사진 -->
					<div class="slideshow-container">
							<output id="result"/>
							</output>
							<!-- 다음, 이전 이미지 버튼 -->
						<a class="prev" onclick="plusSlides(-1)">&#10094;</a>
						<a class="next" onclick="plusSlides(1)">&#10095;</a>
						<!-- 현재 이미지를 알려주는 하단의 점 -->
						<div class="resetdiv">
							<label class="reset-button" for="reset_image">
								<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" fill="currentColor" class="bi bi-arrow-counterclockwise" viewBox="0 0 16 16">
								  <path fill-rule="evenodd" d="M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2v1z"/>
								  <path d="M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466z"/>
								</svg>
							</label>
							<input onclick="resetimg();" type="button" id="reset_image" style="display:none"/>
						</div>
					</div>
					<div class="dotCollection" style="height:30px;">
						<output id="dotresult"/>
						</output> 
					</div>
	
					<div class="uploadbtn">
					<label class="input-file-button" for="select_img">
						업로드
					</label>
						<input accept=".gif, .jpg, .png, .jfif" onchange="handleFileSelect();" type="file" 
								id="select_img" multiple="multiple" name="imageFiles" style="display:none"/>
					</div>
				</div>
				
				
				
				<!-- 정보선택칸 -->
				<div class="selectInfo">
					<div>
						<!-- 카테고리 -->
						<div class="selectInfoDivSelect">카테고리</div>
						<select id="category" name="category">
							<option value="" disabled selected>카테고리</option>
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
					<div>
						<!-- 제목 -->
						<div class="selectInfoDiv">제목</div>
						<input type="text" class="inputdiv" name="title" id="title" placeholder="제목"/>
					</div>
					
					<div>
						<!-- 가격 -->
						<div class="selectInfoDiv">가격</div>
						<input type="text" class="inputdiv"  name="price" id="price" placeholder="가격"/>
					</div>
					
					<div>
						<!-- 배송비 -->
						<div class="selectInfoDivSelect">택배비</div>
						<input type="radio" name="deliveryFee" id="deliveryFeeOn" value="택배비포함" /> 택배비 포함 
						<input type="radio" name="deliveryFee" id="deliveryFeeOff" value="택배비미포함"/> 택배비 미포함 
					</div>
	
					<div>
						<!-- 거래지역 -->
						<div class="selectInfoDiv">거래지역</div>
						<input type="text" class="inputdiv"  name="tradeArea" id="tradeArea" placeholder="거래지역"/>
					</div>
					
					<div>
						<!-- 직거래 여부 -->
						<div class="selectInfoDivSelect">거래방법</div>
						<input type="checkbox" name="direct" id="direct" value="직거래"/> 직거래 
						<input type="checkbox" name="delivery" id="delivery" value="택배"/> 택배 
					</div>
				</div>
			</div>
			
			<!-- 상세설명 및 등록버튼 -->
			<div class="detail">
				<textarea name="detail" id="detail" placeholder="상세설명" /></textarea>
				<div class="submitbtndiv">
				<label class="input-file-button" for="submitbtn">
					등록하기
				</label>
					<input type="submit" value="등록하기" id="submitbtn" style="display:none"/>
				</div>
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