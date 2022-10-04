<%@page import="vo.LoginVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <% 
    	Object obj = session.getAttribute("logvo");
    	if(obj != null){
    		LoginVO vo = (LoginVO)obj;
    %>		
	    <style type="text/css">
	        @font-face {
		      font-family : 'godo';
		      src : url('../resources/css/GodoB.woff') format('woff');
		    }
	    </style>
    	<!-- Logined Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light" style="border-bottom : 1px solid rgb(229, 229, 229); font-family:'godo';">
            <div class="container px-4 px-lg-5">
            
                <a class="navbar-brand" href="../main_login/main.jsp"><img src="../images/bigalssle.png" alt="" width = "150px" /></a>
                
                    <ul class="navbar-nav mb-2 mb-lg-0 mainnav">
                        <li class="nav-item"><a class="nav-link" href="../chatting/chatCheck.jsp">알쓸톡</a></li>
                        <li class="nav-item dropdown sbtn">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            	<%=vo.getNickname() %>님 환영합니다
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="../page/mypage.jsp">마이페이지</a></li>
                                <li><a class="dropdown-item" href="../write/write.jsp">판매하기</a></li>
                                <li><hr class="dropdown-divider" /></li>
                                <li><a class="dropdown-item" href="../main_login/logout.jsp">로그아웃</a></li>
                            </ul>
                        </li>
                    </ul>

            </div>
        </nav>	
    		
    		
    <%		
    	}else{
    %>		
    		
<!-- Not Logined Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light" style="border-bottom : 1px solid rgb(229, 229, 229); font-family:'godo';">
        
            <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="../main_login/main.jsp"><img src="../images/bigalssle.png" alt="" width = 150px" /></a>
                
                    <ul class="navbar-nav mb-2 mb-lg-0 mainnav">
                        <li class="nav-item"><a class="nav-link" href="../main_login/login.jsp">알쓸톡</a></li>
                        <li><a class="nav-link sbtn" href="../main_login/login.jsp">로그인/회원가입</a></li>
                    </ul>
            </div>
        </nav>
    		
    <%		
    	}
    
    %>
    