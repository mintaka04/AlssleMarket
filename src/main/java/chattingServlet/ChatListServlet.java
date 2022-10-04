package chattingServlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ChatDAO;
import vo.ChatVO;

@WebServlet("/chatting/chatList")
public class ChatListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
	ChatDAO dao = new ChatDAO();
	
	// 모든 메소드의 결과는 JSON 형태로 만들어져서 RETURN 됨
	// 모든 메소드는 예외(에러) 가 발생 시 "" 을 return
		
    protected void doPost(HttpServletRequest request, HttpServletResponse response ) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // listType 는 2가지로 전체 채팅 목록을 가져오기는 getAll 와 가장 최근의 리스트만 가져오는 getRecent 가 있음
        String listType = request.getParameter("listType");
        
        // 방번호로 채팅 내역을 조회하기 위한 roomNo
        int roomNo = Integer.parseInt(request.getParameter("roomNo"));
        
        // 가장 최근의 내역을 조회해오기 위한 recentCno 로 이 값은 jsp 에서 가장 마지막의 채팅 번호 - cno - 를 저장하고 있는 값이다.
        // 따라서 recentCno 와 ChatDAO 에서 저장하고 잇는 recentCno 를 비교해서
        // 만약 이 값이 서로 다르면 최근에 채팅이 업데이트가 됨을 알 수 있고, 새로운 채팅 내역을 조회해 오게 됨
        int recentCno = Integer.parseInt(request.getParameter("lastID"));
        
        //System.out.println("cno : "+recentCno);
 		//System.out.println("recentCno : "+Socket.recentCno);

        
        try {
        	// 넘어오는 listType 가 null 이거나 비어잇는 경우 "" 를 jsp 로 return
        	 if(listType == null || listType.equals("")) response.getWriter().write("");
        	 
     	    // listType 이 getAll 인 경우 getChatList 를 return 함
     	    else if(listType.equals("getAll")) {
     	    	response.getWriter().write(getChatList(roomNo));

     	    }
     	    else if(listType.equals("getRecent")) { // getRecent 인 경우 가장 최신의 채팅 내역이 있는지 조회하고 가져오게 됨
     	    	//System.out.println("getrecnet");

     	    	// DAO 의 recentCno 가 jsp 에서 보내준 값과 다르면 최신 내역 출력
     	    	if(ChatDAO.recentCno != recentCno) {
     	    		response.getWriter().write(getRecentList(roomNo, recentCno));
     	    		ChatDAO.recentCno = recentCno;

     	    	}else {
     	    		response.getWriter().write("");
     	    	}
     	    }
         
        }catch(Exception e) {
        	response.getWriter().write("");
        }
	   
    }
    
    // 전체 채팅 내역을 조회해온 후 JSON 형태로 묶어서 return 하는 메소드
	private String getChatList(int rno) {

		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		
		// 여기는 rno 가 들어가야함
		ArrayList<ChatVO> chatList = dao.getChatList(rno);
		//System.out.println("size : "+chatList.size());

		try {
			for(int i = 0; i < chatList.size(); i++) {
				result.append("[ {\"value\": \"" + chatList.get(i).getNickname() + "\"},");
				result.append("{\"value\": \"" + chatList.get(i).getCdetail() + "\"},");
				result.append("{\"value\": \"" + chatList.get(i).getCtime() + "\"}]");
				
				if(i != chatList.size() -1) result.append(",");
			}
			
			result.append("], \"last\":\"" +  chatList.get(chatList.size() - 1).getCno() + "\"}");
			//System.out.println("size :  "+chatList.size());
			return result.toString();

		}catch(Exception e) {
			return "";
		}

	}
	
	// 가장 최신의 채팅 내역만 조회해온 후 JSON 형태로 잘라서 return 하는 메소드
	private String getRecentList(int rno, int cno) {
				
		//System.out.println("실행중");
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		
		try {
		// 여기는 rno 가 들어가야함
		ChatVO chat = dao.getRecentChat(rno, cno);
		
		// 결과를 가져올 수 있다면 JSON 형태로 묶음
			if(chat !=null) {
				result.append("[ {\"value\": \"" + chat.getNickname() + "\"},");
				result.append("{\"value\": \"" + chat.getCdetail() + "\"},");
				result.append("{\"value\": \"" + chat.getCtime() + "\"}]");
				result.append("], \"last\":\"" +  chat.getCno() + "\"}");
	
				return result.toString();
		
			}else {
				return "";
			}
			
		}catch(Exception e) {
			e.getMessage();
			return "";
		}

	}
}
