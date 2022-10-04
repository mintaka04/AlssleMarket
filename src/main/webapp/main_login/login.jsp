<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
</head>
<style>
	html, body{
		width : 100%;
		height : 100%;
		margin : 0;
	}
	#total{
		position : absolute;
		left : 50%;
		top : 45%;
		transform : translate(-50%, -50%);
	}
	#login-form{
		text-align : center;
	}
	
	
	#logo-div{
		margin-bottom : 10px;
	}
	#imgalssle{
		width : 230px;
	}
	
	
	#id-insert{
		margin-bottom : 8px;
	}
	#pw-insert{
		margin-bottom : 20px;
	}
	#insert-text{
		text-align : left;
		font-size : 14px;
		font-weight : bold;
		color : #d80c18;
	}
	input[type=text], input[type=password]{
		width : 280px;
		height : 28px;
		font-size : 14px;
		margin : 8px 0px;
		border : solid 2px #d80c18;
		padding : 0px 5px;
	}
	input[type=text]:focus, input[type=password]:focus{ outline : none;}
	input[type=button]{
		width : 145px;
		border : 2px solid #d80c18;
		background-color : rgba(0,0,0,0);
		color : #d80c18;
		font-weight : bold;
		padding : 5px;
		margin : 5px 0px;
	}
	input[type=button]:hover{
		color : white;
		background-color : #d80c18;
	}
	#warning{
		background-color : #d80c18;
		color : white;
		height : 28px;
		text-align : center;
		padding-top : 5px;
	}
	#warningdiv{
		margin-top : 10px;
		height : 28px;
	}
	
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type = "text/javascript">
	window.onload = function(){
		var btn1 = document.getElementById("btn1");
		var btn2 = document.getElementById("btn2");
		
		btn1.onclick = function(){
			document.frm.action="../main_login/loginOk.jsp";
			document.frm.method = "get";
			document.frm.submit();
		}
		
		btn2.onclick = function(){
			document.frm.action="../main_login/register.jsp";
			document.frm.method = "get";
			document.frm.submit();
		}
	}
	
	function warningshowhide(){
		$("#warning").show().delay(700).fadeOut(2300);
	}
	
</script>
<body>
<div id = total>
		<div id = login-form>
		
			<!-- 로고영역 -->
			<div id = logo-div>
				<div id = image-logo>
					<a href="../main_login/main.jsp">
						<img src="../images/bigalssle.png" alt="alssleIcon" id = "imgalssle" />
					</a>
				</div>
			</div>
			
			
			<!-- form 영역 -->
			<form action = "../main_login/loginOk.jsp" name = "frm">
				<div id = insert-div>
					<div id = id-insert>
						<div id = insert-text>Email</div>
						<input type="text" name = "email" id = "email"/>
					</div>
					<div id = pw-insert>
						<div id = insert-text>Password</div>
						<input type="password" name = "pw"/>
					</div>
				</div>
				
				<div id = button-div>
					<input type="button" id = "btn1" value = "로그인"/>
					<input type="button" id = "btn2" value = "회원가입" />
				</div>
			</form>
			
		</div>
		
		
		
		<!-- 경고창영역 -->
		<div id="warningdiv">
		
		<% 
			if(request.getParameter("msg") != null){
		%>
			<div id = "warning">
				Login failed
			</div>
			<script>warningshowhide();</script>
		<%
			}else{
		%>
			<div id = "warning" style = "display:none">
				css 안밀리게 하려고 넣어줌
			</div>
		<%
			}
		%>
		</div>
</div>
</body>
</html>