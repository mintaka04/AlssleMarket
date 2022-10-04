<%@page import="vo.LoginVO"%>
<%@page import="dao.ChatDAO"%>
<%@page import="chattingServlet.ChatListServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
		// 여기는 상품 목록에서 넘어오는 페이지
 		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		String para = request.getParameter("pno");
		LoginVO user = (LoginVO)session.getAttribute("logvo");
		
		if(user !=null){ // 세션이 없으면 main.jsp 로
			if(para != null){
				int pno = Integer.parseInt(para);

				// 세션 확인해서 mno 가져오기
				int mno = user.getMno();
				
				ChatDAO dao = new ChatDAO();
				int rno = dao.getRoomNo(pno, mno);
				
				System.out.println("rno : "+rno +" "+"pno : "+pno+" mno : "+mno);
				//System.out.println("name : "+request.getParameter("name"));
				
				dao.systemChatting(rno);
				
				response.sendRedirect("./chat.jsp?rno="+rno);
				
			}else{
				response.sendRedirect("./chat.jsp");
			}
		}else{
			response.sendRedirect("../main_login/login.jsp");
		}


%>