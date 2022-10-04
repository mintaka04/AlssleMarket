<%@page import="vo.LoginVO"%>
<%@page import="vo.ChatVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.ChatDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	// 채팅방 만들어질때 바로 나오도록 만들기 => 메서드 하나 추가해서 알쓸톡 시작합니다 내용 인서트되도록 만들기

	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	
	String para = request.getParameter("rno");
	int rno = 0;
	if(para != null){
		rno = Integer.parseInt(para);
	}else{
		rno = 0;
	}

	// 세션 확인
	LoginVO user = (LoginVO)session.getAttribute("logvo");
	if(user == null){
		response.sendRedirect("../main_login/login.jsp");
	}
	
	// 세션에서 닉네임 가져오기 && mno 가져오기
	// String nickName = request.getParameter("nickName");
	String nickName = user.getNickname();
	int mno = user.getMno();
	
	// 세션에서 가져온 mno로 roomlist 가져오기
	ArrayList<ChatVO> roomList = new ChatDAO().chatRoomList(mno);

%>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<html>
<head>
<title>AlssleTalk</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="../chat_resources/css/chat.css">
<style>
	#sysMsg{
	  display: inline-block;
	  padding: 0 0 0 10px;
	  vertical-align: top;
	  width: 75%;
	  margin-left:25%;	
	}
	
	.buyBtn{
		border: 3px solid #ff5f2e;
	
	    background-color: red;
	    color: #e1eef6;
	        
        position: relative;
	    /* padding: 15px 30px; */
	    border-radius: 15px;
	    font-family: "paybooc-Light", sans-serif;
	    text-decoration: none;
	    font-weight: 600;
	    transition: 0.25s;
	    
	    float:right;
	    
    }
    
    .buyBtn:hover {
    	letter-spacing: 2px;
	    cursor: pointer;
	}

</style>
<script type="text/javascript">
	var lastID = 0;
	var rno = <%=rno %>;
	var nickName = "<%=nickName %>";
	var lastChat = "";
	var lastTime = "";
	var buyUser;
	var p_mno;
	
	// 해결해야 하는 것 어떻게 '다른' 컴퓨터에서 변화하는 cno 값을 체크할지
	
	
	// 페이지가 로딩되면 실행
	$(function(){

		// 페이지가 로딩되면 전체 채팅 내역 가져오기
		chatListAll();
		chatRoomList();
		
		// 1초마다 최신내역 불러오기
		getInfiniteChat();
		
		$(document).on("keydown", function(e){
			if(e.keyCode == 13){
				submitFunction();
			}
		})
		
/* 		// buyBtn 눌렀을 때 판매완료
		$(".buyBtn").on("click", function(){
			buyProduct();
		}) */
		
		
	})

	// 메시지 관련 alert
	function autoClosingAlert(selector, delay){
		var alert = $(selector).alert();
		alert.show();
		window.setTimeout(function() {alert.hide()}, delay);
	}
	
	// 메시지 전송
	function submitFunction(){
		//console.log("test")
		var chatContent = $("#chatContent").val();
		
		$.ajax({
			type: "POST",
			url : "chatSend",
			data: {
				roomNo : rno,
				chatName : nickName,
				chatContent : chatContent
			},
			success : function(result){
				console.log(result)
				//alert("전송")
				if(result == 1){
					$("#chatContent").val("");
					

					//alert("전송에 성공 완료");
					//autoClosingAlert("#successMessage", 2000);
				}else if(result == 0){
					//alert("이름과 내용 정확히 입력");
					//autoClosingAlert("#dangerMessage", 2000);
				}else{
					//alert("DB error");
					//autoClosingAlert("#warningMessage", 2000)
				}
			}
		})
		
	}
	
	// => chatVO 에서 넘어오는건 순서대로 nickname, cdetail, ctime
	// 메시지 리스트 불러오기 2가지
	// 페이지 불러올때 한번만
	function chatListAll(){
		//console.log(type)
		$.ajax({
			type: "POST",
			url: "chatList",
			data: {
				roomNo : rno,
				listType: "getAll",
				lastID : lastID
			},
			success: function(data) {
				//console.log("data : "+data)
				
				if(data == "") {
					//console.log("여기");
					
					return;
				}
				
				var parsed = JSON.parse(data);
				var result = parsed.result;
				lastMessage(result);
				//console.log(data)
				
				
				
				for(var i = 0; i < result.length; i++) {
					addChat(result[i][0].value, result[i][1].value, result[i][2].value);
				}
				lastID = Number(parsed.last);
				//console.log("lastID : "+lastID);
				

			}

		});
	}
	
	// 최신 메시지 내역 1초마다 불러오기
	function chatListRecent(){
		// 가장 마지막에 저장된 채팅 내역 불러오기
		//console.log(lastChat);
		
		//console.log(type)
		$.ajax({
			type: "POST",
			url: "chatList",
			data: {
				roomNo : rno,
				listType: "getRecent",
				lastID : lastID
			},
			success: function(data) {
				//console.log("data : "+data)
				if(data == "") {
					//console.log("여기");
					
					return;
				}
				
				var parsed = JSON.parse(data);
				var result = parsed.result;
				lastMessage(result);
				
				//console.log(data)
				
				for(var i = 0; i < result.length; i++) {
					addChat(result[i][0].value, result[i][1].value, result[i][2].value);
				}
				lastID = Number(parsed.last);
				//console.log("lastID : "+lastID);
				
			}

		});
	}
	
	// 채팅 내역 출력
	function addChat(chatName, chatContent, chatTime) {
		
		// chatVO에서 넘어온 chatName 이 현재 페이지의 nickName 과 동일하면 
		// 왼쪽에서 채팅 내역 출력
		// 아니면 오른쪽에서 출력
		if(chatName == nickName){
			
				$('#chatList').append(

						'<div class="incoming_msg">'+
						'<div class="received_msg">'+
						'<div class="received_withd_msg">'+
						'<p>'+
						chatName +
						'</p>'+
						'<p>'+ chatContent +'</p>'+
						'<span class="time_date">'+
						chatTime+
						'</span>'+
						'</div>'+
						'</div>'+
						'</div>'
						
				);	

		}else{
			// 구매자 닉네임 저장
			buyUser = nickName;
			
				if(chatName == 'SYSTEM' && chatContent == '알쓸톡 시작!'){
					
					$('#chatList').append(
							'<div class="incoming_msg">'+
							'<div class="received_msg" id="sysMsg">'+
							'<div class="received_withd_msg">'+
	
							'<p><center>'+
							chatContent +
							'</center></p>'+
	
							'</div>'+
							'</div>'+
							'</div>'
							
					);
					
				}else{
					
					$('#chatList').append(
							
							'<div class="outgoing_msg">'+
							'<div class="sent_msg">'+
							'<p>'+
							chatName +
							'</p>'+
							'<p>'+ 
							chatContent +
							'</p>'+
							'<span class="time_date">'+
							chatTime+
							'</span>'+
							'</div>'+
							'</div>'+
							'</div>'
	
					);
				}
		}
		
		// 자동 스크롤
		$('#chatList').scrollTop($('#chatList')[0].scrollHeight);

	}
	
	// (왼쪽)채팅방 목록
 	function chatRoomList(){
		// 현재 rno 와 선택된 rno 가 일치하면 
		// 현재 활성화된 채팅으로 보여주고, 아니면 일반 채팅 목록으로
		console.log(lastTime);
		
		<%
			for(ChatVO list : roomList){
				//System.out.println("detail : "+list.getCdetail());
				String title = list.getTitle();
				String detail = list.getCdetail();
				String time = list.getCtime().split(" ")[0];
				int roomNo = list.getRno();
				int p_mno = list.getMno();
				int pno = list.getPno();
				
		%>
			var title = "<%=title %>";
			var detail = "<%=detail %>";
			var time = "<%=time %>";
			var roomNo = <%=roomNo %>;
			var status = "<%=list.getStatus() %>";
			var pno = <%=pno%>;
			
			
			// 현재 rno 와 가져온 roomNo 가 동일하다면 활성화 된 상태의 채팅목록
			if(roomNo == <%=rno%>){
				
		 		$('#chatRoomList').append(

 					    '<div class="chat_list active_chat">'+
					    '<div class="chat_people">'+
					     '<div class="chat_ib">'+
					     '<h5><a href="./chat.jsp?rno='+
					    roomNo+
					    '">'+ 
					    title + 
					    "<"+
					    status+
					    ">"+
					    '</a>'+
					     '<span class="chat_date" id="active_lastChatDate">'+
					     time +
					     '</span></h5>'+
					     <% if(mno == p_mno && list.getStatus().equals("판매중")){%>
					     


					     	//'<input type="button" class="buyBtn" value="판매완료">'+
					     	'<input type="button" class="buyBtn" value="판매확인" onclick="buyProduct('+pno+')">'+

					     <%}%>
					     
					     '<p id="active_lastChat">' +
					     detail + 
					     '</p>'+
					     '</div>'+
					    '</div>'+
					  	'</div>'
					);
		 		
			}else{ // 다르면 비활성화된 상태의 채팅목록
				
		 		$('#chatRoomList').append(
						// 나머지 채팅 목록
						'<div class="chat_list">'+
						'<div class="chat_people">'+
						'<div class="chat_ib">'+
					     '<h5><a href="./chat.jsp?rno='+
						 roomNo+
						 '">'+ 
						title +
						'</a>'+
						'<span class="chat_date">'+
						time +
						'</span></h5>'+
						'<p>'+
						detail +
						'</p>'+
						'</div>'+
						'</div>'+
						'</div>'

					);
				// 나머지 채팅 목록
				//<div class="chat_list">
				//<div class="chat_people">
				// <div class="chat_ib">
				//  <h5>Sunil Rajput <span class="chat_date">Dec 25</span></h5>
				//   <p>Test, which is a new approach to have all solutions 
				//       astrology under one roof.</p>
				//</div>
				//</div>
				//</div>
			}
		<%
			}
		%>

	
	}

	
	function getInfiniteChat() {
		//console.log("실행중")
		setInterval(function() {
			chatListRecent();
		}, 1000);
		
		//setInterval(function(){
			//$('#chatRoomList').load(location.href+' #chatRoomList');
		//	$('#chatList').load(location.href+' #chatList');
			
		//	chatListRecent();
		//}, 2000)
		
<%-- 		<%
			System.out.println("js && java TEST");
		%> --%>
	}
	
	// 채팅 목록 최신화
	function lastMessage(message){
		//console.log("last message")
		// 맨 마지막 채팅 내역 저장
		lastChat = message[message.length-1][1].value;
		
		var array = message[message.length-1][2].value.split(" ");
		lastTime = array[0];
		//console.log(lastTime);
		
		// 목록 update
		$("#active_lastChat").html("<p id='active_lastChat'>"+ lastChat + "</p>");
		$("#active_lastChatDate").html('<span class="chat_date" id="active_lastChatDate">'+ lastTime + '</span></h5>');
	}

	// 구매 완료
	function buyProduct(pno){

		console.log("pno : "+pno);
		location.href = "buyPro.jsp?pno="+pno+"&buyUser="+buyUser+"&rno="+rno;
	}
	
</script>

</head>
<body>
	<jsp:include page="../main_login/mainNav.jsp"/>	

<div class="container">
<div class="messaging">
      <div class="inbox_msg">
        <div class="inbox_people">
          <div class="headind_srch">
            <div class="recent_heading">
              <h4>Recent</h4>
            </div>
            <div class="srch_bar">
<!--               <div class="stylish-input-group">
                <input type="text" class="search-bar"  placeholder="Search" >
                <span class="input-group-addon">
                <button type="button"> <i class="fa fa-search" aria-hidden="true"></i> </button>
                </span> 
               </div> -->
            </div>
          </div>
          <!-- 채팅목록 출력 영역 -->
          <div class="inbox_chat" id="chatRoomList">

          </div>
        </div>
        <div class="mesgs">
          <div class="msg_history" id='chatList'>
            <!-- 메시지 출력 영역 -->
          </div>
          
          <!-- 메시지 작성 영역 -->
          <div class="type_msg">
            <div class="input_msg_write">
              <input type="text" class="write_msg" id="chatContent" placeholder="Type a message" />
              <button class="msg_send_btn" type="button" onclick="submitFunction()"><i class="fa fa-paper-plane-o" aria-hidden="true"></i></button>
            </div>
          </div>
        </div>
      </div>
      
      
     <!--  Design by Sunil Rajput - https://www.linkedin.com/in/sunil-rajput-nattho-singh  -->
      
    	</div>
    </div>
    
    <jsp:include page="../main_login/mainFooter.jsp"/>
    
    </body>
    </html>