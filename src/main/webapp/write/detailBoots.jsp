<%@page import="vo.MainProdVO"%>
<%@page import="vo.LikeVO"%>
<%@page import="dao.LikeDAO"%>
<%@page import="vo.ImageVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.ImageDAO"%>
<%@page import="vo.ProductVO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="vo.LoginVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" /> -->
        <title>알쓸마켓 상품페이지</title>
        <!-- Favicon-->
        <!-- <link rel="icon" type="image/x-icon" href="../resources/assets/favicon.ico" /> -->
        <!-- Bootstrap icons-->
        <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" /> -->
        <!-- Core theme CSS (includes Bootstrap)-->
        <!-- <link href="../resources/css/style.css" rel="stylesheet" /> -->
        <link href="../resources/css/detailBoots.css" rel="stylesheet" />
        <link href="../resources/css/detail.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
        <jsp:include page="../main_login/mainHead.jsp"/>
        <style type="text/css">
	        @font-face {
		      font-family : 'godo';
		      src : url('../resources/css/GodoB.woff') format('woff');
		    }
	    </style>
	    </head>
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
			dao.plusHits(pno);
			
			ImageDAO idao = new ImageDAO();
			ArrayList<ImageVO> imgList = idao.imgSelect(pno);
			
			LikeDAO ldao = new LikeDAO();
			LikeVO lvo = ldao.isLike(vo.getMno(), pvo.getPno());
			
			ArrayList<Integer> pmem = dao.salesList(pvo.getMno(),pno);
			ProductVO pvo1 = dao.selectOne(pmem.get(0));
			ProductVO pvo2 = dao.selectOne(pmem.get(1));
			ProductVO pvo3 = dao.selectOne(pmem.get(2));
			ProductVO pvo4 = dao.selectOne(pmem.get(3));
			
			ArrayList<ImageVO> imgList1 = idao.imgSelect(pmem.get(0));
			ArrayList<ImageVO> imgList2 = idao.imgSelect(pmem.get(1));
			ArrayList<ImageVO> imgList3 = idao.imgSelect(pmem.get(2));
			ArrayList<ImageVO> imgList4 = idao.imgSelect(pmem.get(3));
			
			ImageVO imgvo1 = imgList1.get(0);
			ImageVO imgvo2 = imgList2.get(0);
			ImageVO imgvo3 = imgList3.get(0);
			ImageVO imgvo4 = imgList4.get(0);
			
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
							var plus = parseInt($(".sc-ZUflv").html())+1;
							$(".sc-ZUflv").html(plus);
						}else if(result == 0){
							$(".likebtn").attr("src","../images/nolike.png");
							var minus = parseInt($(".sc-ZUflv").html())-1;
							$(".sc-ZUflv").html(minus);
						}else{
							//alert("DB error");
							//autoClosingAlert("#warningMessage", 2000)
						}
					}
				})
		 	}
		 	
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
	
	</script>
    <!-- </head> -->
    <body>
        <!-- Navigation-->
        <jsp:include page="../main_login/mainNav.jsp"/>
        <!-- Product section-->
        <section class="py-5" style="font-family:'godo';">
            <div class="container px-4 px-lg-5 my-5">
                <div class="row gx-4 gx-lg-5 align-items-center">
                <form action="modifyOK.jsp" method="get" enctype="multipart/form-data">
       				<div class="imgbox col-md-6-userupdate1">
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
                   		</div>
                    <div class="col-md-6-userupdate2">
                        <h1 class="user-marginbottom" style="font-size:2.0rem; font-family: 'Do Hyeon', sans-serif;"><%= pvo.getTitle() %></h1>
                        <h2 class="display-7 fw-bolder inputdiv">
                            <span><%= pvo.getPrice() %>원</span>
                        </h2>
                        <div class="sc-hqGPoI fBhbVz">
	                        <div class="sc-imAxmJ lfImbI">
	                        	<div class="sc-iWadT haVDIN">
	                        		<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAjhJREFUWAnFl1uPKUEUhbdCxF2Iu7h78f9/ixdexANeSNxCkJnz1ZwSRncrM0OvhK6ufVmrdiu1O/DxD/INq9VKFouFbDYbOR6PEggEJBKJSDqdlkKhIKFQ6FvE1+3pdJL5fC7EHw4HIXU4HJZEIiHZbFZSqdRdXOBaAEHj8VjW6/Wdo5kIBoNSLBalVCppYcxDNJvNNPn5fDaud9dkMimNRkMvxhgvAna7nQyHQ2EVNmBV3W5Xu45GI10tmziq1+v1JBaLaXctANLBYKDLbZPE+MTjcT3cbrdmyurKY+n3+/pRKiImk8nT5MRB/Cw5cfyu4ARqv9/LcrnUN+/8ghNuxcBhI7xcC5xwK7aMX4BbsfX8AtzKa9++Whjcij8WvwC3Yk/6BbiV+TPxQwTcKpPJ+MGtOeFWHBB+PAY44VYctZxu7waccOuzIJ/Pv7UKrB5OoAUopfQ5/a4q0BPAeRHAgG4nl8vpyVd+wQGXwZeM/3f1el2i0aix/fmV3HBc40YAZel0Oq4933Xgs2M6IXKb0pv4GwFM0ny22+1Lv2ccf3Pl195qtW56QZPvTgAG9mez2fwTEZCTy6kjhstRAAba6FqtxvBXIAe53OAqgADeASqVilvsw3liyeEFTwEElstl/fFK4mSzjXsogOSshBcRW+BrWzkrARBXq1UrEZDjawtrAUYEpXXDs+TkeUoAAZTWScRPyMnn/JqLxQPm+U6nU+2FIDPnEeZourycOlofTF4LeODqav4EUxqvNxGf2nsAAAAASUVORK5CYII=" width="16" height="16" alt="상품 상태 아이콘">
                        			<div class="sc-ZUflv eDKhUO"><%= pvo.getPlike() %></div>
	                       		</div>
	                       		<div class="sc-iWadT haVDIN">
	                       			<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAaCAYAAADMp76xAAAAAXNSR0IArs4c6QAABAdJREFUWAm9mFtIFFEYx9tZ11UW1tLoaoGEPShqq3ahgogyIgnqQXqIgih6qKgEH4JIqCgIIoowIrSn6i0irOxCQdAN7wb2IiSlSUZuGJGyumu/b9lZZo8zs7ObdeBwvvNd/uc/53zznWFcs9Js7e3tczVNWzs1NbUKiErGfJfLNYcxVyCRg8g/GAeZdiC3eTyeN2VlZd/Enm5zpRLY09Pjm5yc3EnMbghUMbpTiYd8BP8X9Dt+v/9uYWHhz1TixdcR4YGBgezh4eFD+J+gz5XAGWijYFzKycm5nArxpIQ5+hqAr9AXzgBJM4ggqXWyvLz8uplR1VkShmgOR3iVo9+jBv2LOWs9pu+H+JAdvilhyC4j6AldxqSNhT7g1Oh2u59mZWV9loDx8fGl4XB4C+IBHrpIdA7ad7C2V1RUvLPynUa4u7s7wIvVQsB8qyCDfgK5jgUaWChs0MdFyLo7OjoOo7hI98QN1sJvsHaB+cDMJYFwV1fXCnblJY5+M2dFN8GOVgcCgWeK3nQKdhXYDzE6IR2GdA2k76lgmq7o7OxcBGAzcydkJazOKVlxjvnWieyguTmZ25y21PiEFt3h/v7+rJGRkddYyhOsFhOe/gMvR6lVGliEzZL0YGPep5DTw16vd2VJScmAjhnd4WAweBaFI7KxwEaVLCQyIHOafB2ULrLo9IVkjMU0GnVJ5PmhUOim0UejIqwGuNaoTCZLNVB9yNFTkUikHqzF0kUWnepnFqv6GOdgbWYDDuo6jaduYOLWFU5Gvgk+qX4A73ei08ue6ms3B/ui3LbiozExLUd2AOxSQnWx850h2+f8/PyQYGksfoRxMhVguRRUf06qyYnOLFaNM87BjdAP0KMbq1Fu2phcMDolk2M3WIIbOGf5JjgD1hfpIosuwYmJWazqo8yvGG++6NH29vZmjo2NPcdxveJsOoXQ/yprXcKpsrLyt04kWtaKi4tDPp9vB0T6dIPdSN4Xxa5bO7dpNomR2GkGEwVchjIyMrYbyYpbwstDGSqkHL0CdJ4Jhqr6l1ezfNhvhGynumj8ahYDOSc7vI7+UeZJmke+DajjR3lAy7IoNvERX/CcfEd8pRBsMCMrfBJ2WCdITi8gpx8xD+g6u1FyGvtff15KSlLjt5aWllpumClhIdfX1+cdHR09D0gtu2TpZ/cgKdqasrOzj/M+/bKLS0qEb4JN5PU1QJbbAaVrY0M+UQKPkY73nWAkJSwgkoe84fsQ6+lLRDcD7Stkz3FV35Aq5RTPEWEdLFavt7HQXnTVPEimbnM4ThDbQtytvLy85oKCgnGHcXG3lAjHoxAogbNJlTWIq6VDQn6k5DLmih+y/EgJMsqPlFaOvZW3/y0v1A+xp9v+ADhPuomDsZuZAAAAAElFTkSuQmCC" width="21" height="13" alt="상품 상태 아이콘"><%= pvo.getHits() %>
                       			</div>
                       			<div class="sc-iWadT haVDIN">
	                       			<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAuRJREFUWAnFV01rE1EUzUwSMWATENpFRNyIi0YI+eiui4LoogWFgkvBH6Dgpip+dONKgivdC3XlpkWELkTQRVw1H4QwWQmhLrKwq1IwxHyM54zvDck4mc6bTO3AY97MO/eeM/e9d+c+LeLzqlQq8Wg0ujIajW6ZprkIs7SmaRfQN9HvsOG5pev6h+Fw+LVYLPb9uNaOAzUajYXBYPAcPHeATR2HF+OHEPMuFou9yGazP71spgowDONMt9t9BOMNtDkvJx5jRxgrJRKJl5lM5rcbzlVArVabR6i3YbDsZhTgXRlTs57P5w+ctv8IAPkiwr2LdskJnuUZU7KPtgoRrXE/EwL45SDeC5tcEgoRS+OR0OUg55xhPyly8tA3OcgleW0BYsEpzTnm9THaknTm874suCy4JYBbDU9c7UoXvugzwllRMvoL3hCcEUsA9zneB91qAfgjc4IzojPD4UuYZP7rRU5y60yvYPab4cIUmSK3ztweplcVX+TWEYqMilGYWHJzEabDdKroK60jO52aAHLbiUhReShwTIHJNcBiYqYLX/IxoIMOIxBYANLweRIXCoWb2FJrEPJdUUiHa8BQNLLh2EY7+IM+a7fbZ3O53G4ymbwKf08B+GWDPDrAtrR6vX4dNdwnD5yfoR9w9hCReE9ws9m82Ov1XqF728sYUbuhMR0CxEoljGz4DdPyQP6gqtXqXayxt1NEHOL9vFWQAPgawHtTgEqvEQm4Mrcg5An6VxDdL24OMPYGEbtvCeCvsd/vcwGF+UdkZRyFmHMuAo7i8fhlVsxWHhClc8kFOMur1BRy+izJct1ORCydMVCehdGnbVlwWXBbAOt2zNs6wrbv05EyjL7JMX5GsAXQG6tVgFZPQgR90vd4RUzOCQFCRAtAFpphTkeZPkE+cSZwFSBEHGCerqG/icbjVdCLtpv05fxy6dDahvLB7X5qh1OnGMfxnFUUj+dWLYHtJo/nBhaZ0vH8D6NELRJSWvu9AAAAAElFTkSuQmCC" width="16" height="16" alt="상품 상태 아이콘">
                                   <div class = "diffdate" id="date<%=pvo.getPno()%>">
                                   		<%=pvo.getDiffSec() %>
                                   </div>
                                   <script>
											var caldate = prodTime("<%=pvo.getDiffSec() %>");
											document.getElementById("date<%=pvo.getPno()%>").innerHTML = caldate;
									</script>     
	                   			</div>
	                   		</div>
                   		</div>
                        <div class="sc-esoVGF dEbVXx">
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">카테고리</div>
                        		<div class="sc-gYtlsd ibSORm"><%= pvo.getCategory() %></div>
                        	</div>
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">거래방식</div>
                        		<div class="sc-gYtlsd ibSORm"><%= pvo.getTrade() %></div>
                        	</div>
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">배송비</div>
                        		<div class="sc-gYtlsd bgGbiT"><%= pvo.getFee() %></div>
                        	</div>
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">거래지역</div>
                        		<div class="sc-gYtlsd ggGPmQ"><%= pvo.getLoc() %></div>
                        	</div>
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
					</div>
					</form>
                </div>
            </div>
            <div class="container sc-jOVcOr hpgBcN px-lg-5">
	            <div class="sc-gCwZxT lbzvcl">
		            <div class="sc-RWGNv dcmzyJ">
		            <div class="sc-hcmgZB gsXioq">
		            <div class="sc-dHmInP gZUwUe">상품정보</div>
		            <div class="sc-ejGVNB fcSSwx">
		            <div class="sc-iiUIRa ijSpzm"></div>
		            <div class="sc-eLdqWK evwfQs">
						<%= pvo.getPdetail() %>
					</div>
					<div class="sc-feryYK lfypaP">
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAkCAYAAADo6zjiAAAAAXNSR0IArs4c6QAAANJJREFUWAntWEEKxCAMjGJ70h/4Aq/+/wm99gX9gTcVujsLe1pQoWj2kJyERCeZkNCOut9WSqHruiilRDjPtH3fyVpL3nvato1Uzvk+z5NqrTNxf942xlAIgTQqXw2ObIAJbA3auQzYenbPW8UBW7cCVvgkAXYGTK/PMcZeSNN/HEfT//8M9CpoljfgZGdAEhAGZA90GZA9MLDMHoXIGLIz0J0C+R6QPfBoyAcus08BfwL4R+cyaAXaOceF/xEqNJQKiAWrDZjAVqslGrQcrH8lmhfQ0lJsYYep+gAAAABJRU5ErkJggg==" width="16" height="18" alt="카테고리 아이콘" style="margin-right:5px;">카테고리</div>
					<div class="sc-bYwvMP heuxkD">
						<a href="#">
							<span class="sc-elNKlv bkciTp"><%= pvo.getCategory() %></span>
						</a>
					</div>
					</div>
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="data:image/png;base64,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" width="16" height="18" alt="거래방식 아이콘" style="margin-right:5px;">거래방식
					</div>
					<div class="sc-bYwvMP heuxkD">
						<span><%= pvo.getTrade() %></span>
					</div>
					</div>
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="../images/feeicon.png" width="16" height="18" alt="배송비 아이콘" style="margin-right:5px;">배송비
					</div>
					<div class="sc-bYwvMP heuxkD">
						<span><%= pvo.getFee() %></span>
					</div>
					</div>
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAiCAYAAABIiGl0AAAAAXNSR0IArs4c6QAAA6xJREFUWAm1l01IVFEUx51xNAtxIcEENuQIrqTxO8OEmj5IAncVUS2E2kS0axO4C5KiFi0lXIh9QBC1kKgwclNGjaNOSUEapVRiUSHoTOo4/c743vjem/vGp8xcuHPu+Z//Of9778y9740rz0EbGxsrjsViQait9JpEIuF1uVzbGCfo0/jT2GGwx6WlpQN+vz+Gn7G5MkXD4fAOil6C047dlImrxxCfg9tVUFBwtbq6ekbHrVYpzAoLo9FoJ+QL9AJrkkN/3u12d9bW1l5hMsvWnDTh4eHh8uXl5fvMutFK3qD/jLxTDQ0Nv4z5JuHR0VH/4uLiKwjy/WWtseJPLKTZKO7Wq4dCoa1LS0tP8bMqKvURrcT0TU1NbRZfWkqYWXVrhJVI9j+bZmZmbuplk1s9NDR0GNEnOpgrKz8ydBrZ8rBHRHCur0MsCvc1Pazl1GF301PbqOFpBh3Z4Rv0oIvVBgBG01hqYKCwsPBMIBD4bAxHIpGKhYWFbrB9RtxuzDEr9yB6zI5gwV/U19cfYLvktjI1mQh19rOI5wSCpqDC4bgelaXvUcRMEGJzAO0qUZ2oxdrx53XMzsI9KMJldgQDPsgPYtLgK4fCoeigMmgA2R2fCG83YMohxCFlQAHCDSlgE8Tkytx8yDZmbHCKMxIMQSdcJueWFU8Y8pRDiA3KgAJ0yJ1wJMwqGrlSWxQ6Jkg4wjWBamfCzQzfqmOrqGwNXo/c56uoeaTFejSuOWjxmNx7KXiHwYIlpnIr4I1xVo9TPF8nyFgwiYFV6LidhZfgJaFXv6vvUeCEHVmBy7UZ0fAAds3rUq+BcD8X0SFZcR5XWJcecGhFqEnrjkW12rfEJoV5PRlgJg+1QM4MGqG6uroHKWEZsNXnCfzNmWpe3iL1z9LjJmGuux+AF3MlTO1rrDb1FExutS5GQB5tj3Q/WxbRSElJyWVjPZOwBLxe70mI8sKXrTaZn59/pLKy8p+xYJqwz+eLFhUVtUH6aCRuZMwC/tBba2pqvlnz04SFUFVV9Zsj1krSd2vCOvwYNdo4sx9UOUphIfJ9f8XsRXxclbgGNiuiHNOXdjxbYUlgtuMINzN8Y1dAgU+BtTDxfkUsBWUUFhYFfmKCTKAvlWU/kDfPJo7mO3vKSiR5V69Fkrg8DPj32IHtwE2+FhvzmFivx+M5xz/ENV8sJM+xsC4yMjKyKx6P32YC8rdE2iz9HKu8m/QcfqxbWOry7N2CkRfznZzR0/yIvjBeV/sPFdozA8TD8zUAAAAASUVORK5CYII=" width="16" height="18" alt="거래지역 아이콘" style="margin-right:5px;">거래지역
					</div>
					<div class="sc-bYwvMP heuxkD">
						<span><%= pvo.getLoc() %></span>
					</div>
					</div>
					</div>
					</div>
					</div>
					
<!-- 					상품문의
					<div class="sc-gCUMDz jciAix">
						<div class="sc-dTsoBL jfhcrp">상품문의 
							<span class="sc-btewqU iMQsQP">0</span>
						</div>
						<div class="sc-jhaWeW dZMWqM">
						<div class="sc-bSbAYC eCLLuL">
							<textarea placeholder="상품문의 입력" class="sc-guztPN gGPaKe"></textarea>
						</div>
						<div class="sc-cFlXAS heLoWl">
							<div class="sc-hcnlBt euLZza">0 / 100</div>
							<button class="sc-hkbPbT jtwvCV">
								<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAgCAYAAAAFQMh/AAAAAXNSR0IArs4c6QAABFdJREFUSA3Nl11MVEcUgPfnIj8B1kRi4AFI9cEiITFGfZXUYNWKxJ9CtBqC0WCMuoEGgfIPBsVsU7MpVdRV0qZpgkZLjU2qrYD6oCTw4A+YoGktTQhiIE1hC7td8Dsb7ua6ruxd2IdOMsy5Z84535wzM/cuRkOYW0tLS8zw8PCR6enpfKPRaCH865mZmRuKolysrKx8qeKMqhCO0WazJUxMTNwBlAF0gJjXkBGNHzN+wHi4pqbme2GFDexwOOIGBwf/JHgccW0pKSm1BQUFkwKRVl9fv4cqnDWZTNbq6urWsIA7OjqUrq6uH4DmwFDI7nRtbW2Zl6j509DQ8JHH42k3m83rzBr9vMS2tjZzT0+PlG9LVFTURrJahvxZZmZmdGdn56/aoCzwd/Qr0a0yaSdClQXa39//HRlm4fvH5ORkc0xMzKdk3kU/Ttan/GOS7RXsc+YNxtnU19fXSuBNERERWfHx8euBucfHx38LAv8PO8u8wAKtq6u7TIBsMthYUVHRW1xcPBoZGbmBhTjngrMVW7F5FfLhAmrkhDoYd3I3s7ib3QTytebm5tiRkZGbKBbHxsZucDqdUtr19NMs9CH6K4zHQgLjLNALOOdKpkAf+IgaQV4iQ0ND7aiW+sE9QG+npaVl6y61QCnvOcY8oJveBxV+YWGhMzU1NRvxLyk75e0Wf9rfsv+5ubkeXRnPQr8h0F7KuxnofQEEa5z6RZz6XvzTgV7nuuWXlpb+I3667jFvm69xzAf6CdB7wYDqfEZGRgnQ3QJNTEzMs1qt/6pzQUtNee04FwDfCvSu6hhsxK+EEp9UoZTfrfWZE8wL4CuMD7Cn2VVVVZ1ax7lkDmAxi5VT7M3UHyq+7wWzYhvzh+g5QO+IsZ6Gn5VMv5wLKnGUQMHItAn9EZxz+IzdDmQTSAf0KJmeCQYV33cyBir7YmVuO9BfAgEC6SjvYaB2PVDxf+s6seITOJfgvAOovH10NfwKMTxL/1FOb6A99Q/kKzWZ1jF5nIO0iz3VDSXTAyw2JKgswpsxH+hdHIg2AoyQ7QDjIAu4zAJu+a9U+wx0P7YX0enOVPX37jHQJBQu+nkCyX3bhq5SNQo0Ut58bC4wFzJU4nlLDWwNcj/lrhIlmXxB0OUiB2rM72X+EtVp17un/nHUPRZwrzpJ0BUEnZJSIqch/8xh65B5dHtYaOtCoBLHJN9Pxg8J9EQUs20ZwQ8CdaDfhywfCAPlzUP+FvGn+WY6G9+gjI2NreaBV7HpqU+pKJ8DSIiOju52u92LXS7XM6C7BcpCFgwVjkJWUmYDXx5fxnwMfL8q7Ha7a2pqygxQoDcWmqmwpAl4LeN4WVnZy/LyckNTU1McoJVkJz9D00dHR9PFkOfepKQkXS8HsQ/WjJzkAYwS6A/IKB1Asjghexie0x+he2GxWOxFRUVDMheOJqd6EV3usMhX2etHjI+Tk5Ofav8FQRfe1tjYuCS8Ef/n0d4Ah7Y0Xn+VgFMAAAAASUVORK5CYII=" width="15" height="16" alt="문의등록버튼 아이콘">등록
							</button>
						</div>
					</div>
					</div> -->
					
					</div>
					</div>
					<div class="sc-hkaZBZ bEhvoQ">
					<div class="sc-jbWsrJ lbmmDG">
					<div class="sc-cNQqM ihiUrc">
						<div class="sc-eMRERa kUXckj">판매자</div>
					<div class="sc-eqPNPO hyAkCm">
					<div class="sc-ileJJU khiPFC">
					<a class="sc-jotlie fuODcw" href="../page/userPage.jsp?mno=<%= pvo.getMno() %>">
						<img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgdmlld0JveD0iMCAwIDEwMCAxMDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxjaXJjbGUgZmlsbD0iI0ZBRkFGQSIgY3g9IjUwIiBjeT0iNTAiIHI9IjUwIi8+CiAgICAgICAgPHBhdGggZD0iTTM2LjIxNiA0MS42ODNjLjI0OC0xLjkzMS40OTgtMy44NjIuNzUtNS43OTRoNi43OWwtLjI4MyA1LjUzN2MwIC4wMTcuMDA3LjAzNC4wMDcuMDUxLS4wMDIuMDEtLjAwMi4wMi0uMDAyLjAzLS4wOTggMS44NzYtMS44OTcgMy4zOTItNC4wMzUgMy4zOTItMS4wNjYgMC0yLjAxOC0uMzktMi42MTUtMS4wNzItLjUxLS41ODUtLjcyMi0xLjMyNS0uNjEyLTIuMTQ0em04Ljg4OCA0LjA3OGMxLjIyNCAxLjI4OSAzLjAwOSAyLjAyOCA0Ljg5IDIuMDI4IDEuODkgMCAzLjY3NC0uNzQgNC45LTIuMDMzLjEwNy0uMTEyLjIwNy0uMjI4LjMwNC0uMzQ1IDEuMjggMS40NDcgMy4yMTcgMi4zNzggNS4zNSAyLjM3OC4xMTIgMCAuMjE2LS4wMjcuMzI4LS4wMzJWNjMuNkgzOS4xMTVWNDcuNzU3Yy4xMTIuMDA1LjIxNS4wMzIuMzI4LjAzMiAyLjEzMyAwIDQuMDcxLS45MzEgNS4zNTEtMi4zOC4wOTkuMTIxLjIuMjM4LjMxLjM1MnptMS41NDUtOS44NzJoNi42OThsLjI4MiA1LjYxOWMwIC4wMTUtLjAwNy4wMjctLjAwNy4wNGwuMDA0LjA4NmEyLjkzOSAyLjkzOSAwIDAgMS0uODI2IDIuMTMyYy0xLjM2NyAxLjQ0LTQuMjMzIDEuNDQxLTUuNjA0LjAwM2EyLjk1IDIuOTUgMCAwIDEtLjgzLTIuMTQybC4wMDQtLjA3OGMwLS4wMTYtLjAwOC0uMDMtLjAwOC0uMDQ4bC4yODctNS42MTJ6bTE2LjM3NiAwYy4yNTIgMS45MzMuNTAyIDMuODY1Ljc1MyA1LjgwNC4xMDkuODEtLjEwNCAxLjU0Ny0uNjE0IDIuMTMyLS41OTYuNjgzLTEuNTUgMS4wNzQtMi42MTYgMS4wNzQtMi4xMzcgMC0zLjkzMi0xLjUxNC00LjAzNC0zLjM4OGEuMzU5LjM1OSAwIDAgMC0uMDAzLS4wNDRjMC0uMDE1LjAwNi0uMDI3LjAwNi0uMDRsLS4yNzgtNS41MzhoNi43ODZ6TTM2LjIyNiA0Ni45NDZ2MTguMDk4YzAgLjc5OC42NDYgMS40NDUgMS40NDQgMS40NDVoMjQuNjVjLjc5OSAwIDEuNDQ1LS42NDcgMS40NDUtMS40NDVWNDYuOTQ2Yy41OS0uMzI4IDEuMTM3LS43MTkgMS41NzUtMS4yMiAxLjA2MS0xLjIxNCAxLjUyMi0yLjc4NSAxLjMwMS00LjQxLS4zLTIuMzU1LS42MDctNC43MDctLjkxOC03LjA2YTEuNDQzIDEuNDQzIDAgMCAwLTEuNDMxLTEuMjU3SDM1LjY5OWMtLjcyNCAwLTEuMzM4LjUzOC0xLjQzMSAxLjI1Ny0uMzExIDIuMzU0LS42MTcgNC43MDctLjkxNiA3LjA1LS4yMjEgMS42MzcuMjQgMy4yMDggMS4zIDQuNDIxLjQzOS41MDIuOTg0Ljg5MyAxLjU3NCAxLjIyeiIgZmlsbD0iI0NDQyIvPgogICAgPC9nPgo8L3N2Zz4K" width="48" height="48" alt="판매자 프로필 이미지">
					</a>
					<div class="sc-fdQOMr gozXAM">
						<a class="sc-fAJaQT kvtlkl" href="../page/userPage.jsp?mno=<%= pvo.getMno() %>">
							<%= dao.getNick(pvo.getMno()) %>
						</a>
					<div class="sc-cNnxps amrNP">
						<a class="sc-dPPMrM iEdtuR" href="../page/userPage.jsp?mno=<%= pvo.getMno() %>">
							<%= dao.getmdetail(pvo.getMno()) %>
						</a>
					</div>
					</div>
					</div>
					<div class="sc-hAnkBK dgHgxl">
						<a class="sc-geAPOV kWnRbz" href="/shop/77414854/products"></a>
					</div>
					<div class="sc-bJTOcE ZPKia">
<!-- 				상점후기	
					<div class="sc-PLyBE gMYroH">상점후기
						<span class="sc-clBsIJ fEDdTw">1</span>
					</div>
					<div class="sc-dPNhBE iXqvuW">
					<div class="sc-dBAPYN iafGxm">
						<a class="sc-dwztqd fcVzVM" href="/shop/79375251/products">
							<img src="" width="32" height="32" alt="프로필">
						</a>
						<div class="sc-dKEPtC kedHn">
							<div class="sc-dvpmds iWPzHr">
								<a class="sc-fgrSAo jdESkZ" href="/shop/79375251/products">닉네임</a>
								<div class="sc-jHXLhC cLHfak">날짜</div>
							</div>
							<div class="sc-bOCYYb hBTqKV">
							<div class="sc-drKuOJ lhBAnI">
							<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지">
							</div>
							</div>
							<div class="sc-iFUGim cEtXoK">
								리뷰내용
							</div>
						</div>
					</div>
					</div> -->
					<div class="sc-DNdyV gxpXGn"></div>
					</div>
					</div>
					</div>
					<div class="sc-imAxmJ YIppl">
						<div class="uploadbtn sc-hPeUyl fMYzPw">
							<a href="../chatting/chatCheck.jsp?pno=<%= pvo.getPno() %>">
								<label class="input-file-button">
									알쓸톡하기
								</label>
							</a>
						</div>
					</div>
					</div>
					</div>
					</div>
       </section>

        <!-- Related items section-->
        <section class="py-5" style="font-family:'godo';">
            <div class="container px-4 px-lg-5 mt-5">
                <h2 class="mb-4">판매목록</h2>
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo1.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class=""><%= pvo1.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo1.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo1.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo2.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder"><%= pvo2.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo2.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo2.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo3.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder"><%= pvo3.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo3.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo3.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo4.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder"><%= pvo4.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo4.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo4.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Footer-->
        <jsp:include page="../main_login/mainFooter.jsp"/>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="../resources/js/detailBoots.js"></script>
    </body>
    <%
		}else{
	%>
    <script>
    <%
			int pno = Integer.parseInt(request.getParameter("pno"));
			ProductDAO dao = new ProductDAO();
			ProductVO pvo = dao.selectOne(pno);
			dao.plusHits(pno);
			
			ImageDAO idao = new ImageDAO();
			ArrayList<ImageVO> imgList = idao.imgSelect(pno);
			
			LikeDAO ldao = new LikeDAO();
			
			ArrayList<Integer> pmem = dao.salesList(pvo.getMno(),pno);
			ProductVO pvo1 = dao.selectOne(pmem.get(0));
			ProductVO pvo2 = dao.selectOne(pmem.get(1));
			ProductVO pvo3 = dao.selectOne(pmem.get(2));
			ProductVO pvo4 = dao.selectOne(pmem.get(3));
			
			ArrayList<ImageVO> imgList1 = idao.imgSelect(pmem.get(0));
			ArrayList<ImageVO> imgList2 = idao.imgSelect(pmem.get(1));
			ArrayList<ImageVO> imgList3 = idao.imgSelect(pmem.get(2));
			ArrayList<ImageVO> imgList4 = idao.imgSelect(pmem.get(3));
			
			ImageVO imgvo1 = imgList1.get(0);
			ImageVO imgvo2 = imgList2.get(0);
			ImageVO imgvo3 = imgList3.get(0);
			ImageVO imgvo4 = imgList4.get(0);
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
					},
					success : function(result){
						//alert("전송")
						if(result == 1){
							$(".likebtn").attr('src','../images/like.png');
							var plus = parseInt($(".sc-ZUflv").html())+1;
							$(".sc-ZUflv").html(plus);
						}else if(result == 0){
							$(".likebtn").attr("src","../images/nolike.png");
							var minus = parseInt($(".sc-ZUflv").html())-1;
							$(".sc-ZUflv").html(minus);
						}else{
							//alert("DB error");
							//autoClosingAlert("#warningMessage", 2000)
						}
					}
				})
		 	}
		 	
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
	
	</script>
    </head>
    <body>
        <!-- Navigation-->
        <jsp:include page="../main_login/mainNav.jsp"/>
        <!-- Product section-->
        <section class="py-5" style="font-family:'godo';">
            <div class="container px-4 px-lg-5 my-5">
                <div class="row gx-4 gx-lg-5 align-items-center">
                <form action="modifyOK.jsp" method="get" enctype="multipart/form-data">
       				<div class="imgbox col-md-6-userupdate1">
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
												<img src="../images/nolike.png" class="likebtn" alt="" onclick="likeClick()"/>
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
                   		</div>
                    <div class="col-md-6-userupdate2">
                        <h1 class="user-marginbottom" style="font-size:2.0rem; font-family: 'Do Hyeon', sans-serif;"><%= pvo.getTitle() %></h1>
                        <h2 class="display-7 fw-bolder inputdiv">
                            <span><%= pvo.getPrice() %>원</span>
                        </h2>
                        <div class="sc-hqGPoI fBhbVz">
	                        <div class="sc-imAxmJ lfImbI">
	                        	<div class="sc-iWadT haVDIN">
	                        		<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAjhJREFUWAnFl1uPKUEUhbdCxF2Iu7h78f9/ixdexANeSNxCkJnz1ZwSRncrM0OvhK6ufVmrdiu1O/DxD/INq9VKFouFbDYbOR6PEggEJBKJSDqdlkKhIKFQ6FvE1+3pdJL5fC7EHw4HIXU4HJZEIiHZbFZSqdRdXOBaAEHj8VjW6/Wdo5kIBoNSLBalVCppYcxDNJvNNPn5fDaud9dkMimNRkMvxhgvAna7nQyHQ2EVNmBV3W5Xu45GI10tmziq1+v1JBaLaXctANLBYKDLbZPE+MTjcT3cbrdmyurKY+n3+/pRKiImk8nT5MRB/Cw5cfyu4ARqv9/LcrnUN+/8ghNuxcBhI7xcC5xwK7aMX4BbsfX8AtzKa9++Whjcij8WvwC3Yk/6BbiV+TPxQwTcKpPJ+MGtOeFWHBB+PAY44VYctZxu7waccOuzIJ/Pv7UKrB5OoAUopfQ5/a4q0BPAeRHAgG4nl8vpyVd+wQGXwZeM/3f1el2i0aix/fmV3HBc40YAZel0Oq4933Xgs2M6IXKb0pv4GwFM0ny22+1Lv2ccf3Pl195qtW56QZPvTgAG9mez2fwTEZCTy6kjhstRAAba6FqtxvBXIAe53OAqgADeASqVilvsw3liyeEFTwEElstl/fFK4mSzjXsogOSshBcRW+BrWzkrARBXq1UrEZDjawtrAUYEpXXDs+TkeUoAAZTWScRPyMnn/JqLxQPm+U6nU+2FIDPnEeZourycOlofTF4LeODqav4EUxqvNxGf2nsAAAAASUVORK5CYII=" width="16" height="16" alt="상품 상태 아이콘">
                        			<div class="sc-ZUflv eDKhUO"><%= pvo.getPlike() %></div>
	                       		</div>
	                       		<div class="sc-iWadT haVDIN">
	                       			<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAaCAYAAADMp76xAAAAAXNSR0IArs4c6QAABAdJREFUWAm9mFtIFFEYx9tZ11UW1tLoaoGEPShqq3ahgogyIgnqQXqIgih6qKgEH4JIqCgIIoowIrSn6i0irOxCQdAN7wb2IiSlSUZuGJGyumu/b9lZZo8zs7ObdeBwvvNd/uc/53zznWFcs9Js7e3tczVNWzs1NbUKiErGfJfLNYcxVyCRg8g/GAeZdiC3eTyeN2VlZd/Enm5zpRLY09Pjm5yc3EnMbghUMbpTiYd8BP8X9Dt+v/9uYWHhz1TixdcR4YGBgezh4eFD+J+gz5XAGWijYFzKycm5nArxpIQ5+hqAr9AXzgBJM4ggqXWyvLz8uplR1VkShmgOR3iVo9+jBv2LOWs9pu+H+JAdvilhyC4j6AldxqSNhT7g1Oh2u59mZWV9loDx8fGl4XB4C+IBHrpIdA7ad7C2V1RUvLPynUa4u7s7wIvVQsB8qyCDfgK5jgUaWChs0MdFyLo7OjoOo7hI98QN1sJvsHaB+cDMJYFwV1fXCnblJY5+M2dFN8GOVgcCgWeK3nQKdhXYDzE6IR2GdA2k76lgmq7o7OxcBGAzcydkJazOKVlxjvnWieyguTmZ25y21PiEFt3h/v7+rJGRkddYyhOsFhOe/gMvR6lVGliEzZL0YGPep5DTw16vd2VJScmAjhnd4WAweBaFI7KxwEaVLCQyIHOafB2ULrLo9IVkjMU0GnVJ5PmhUOim0UejIqwGuNaoTCZLNVB9yNFTkUikHqzF0kUWnepnFqv6GOdgbWYDDuo6jaduYOLWFU5Gvgk+qX4A73ei08ue6ms3B/ui3LbiozExLUd2AOxSQnWx850h2+f8/PyQYGksfoRxMhVguRRUf06qyYnOLFaNM87BjdAP0KMbq1Fu2phcMDolk2M3WIIbOGf5JjgD1hfpIosuwYmJWazqo8yvGG++6NH29vZmjo2NPcdxveJsOoXQ/yprXcKpsrLyt04kWtaKi4tDPp9vB0T6dIPdSN4Xxa5bO7dpNomR2GkGEwVchjIyMrYbyYpbwstDGSqkHL0CdJ4Jhqr6l1ezfNhvhGynumj8ahYDOSc7vI7+UeZJmke+DajjR3lAy7IoNvERX/CcfEd8pRBsMCMrfBJ2WCdITi8gpx8xD+g6u1FyGvtff15KSlLjt5aWllpumClhIdfX1+cdHR09D0gtu2TpZ/cgKdqasrOzj/M+/bKLS0qEb4JN5PU1QJbbAaVrY0M+UQKPkY73nWAkJSwgkoe84fsQ6+lLRDcD7Stkz3FV35Aq5RTPEWEdLFavt7HQXnTVPEimbnM4ThDbQtytvLy85oKCgnGHcXG3lAjHoxAogbNJlTWIq6VDQn6k5DLmih+y/EgJMsqPlFaOvZW3/y0v1A+xp9v+ADhPuomDsZuZAAAAAElFTkSuQmCC" width="21" height="13" alt="상품 상태 아이콘"><%= pvo.getHits() %>
                       			</div>
                       			<div class="sc-iWadT haVDIN">
	                       			<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAuRJREFUWAnFV01rE1EUzUwSMWATENpFRNyIi0YI+eiui4LoogWFgkvBH6Dgpip+dONKgivdC3XlpkWELkTQRVw1H4QwWQmhLrKwq1IwxHyM54zvDck4mc6bTO3AY97MO/eeM/e9d+c+LeLzqlQq8Wg0ujIajW6ZprkIs7SmaRfQN9HvsOG5pev6h+Fw+LVYLPb9uNaOAzUajYXBYPAcPHeATR2HF+OHEPMuFou9yGazP71spgowDONMt9t9BOMNtDkvJx5jRxgrJRKJl5lM5rcbzlVArVabR6i3YbDsZhTgXRlTs57P5w+ctv8IAPkiwr2LdskJnuUZU7KPtgoRrXE/EwL45SDeC5tcEgoRS+OR0OUg55xhPyly8tA3OcgleW0BYsEpzTnm9THaknTm874suCy4JYBbDU9c7UoXvugzwllRMvoL3hCcEUsA9zneB91qAfgjc4IzojPD4UuYZP7rRU5y60yvYPab4cIUmSK3ztweplcVX+TWEYqMilGYWHJzEabDdKroK60jO52aAHLbiUhReShwTIHJNcBiYqYLX/IxoIMOIxBYANLweRIXCoWb2FJrEPJdUUiHa8BQNLLh2EY7+IM+a7fbZ3O53G4ymbwKf08B+GWDPDrAtrR6vX4dNdwnD5yfoR9w9hCReE9ws9m82Ov1XqF728sYUbuhMR0CxEoljGz4DdPyQP6gqtXqXayxt1NEHOL9vFWQAPgawHtTgEqvEQm4Mrcg5An6VxDdL24OMPYGEbtvCeCvsd/vcwGF+UdkZRyFmHMuAo7i8fhlVsxWHhClc8kFOMur1BRy+izJct1ORCydMVCehdGnbVlwWXBbAOt2zNs6wrbv05EyjL7JMX5GsAXQG6tVgFZPQgR90vd4RUzOCQFCRAtAFpphTkeZPkE+cSZwFSBEHGCerqG/icbjVdCLtpv05fxy6dDahvLB7X5qh1OnGMfxnFUUj+dWLYHtJo/nBhaZ0vH8D6NELRJSWvu9AAAAAElFTkSuQmCC" width="16" height="16" alt="상품 상태 아이콘">
                                   <div class = "diffdate" id="date<%=pvo.getPno()%>">
                                   		<%=pvo.getDiffSec() %>
                                   </div>
                                   <script>
											var caldate = prodTime("<%=pvo.getDiffSec() %>");
											document.getElementById("date<%=pvo.getPno()%>").innerHTML = caldate;
									</script>     
	                   			</div>
	                   		</div>
                   		</div>
                        <div class="sc-esoVGF dEbVXx">
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">카테고리</div>
                        		<div class="sc-gYtlsd ibSORm"><%= pvo.getCategory() %></div>
                        	</div>
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">거래방식</div>
                        		<div class="sc-gYtlsd ibSORm"><%= pvo.getTrade() %></div>
                        	</div>
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">배송비</div>
                        		<div class="sc-gYtlsd bgGbiT"><%= pvo.getFee() %></div>
                        	</div>
                        	<div class="sc-cAJUJo jaUllp">
                        		<div class="sc-cmUJln fcpmSq">거래지역</div>
                        		<div class="sc-gYtlsd ggGPmQ"><%= pvo.getLoc() %></div>
                        	</div>
                        </div>
					</div>
					</form>
                </div>
            </div>
            <div class="container sc-jOVcOr hpgBcN px-lg-5">
	            <div class="sc-gCwZxT lbzvcl">
		            <div class="sc-RWGNv dcmzyJ">
		            <div class="sc-hcmgZB gsXioq">
		            <div class="sc-dHmInP gZUwUe">상품정보</div>
		            <div class="sc-ejGVNB fcSSwx">
		            <div class="sc-iiUIRa ijSpzm"></div>
		            <div class="sc-eLdqWK evwfQs">
						<%= pvo.getPdetail() %>
					</div>
					<div class="sc-feryYK lfypaP">
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAkCAYAAADo6zjiAAAAAXNSR0IArs4c6QAAANJJREFUWAntWEEKxCAMjGJ70h/4Aq/+/wm99gX9gTcVujsLe1pQoWj2kJyERCeZkNCOut9WSqHruiilRDjPtH3fyVpL3nvato1Uzvk+z5NqrTNxf942xlAIgTQqXw2ObIAJbA3auQzYenbPW8UBW7cCVvgkAXYGTK/PMcZeSNN/HEfT//8M9CpoljfgZGdAEhAGZA90GZA9MLDMHoXIGLIz0J0C+R6QPfBoyAcus08BfwL4R+cyaAXaOceF/xEqNJQKiAWrDZjAVqslGrQcrH8lmhfQ0lJsYYep+gAAAABJRU5ErkJggg==" width="16" height="18" alt="카테고리 아이콘" style="margin-right:5px;">카테고리</div>
					<div class="sc-bYwvMP heuxkD">
						<a href="#">
							<span class="sc-elNKlv bkciTp"><%= pvo.getCategory() %></span>
						</a>
					</div>
					</div>
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="data:image/png;base64,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" width="16" height="18" alt="거래방식 아이콘" style="margin-right:5px;">거래방식
					</div>
					<div class="sc-bYwvMP heuxkD">
						<span><%= pvo.getTrade() %></span>
					</div>
					</div>
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="../images/feeicon.png" width="16" height="18" alt="배송비 아이콘" style="margin-right:5px;">배송비
					</div>
					<div class="sc-bYwvMP heuxkD">
						<span><%= pvo.getFee() %></span>
					</div>
					</div>
					<div class="sc-cJOK fWMyvb">
					<div class="sc-ccSCjj fEmvdT">
						<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAiCAYAAABIiGl0AAAAAXNSR0IArs4c6QAAA6xJREFUWAm1l01IVFEUx51xNAtxIcEENuQIrqTxO8OEmj5IAncVUS2E2kS0axO4C5KiFi0lXIh9QBC1kKgwclNGjaNOSUEapVRiUSHoTOo4/c743vjem/vGp8xcuHPu+Z//Of9778y9740rz0EbGxsrjsViQait9JpEIuF1uVzbGCfo0/jT2GGwx6WlpQN+vz+Gn7G5MkXD4fAOil6C047dlImrxxCfg9tVUFBwtbq6ekbHrVYpzAoLo9FoJ+QL9AJrkkN/3u12d9bW1l5hMsvWnDTh4eHh8uXl5fvMutFK3qD/jLxTDQ0Nv4z5JuHR0VH/4uLiKwjy/WWtseJPLKTZKO7Wq4dCoa1LS0tP8bMqKvURrcT0TU1NbRZfWkqYWXVrhJVI9j+bZmZmbuplk1s9NDR0GNEnOpgrKz8ydBrZ8rBHRHCur0MsCvc1Pazl1GF301PbqOFpBh3Z4Rv0oIvVBgBG01hqYKCwsPBMIBD4bAxHIpGKhYWFbrB9RtxuzDEr9yB6zI5gwV/U19cfYLvktjI1mQh19rOI5wSCpqDC4bgelaXvUcRMEGJzAO0qUZ2oxdrx53XMzsI9KMJldgQDPsgPYtLgK4fCoeigMmgA2R2fCG83YMohxCFlQAHCDSlgE8Tkytx8yDZmbHCKMxIMQSdcJueWFU8Y8pRDiA3KgAJ0yJ1wJMwqGrlSWxQ6Jkg4wjWBamfCzQzfqmOrqGwNXo/c56uoeaTFejSuOWjxmNx7KXiHwYIlpnIr4I1xVo9TPF8nyFgwiYFV6LidhZfgJaFXv6vvUeCEHVmBy7UZ0fAAds3rUq+BcD8X0SFZcR5XWJcecGhFqEnrjkW12rfEJoV5PRlgJg+1QM4MGqG6uroHKWEZsNXnCfzNmWpe3iL1z9LjJmGuux+AF3MlTO1rrDb1FExutS5GQB5tj3Q/WxbRSElJyWVjPZOwBLxe70mI8sKXrTaZn59/pLKy8p+xYJqwz+eLFhUVtUH6aCRuZMwC/tBba2pqvlnz04SFUFVV9Zsj1krSd2vCOvwYNdo4sx9UOUphIfJ9f8XsRXxclbgGNiuiHNOXdjxbYUlgtuMINzN8Y1dAgU+BtTDxfkUsBWUUFhYFfmKCTKAvlWU/kDfPJo7mO3vKSiR5V69Fkrg8DPj32IHtwE2+FhvzmFivx+M5xz/ENV8sJM+xsC4yMjKyKx6P32YC8rdE2iz9HKu8m/QcfqxbWOry7N2CkRfznZzR0/yIvjBeV/sPFdozA8TD8zUAAAAASUVORK5CYII=" width="16" height="18" alt="거래지역 아이콘" style="margin-right:5px;">거래지역
					</div>
					<div class="sc-bYwvMP heuxkD">
						<span><%= pvo.getLoc() %></span>
					</div>
					</div>
					</div>
					</div>
					</div>
					
<!-- 					상품문의
					<div class="sc-gCUMDz jciAix">
						<div class="sc-dTsoBL jfhcrp">상품문의 
							<span class="sc-btewqU iMQsQP">0</span>
						</div>
						<div class="sc-jhaWeW dZMWqM">
						<div class="sc-bSbAYC eCLLuL">
							<textarea placeholder="상품문의 입력" class="sc-guztPN gGPaKe"></textarea>
						</div>
						<div class="sc-cFlXAS heLoWl">
							<div class="sc-hcnlBt euLZza">0 / 100</div>
							<button class="sc-hkbPbT jtwvCV">
								<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAgCAYAAAAFQMh/AAAAAXNSR0IArs4c6QAABFdJREFUSA3Nl11MVEcUgPfnIj8B1kRi4AFI9cEiITFGfZXUYNWKxJ9CtBqC0WCMuoEGgfIPBsVsU7MpVdRV0qZpgkZLjU2qrYD6oCTw4A+YoGktTQhiIE1hC7td8Dsb7ua6ruxd2IdOMsy5Z84535wzM/cuRkOYW0tLS8zw8PCR6enpfKPRaCH865mZmRuKolysrKx8qeKMqhCO0WazJUxMTNwBlAF0gJjXkBGNHzN+wHi4pqbme2GFDexwOOIGBwf/JHgccW0pKSm1BQUFkwKRVl9fv4cqnDWZTNbq6urWsIA7OjqUrq6uH4DmwFDI7nRtbW2Zl6j509DQ8JHH42k3m83rzBr9vMS2tjZzT0+PlG9LVFTURrJahvxZZmZmdGdn56/aoCzwd/Qr0a0yaSdClQXa39//HRlm4fvH5ORkc0xMzKdk3kU/Ttan/GOS7RXsc+YNxtnU19fXSuBNERERWfHx8euBucfHx38LAv8PO8u8wAKtq6u7TIBsMthYUVHRW1xcPBoZGbmBhTjngrMVW7F5FfLhAmrkhDoYd3I3s7ib3QTytebm5tiRkZGbKBbHxsZucDqdUtr19NMs9CH6K4zHQgLjLNALOOdKpkAf+IgaQV4iQ0ND7aiW+sE9QG+npaVl6y61QCnvOcY8oJveBxV+YWGhMzU1NRvxLyk75e0Wf9rfsv+5ubkeXRnPQr8h0F7KuxnofQEEa5z6RZz6XvzTgV7nuuWXlpb+I3667jFvm69xzAf6CdB7wYDqfEZGRgnQ3QJNTEzMs1qt/6pzQUtNee04FwDfCvSu6hhsxK+EEp9UoZTfrfWZE8wL4CuMD7Cn2VVVVZ1ax7lkDmAxi5VT7M3UHyq+7wWzYhvzh+g5QO+IsZ6Gn5VMv5wLKnGUQMHItAn9EZxz+IzdDmQTSAf0KJmeCQYV33cyBir7YmVuO9BfAgEC6SjvYaB2PVDxf+s6seITOJfgvAOovH10NfwKMTxL/1FOb6A99Q/kKzWZ1jF5nIO0iz3VDSXTAyw2JKgswpsxH+hdHIg2AoyQ7QDjIAu4zAJu+a9U+wx0P7YX0enOVPX37jHQJBQu+nkCyX3bhq5SNQo0Ut58bC4wFzJU4nlLDWwNcj/lrhIlmXxB0OUiB2rM72X+EtVp17un/nHUPRZwrzpJ0BUEnZJSIqch/8xh65B5dHtYaOtCoBLHJN9Pxg8J9EQUs20ZwQ8CdaDfhywfCAPlzUP+FvGn+WY6G9+gjI2NreaBV7HpqU+pKJ8DSIiOju52u92LXS7XM6C7BcpCFgwVjkJWUmYDXx5fxnwMfL8q7Ha7a2pqygxQoDcWmqmwpAl4LeN4WVnZy/LyckNTU1McoJVkJz9D00dHR9PFkOfepKQkXS8HsQ/WjJzkAYwS6A/IKB1Asjghexie0x+he2GxWOxFRUVDMheOJqd6EV3usMhX2etHjI+Tk5Ofav8FQRfe1tjYuCS8Ef/n0d4Ah7Y0Xn+VgFMAAAAASUVORK5CYII=" width="15" height="16" alt="문의등록버튼 아이콘">등록
							</button>
						</div>
					</div>
					</div> -->
					
					</div>
					</div>
					<div class="sc-hkaZBZ bEhvoQ">
					<div class="sc-jbWsrJ lbmmDG">
					<div class="sc-cNQqM ihiUrc">
						<div class="sc-eMRERa kUXckj">판매자</div>
					<div class="sc-eqPNPO hyAkCm">
					<div class="sc-ileJJU khiPFC">
					<a class="sc-jotlie fuODcw" href="../page/userPage.jsp?mno=<%= pvo.getMno() %>">
						<img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgdmlld0JveD0iMCAwIDEwMCAxMDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxjaXJjbGUgZmlsbD0iI0ZBRkFGQSIgY3g9IjUwIiBjeT0iNTAiIHI9IjUwIi8+CiAgICAgICAgPHBhdGggZD0iTTM2LjIxNiA0MS42ODNjLjI0OC0xLjkzMS40OTgtMy44NjIuNzUtNS43OTRoNi43OWwtLjI4MyA1LjUzN2MwIC4wMTcuMDA3LjAzNC4wMDcuMDUxLS4wMDIuMDEtLjAwMi4wMi0uMDAyLjAzLS4wOTggMS44NzYtMS44OTcgMy4zOTItNC4wMzUgMy4zOTItMS4wNjYgMC0yLjAxOC0uMzktMi42MTUtMS4wNzItLjUxLS41ODUtLjcyMi0xLjMyNS0uNjEyLTIuMTQ0em04Ljg4OCA0LjA3OGMxLjIyNCAxLjI4OSAzLjAwOSAyLjAyOCA0Ljg5IDIuMDI4IDEuODkgMCAzLjY3NC0uNzQgNC45LTIuMDMzLjEwNy0uMTEyLjIwNy0uMjI4LjMwNC0uMzQ1IDEuMjggMS40NDcgMy4yMTcgMi4zNzggNS4zNSAyLjM3OC4xMTIgMCAuMjE2LS4wMjcuMzI4LS4wMzJWNjMuNkgzOS4xMTVWNDcuNzU3Yy4xMTIuMDA1LjIxNS4wMzIuMzI4LjAzMiAyLjEzMyAwIDQuMDcxLS45MzEgNS4zNTEtMi4zOC4wOTkuMTIxLjIuMjM4LjMxLjM1MnptMS41NDUtOS44NzJoNi42OThsLjI4MiA1LjYxOWMwIC4wMTUtLjAwNy4wMjctLjAwNy4wNGwuMDA0LjA4NmEyLjkzOSAyLjkzOSAwIDAgMS0uODI2IDIuMTMyYy0xLjM2NyAxLjQ0LTQuMjMzIDEuNDQxLTUuNjA0LjAwM2EyLjk1IDIuOTUgMCAwIDEtLjgzLTIuMTQybC4wMDQtLjA3OGMwLS4wMTYtLjAwOC0uMDMtLjAwOC0uMDQ4bC4yODctNS42MTJ6bTE2LjM3NiAwYy4yNTIgMS45MzMuNTAyIDMuODY1Ljc1MyA1LjgwNC4xMDkuODEtLjEwNCAxLjU0Ny0uNjE0IDIuMTMyLS41OTYuNjgzLTEuNTUgMS4wNzQtMi42MTYgMS4wNzQtMi4xMzcgMC0zLjkzMi0xLjUxNC00LjAzNC0zLjM4OGEuMzU5LjM1OSAwIDAgMC0uMDAzLS4wNDRjMC0uMDE1LjAwNi0uMDI3LjAwNi0uMDRsLS4yNzgtNS41MzhoNi43ODZ6TTM2LjIyNiA0Ni45NDZ2MTguMDk4YzAgLjc5OC42NDYgMS40NDUgMS40NDQgMS40NDVoMjQuNjVjLjc5OSAwIDEuNDQ1LS42NDcgMS40NDUtMS40NDVWNDYuOTQ2Yy41OS0uMzI4IDEuMTM3LS43MTkgMS41NzUtMS4yMiAxLjA2MS0xLjIxNCAxLjUyMi0yLjc4NSAxLjMwMS00LjQxLS4zLTIuMzU1LS42MDctNC43MDctLjkxOC03LjA2YTEuNDQzIDEuNDQzIDAgMCAwLTEuNDMxLTEuMjU3SDM1LjY5OWMtLjcyNCAwLTEuMzM4LjUzOC0xLjQzMSAxLjI1Ny0uMzExIDIuMzU0LS42MTcgNC43MDctLjkxNiA3LjA1LS4yMjEgMS42MzcuMjQgMy4yMDggMS4zIDQuNDIxLjQzOS41MDIuOTg0Ljg5MyAxLjU3NCAxLjIyeiIgZmlsbD0iI0NDQyIvPgogICAgPC9nPgo8L3N2Zz4K" width="48" height="48" alt="판매자 프로필 이미지">
					</a>
					<div class="sc-fdQOMr gozXAM">
						<a class="sc-fAJaQT kvtlkl" href="../page/userPage.jsp?mno=<%= pvo.getMno() %>">
							<%= dao.getNick(pvo.getMno()) %>
						</a>
					<div class="sc-cNnxps amrNP">
						<a class="sc-dPPMrM iEdtuR" href="../page/userPage.jsp?mno=<%= pvo.getMno() %>">
							<%= dao.getmdetail(pvo.getMno()) %>
						</a>
					</div>
					</div>
					</div>
					<div class="sc-hAnkBK dgHgxl">
						<a class="sc-geAPOV kWnRbz" href="/shop/77414854/products"></a>
					</div>
					<div class="sc-bJTOcE ZPKia">
<!-- 				상점후기	
					<div class="sc-PLyBE gMYroH">상점후기
						<span class="sc-clBsIJ fEDdTw">1</span>
					</div>
					<div class="sc-dPNhBE iXqvuW">
					<div class="sc-dBAPYN iafGxm">
						<a class="sc-dwztqd fcVzVM" href="/shop/79375251/products">
							<img src="" width="32" height="32" alt="프로필">
						</a>
						<div class="sc-dKEPtC kedHn">
							<div class="sc-dvpmds iWPzHr">
								<a class="sc-fgrSAo jdESkZ" href="/shop/79375251/products">닉네임</a>
								<div class="sc-jHXLhC cLHfak">날짜</div>
							</div>
							<div class="sc-bOCYYb hBTqKV">
							<div class="sc-drKuOJ lhBAnI">
							<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAcCAYAAAB2+A+pAAAAAXNSR0IArs4c6QAAArVJREFUSA2tVs1rE0EUf28TWr8uBQU/AqLGhAh+QWhrTECwePJiC1r0IHit4MU/Qw8evAoe9OZRTwqCNVEpaC+Wpqle4gfiURobdvN8b9JdZ7a7k822C8u++b3fx87sZFqAlBc1jpfkTikHJ60Qer1pdac0SB9MOANyp7wwjY7eF49Q1/0iWhzJHsWJ5a/D+qSbcdedDoL0OgAHF+mCUVtivR6cFzCGXmqaLx4EcNtEoLSIQADZHFaXvweuCYrhZ0zeFT9U/FXNWIIsgzJ8MNL/7+tbRWF+L+Y51FLTQmEvdLyfvLYZ3Y9NPNiZ2Y/l5m8dt9VZqufPAmZ22UhBb92bCodKTzBc781Ro/gy4NoK8tZQHXsePSWiMzbudvUQ8RO/5nUHz60swdjoBKJzr79DtyvC9BFvyVBZnGl8Y6oXLvL5+5hnf8iUbW3Es/wGjnMTK81XvpOxq1XDGT3FxGc+YatP5SWeWqh4GjPWQ+hN/haPHxDQHh1PWiPgH+bewVrrUZQmNljIVD+WBw+fcPh4lDgO49APkKEbWFltxXPiOhs40YUszLcXOfzEAKpqc+hnqOZOI752bXzjG0cSP7bHGC9E9qLBAvQ10d0NdHDwGs7wbLNWF62puKzRoMhycDDRbKTSBibQ2DfXQukA/O3Kn8BNL8hCdTzycTkVfgc+LHqwYySH5aUf4Z4/3mToN9Sz414Nh/Lvssuhd6HauiS31ILpOqVhrY6Fa3sw0jVdoHYsOeNYW73PYXwE8s01CCa7Wb9CWr0ldWwwvS0d5l/ypC/gkIeQ2VfGWnPRx/ynwqQnnOCiyb5HABhFbDCQWmb2gl/oOJex2rqNlUbHUGsD6SmOcFnT/88kfrktwTTLBi8Ad5/E8yvPtQxrqbiiEW2C3W2Y0bt8js/qOQNMMRAP8YqS/gMbzegG1X8tjgAAAABJRU5ErkJggg==" width="15" height="14" alt="작은 별점 2점 이미지">
							</div>
							</div>
							<div class="sc-iFUGim cEtXoK">
								리뷰내용
							</div>
						</div>
					</div>
					</div> -->
					<div class="sc-DNdyV gxpXGn"></div>
					</div>
					</div>
					</div>
					<div class="sc-imAxmJ YIppl">
						<div class="uploadbtn sc-hPeUyl fMYzPw">
							<a href="../chatting/chatCheck.jsp?pno=<%= pvo.getPno() %>">
								<label class="input-file-button">
									알쓸톡하기
								</label>
							</a>
						</div>
					</div>
					</div>
					</div>
					</div>
       </section>

        <!-- Related items section-->
        <section class="py-5" style="font-family:'godo';">
            <div class="container px-4 px-lg-5 mt-5">
                <h2 class="mb-4">판매목록</h2>
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo1.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class=""><%= pvo1.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo1.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo1.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo2.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder"><%= pvo2.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo2.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo2.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo3.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder"><%= pvo3.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo3.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo3.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="<%=imgvo4.getImg()%>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder"><%= pvo4.getTitle() %></h5>
                                    <!-- Product price-->
                                    <%= pvo4.getPrice() %>원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                	<a class="btn btn-outline-dark mt-auto" href="../write/detailBoots.jsp?pno=<%= pvo4.getPno() %>">상품 보러가기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Footer-->
        <jsp:include page="../main_login/mainFooter.jsp"/>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="../resources/js/detailBoots.js"></script>
    </body>
    <%
			}
    %>
</html>
