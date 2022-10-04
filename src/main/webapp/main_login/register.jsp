<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

<style>
	html, body{
		width : 100%;
		height : 100%;
		margin : 0;
	}
	#total{
		position : absolute;
		left : 50%;
		top : 50%;
		transform : translate(-50%, -50%);
	}
	#register-form{
		text-align : center;
	}
	#logo-div{
		margin-bottom : 10px;
	}
	img{
		width : 230px;
	}



	#id-insert, #pw-insert, #pwcheck-insert, #nickname-insert{
		margin-bottom : 8px;
	}
	#pnum-insert{
		margin-bottom : 30px;
	}
	.insert-text{
		text-align : left;
		font-size : 14px;
		color : #d80c18;
		font-weight : bold;
	}
	#ryp, #eml, #pn{
		float : left;
	}
	
	
	.check{
		float : right;
		text-align : right;
		padding-top : 5px;
		font-size : 11px;
		color : white;
		font-weight : bold;
		background-color : #d80c18;
		padding-bottom : 1px;
		padding-right : 4px;
		padding-left : 3px;
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
	input[type=button], input[type=reset]{
		width : 145px;
		border : 2px solid #d80c18;
		background-color : rgba(0,0,0,0);
		color : #d80c18;
		font-weight : bold;
		padding : 5px;
		margin : 5px 0px;
	}
	input[type=button]:hover, input[type=reset]:hover{
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
	input::placeholder {
  		color: rgb(160, 160, 160);
  		font-size : 12px;
	}
	input::-webkit-input-placeholder {
  		color: rgb(160, 160, 160);
  		font-size : 12px;
	}
	input:-ms-input-placeholder {
  		color: rgb(160, 160, 160);
  		font-size : 12px;
	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="../resources/js/httpRequest.js"></script>
<script type = "text/javascript">

	var daoemail = "false";
	var xhr = null;
	function getXMLHttpRequest() {
		if (window.ActiveObject) {
			try {
				return new ActiveObject("MsMXL2.XMLHttp");
			} catch (e) {
				try {
					return new ActiveXObject("Microsoft.XMLHttp");
				} catch (e) {
					null;
				}
			}
		}else if(window.XMLHttpRequest){
			return new XMLHttpRequest();
		}else{
			return null;
		}
	} 
	
	function daocheck(email){
		xhr=getXMLHttpRequest(); 
		xhr.onreadystatechange=callback;
		var params = "../main_login/idCheck.jsp?email="+email;
		xhr.open("GET", params, true);
		xhr.send(null);
	}
	
	function callback(){
		console.log(xhr.readyState);
		if(xhr.readyState == 4){	
			if(xhr.status==200){
				var msg = xhr.responseText.trim();
				if(msg=="true"){
					daoemail="false";
					var emlchk = document.getElementById("emlchk");
					emlchk.innerHTML = "Email already in Use";
					$("#emlchk").show();
				}else{
					daoemail="true";
				}
			}
		}
	}
	
	var pwchkchk = "false";
	var emlchkchk = "false";
	var pnumchkchk = "false";
	
	$(function(){
		$("#pwcheck").on("keyup", repeatcheck);
		$("#email").on("keyup", emailcheck);
		$("#pnum").on("keyup", pnumcheck);
		$("#btn1").on("click", checkregform);
	})
	
	function repeatcheck(){
		var txt = $("#pwcheck").val().trim();
		var pw = $("#pw").val().trim();
		if(txt==pw){
			$("#pchk").hide();
			pwchkchk = "true";
		}else{
			$("#pchk").show();
			pwchkchk = "false";
		}
	}
	
	function emailcheck(){
		var emlchk = document.getElementById("emlchk");
		emlchk.innerHTML = "Invalid email address";
		var email = $("#email").val();
		var regExp = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.[a-zA-Z]{2,4}$/;
		if(!regExp.test(email)){
			$("#emlchk").show();
			emlchkchk = "false";
		}else{
			$("#emlchk").hide();
			emlchkchk = "true";
			daocheck(email);
		}
	}
	
	function pnumcheck(){
		var pnum = $("#pnum").val();
		var regExp =  /(\d{2}|\d{3})[-](\d{4}|\d{3})[-]\d{4}$/;
		if(!regExp.test(pnum)){
			$("#pnumchk").show();
			pnumchkchk = "false";
		}else{			
			$("#pnumchk").hide();
			pnumchkchk = "true";
		}
	}
	
	function checkregform(){
		var email = $("#email").val();
		var pw = $("#pw").val();
		var repw = $("#pwcheck").val();
		var nickname = $("#nickname").val();
		var pnum = $("#pnum").val();		
		
		if(email==""){
			$("#email").focus();
			warningshowhide();
			return;
		}else if(emlchkchk == "false"){
			$("#email").empty();
			return;
		}else if(daoemail=="false"){
			$("#emlchk").show();
			$("#email").empty();
			return;
		}else if(pw == ""){
			$("#pw").focus();
			warningshowhide();
			return;
		}else if(pwchkchk == "false"){
			$("#pwcheck").empty();
			return;
		}else if(nickname ==""){
			$("#nickname").focus();
			warningshowhide();
			return;
		}else if(pnum==""){
			$("#pnum").focus();
			warningshowhide();
			return;
		}else if(pnumchkchk =="false"){
			$("#pnum").empty();
			return;			
		}else{
			$("#frm").submit();
		}
	}
	
	function warningshowhide(){
		$("#warning").show().delay(700).fadeOut(2300);
	}
	
	
	
</script>
</head>
<body>
	<div id = total>
		<div id = register-form>
		
		
			<div id = logo-div>
				<div id = image-logo>
					<a href="../main_login/main.jsp">
						<img src="../images/bigalssle.png" alt="alssleIcon" />
					</a>
				</div>
			</div>
			
			
			<form action = "registerOk.jsp" name = "frm" id = "frm" method="get">
				<div id = insert-div>
					<div id = id-insert>
						<div class = "txtx">
							<div class = insert-text id = "eml">Email</div>
							<div class = check  id="emlchk" style="display:none">Invalid email address</div>
						</div>
						<input type="text" name = "email" id = "email" placeholder = "ex) alssle@alssle.com"/>
					</div>
					<div id = pw-insert>
						<div class = insert-text>Password</div>
						<input type="password" name = "pw" id = "pw"/>
					</div>
					<div id = pwcheck-insert>
						<div class = "txtx">
							<div class = "insert-text" id = "ryp">Repeat your password</div>
							<div class = check id="pchk" style="display:none">Password must be equal</div>
						</div>
						<input type="password" name = "pwcheck" id = "pwcheck"/>
					</div>
					<div id = nickname-insert>
						<div class = insert-text>Nickname</div>
						<input type="text" name = "nickname" id = "nickname"/>
					</div>
					<div id = pnum-insert>
						<div class = "txtx">
							<div class = insert-text id = "pn">Phone Number</div>
							<div class = check  id="pnumchk" style="display:none">Invalid phone number</div>
						</div>
						<input type="text" name = "pnum" id="pnum" placeholder="ex) 000-0000-0000"/>
					</div>
				</div>
				
				
				<div id = button-div>
					<input type="button" id = "btn1" value = "회원가입"/>
					<input type="reset" id = "btn2" value = "취소" />
				</div>
			</form>
		</div>		
		
		
	<div id="warningdiv">
		<div id = "warning" style = "display:none">
			Please fill all the required fields
		</div>
	</div>
	
	
</div>
</body>
</html>