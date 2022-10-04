package dao;

import java.util.ArrayList;

import chattingServlet.ChatListServlet;
import vo.ChatVO;

public class DAO_test {
	public static void main(String[] args) {
		ChatDAO dao = new ChatDAO();
		
//		dao.getRoomNo(10, 30);
//		dao.getRoomNo(10, 20);
		
		ArrayList<ChatVO> list = dao.chatRoomList(15);
		for(ChatVO l : list) {
			System.out.println(l.getRno());
			System.out.println(l.getTitle());
		}
		
		
//		ArrayList<ChatVO> list = dao.getChatList(2);
//		for(int i=0; i<list.size(); i++) {
//			System.out.println(list.get(i).getNickname());
//			System.out.println(list.get(i).getCdetail());
//			System.out.println(list.get(i).getCtime());
//		}
		
//		ChatVO vo = dao.getRecentChat(1, 9);
//		if(vo !=null) {
//			System.out.println(vo.getCdetail());
//
//		}else {
//			System.out.println("null");
//		}
		
		ChatListServlet chat = new ChatListServlet();
//		chat.getChatList(1);
//		chat.getChatList(1);
//		chat.getChatList(1);
//		chat.getChatList(1);
//		if(chat.getChatList(3) != null) {
//			System.out.println("값 있음 : "+chat.getChatList(3));
//		}else {
//			System.out.println("값 없음");
//		}

		
		

	}
}
