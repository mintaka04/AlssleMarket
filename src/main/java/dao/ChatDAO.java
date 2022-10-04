package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import vo.ChatVO;

public class ChatDAO {
	// 가장 최신의 채팅 내역을 조회해오기 위해 사용되는 static recentCno.
	// 이 값은 가장 마지막 cno 를 jsp 에 넘기기 전에 해당 recentCno 와 동일한 값이 저장되고 이후 채팅을 submit 할때마다 이 값이 +1 됨
	// 즉 submit 한 후 +1 된 DAO의 recentCno 값과 jsp 에서 넘어오는 recentCno 값이 다른 경우 새로운 채팅 내역이 있다고 확인되고 새로운 채팅 내역을 불러오게 됨 
	public static int recentCno = 0;
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	StringBuffer sb = new StringBuffer();
 
	public ChatDAO() {
		
		conn = MakeConnection.getInstance().getConnection();
		
	}
	
	// 채팅 방번호 가져오기 : pno 와 mno 로 검색 후 있으면 해당 rno 가져오기
	public int getRoomNo(int pno, int mno) {
		
		String sql = "SELECT RNO FROM CHATTINGROOM WHERE PNO = ? AND MNO = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, pno);
			pstmt.setInt(2, mno);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				int roomNo = rs.getInt("RNO");
				//System.out.println("방번호 : "+roomNo);
				
				return roomNo;
			}else {
				
				return createChatRoom(pno, mno);
				
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
		}

	}
	
	// CHATTINGROOM 이 없는 경우 생성 => 
	// pno 와 mno 를 넣어서 생성 -> 이후 다시 rno 가져오기 실행
	private int createChatRoom(int pno, int mno) {
		// SQL 부분은 추후 고쳐야함 => DB 컬럼에 맞게
		String sql = "INSERT INTO CHATTINGROOM VALUES(NULL, ?, ?)";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, pno);
			pstmt.setInt(2, mno);
			
			pstmt.executeUpdate();
			System.out.println("방 생성 완료");

			return getRoomNo(pno, mno);

			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
		}
		
	
	}
	
	// 채팅방 신규 생성에 따른 시스템 채팅 추가
	public void systemChatting(int rno) {
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String nowdate = sdf.format(timestamp);
		
		sb.setLength(0);
		sb.append("INSERT INTO CHATTING VALUES(NULL, 'SYSTEM', '알쓸톡 시작!', ?, ?)");
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, nowdate);
			pstmt.setInt(2, rno);
			
			pstmt.executeUpdate();
			System.out.println("신규 채팅 방 생성에 따른 시스템 메시지 입력 완료");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
	}
	

	// input method 정상적인 값은 1 , 아니면 -1
	public int submit(int rno, String nickName, String chatContent ) {
		// chatting date 에 해당하는 현재 날짜 구하기 => nowdate
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String nowdate = sdf.format(timestamp);
		
		String sql = "INSERT INTO CHATTING VALUES (NULL, ?, ?, ?, ?)";

		int result = -1;

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nickName);
			pstmt.setString(2, chatContent);
			pstmt.setString(3, nowdate);
			pstmt.setInt(4, rno);


			result = pstmt.executeUpdate();

			return result;

		} catch (SQLException e) {
			e.printStackTrace();

			return result;

		}
//		finally{
//			try{
//				if(rs != null) rs.close();
//				if(pstmt != null) pstmt.close();
//				if(conn != null) conn.close();
//
//			} catch (SQLException e) {
//				e.printStackTrace();
//
//			}
//		}

	}
	
	// 이전의 전체 채팅내역 가져오기
	public ArrayList<ChatVO> getChatList(int rno) {
		ArrayList<ChatVO> list = new ArrayList<>();
		String sql = "SELECT CNO, NICKNAME, CDETAIL, CTIME FROM CHATTING WHERE RNO = ? ORDER BY CTIME";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, rno);

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				//System.out.println("실행됨");
				ChatVO chat = new ChatVO();
				chat.setCno(rs.getInt("CNO"));
				chat.setNickname(rs.getString("NICKNAME"));
				chat.setCdetail(rs.getString("CDETAIL"));
				chat.setCtime(rs.getString("CTIME"));
				chat.setRno(rno);
				
				//System.out.println(rs.getInt("RNO"));
				
				list.add(chat);
			}


		} catch (SQLException e) {
			e.printStackTrace();
		}
//		finally{
//			try{
//				if(rs != null) rs.close();
//				if(pstmt != null) pstmt.close();
//				if(conn != null) conn.close();
//
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
//		}

		return list;
	}
	
	// 가장 최신의 채팅 내역 가져오기
	public ChatVO getRecentChat(int rno, int mno) {
		String sql = "SELECT CNO, NICKNAME, CDETAIL, CTIME FROM CHATTING WHERE RNO = ? AND CNO > ? ";
		ChatVO vo = new ChatVO();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, rno);
			pstmt.setInt(2, mno);
			
			rs = pstmt.executeQuery();
			//System.out.println(rs.next());
			
			if(rs.next()) {
				vo.setCno(rs.getInt("CNO"));
				vo.setNickname(rs.getString("NICKNAME"));
				vo.setCdetail(rs.getString("CDETAIL"));
				vo.setCtime(rs.getString("CTIME"));
				vo.setRno(rno);
				
				//System.out.println("DB 에서 가져옴 : "+vo);
				return vo;
			}else {
				//System.out.println(vo);

				return null;
			}

			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		
	}
	
	// 채팅 목록 가져오기
	public ArrayList<ChatVO> chatRoomList(int mno){
		ArrayList<ChatVO> list = new ArrayList<>();
		sb.setLength(0);
		// CASE 3번이 사용중인 쿼리문
		
		// CASE 1
		//sb.append("SELECT RNO, NICKNAME, CDETAIL, CTIME, P.TITLE FROM CHATTING C NATURAL JOIN CHATTINGROOM R, PRODUCT P ");
		//sb.append("WHERE R.MNO = ? OR ");
		//sb.append("(R.PNO, P.TITLE) IN (SELECT PNO, P.TITLE FROM MEMBER M NATURAL JOIN PRODUCT P WHERE M.MNO = ?) ");
		//sb.append("GROUP BY RNO ORDER BY CTIME");
		
		// CASE 2
		//sb.append("SELECT P.TITLE, P.PNO, RNO, NICKNAME, CDETAIL, CTIME FROM CHATTING C NATURAL JOIN CHATTINGROOM R INNER JOIN PRODUCT P ");
		//sb.append("ON (P.PNO = R.PNO) ");
		//sb.append("WHERE R.MNO = ? ");
		//sb.append("OR ");
		//sb.append("(P.PNO, P.TITLE) IN (SELECT PNO, TITLE FROM PRODUCT WHERE PNO IN (SELECT PNO FROM CHATTINGROOM WHERE MNO = ?)) ");
		//sb.append("GROUP BY RNO ORDER BY CTIME DESC");
		
		// CASE 3 : 이게 진짜임!! 나머지는 잘못된 임시 쿼리문
		sb.append("SELECT * FROM (SELECT P.MNO, P.TITLE, P.PNO, RNO, NICKNAME, CDETAIL, CTIME, STATUS FROM CHATTING C NATURAL JOIN CHATTINGROOM R INNER JOIN PRODUCT P ");
		sb.append("ON (P.PNO = R.PNO) ");
		sb.append("WHERE R.MNO = ? ");
		sb.append("OR ");
		sb.append("(P.MNO, P.PNO, P.TITLE, P.STATUS) IN (SELECT MNO, PNO, TITLE, STATUS FROM PRODUCT WHERE MNO = ?) ORDER BY CTIME DESC limit 18446744073709551615 ) AS DATA GROUP BY RNO");

		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1, mno);
			pstmt.setInt(2, mno);

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				//System.out.println("실행됨");
				ChatVO chat = new ChatVO();
				chat.setMno(rs.getInt("MNO"));
				chat.setRno(rs.getInt("RNO"));
				chat.setNickname(rs.getString("NICKNAME"));
				chat.setCdetail(rs.getString("CDETAIL"));
				chat.setCtime(rs.getString("CTIME"));
				chat.setTitle(rs.getString("TITLE"));
				chat.setPno(rs.getInt("PNO"));
				chat.setStatus(rs.getString("STATUS"));
				
				//System.out.println(rs.getInt("RNO"));
				
				list.add(chat);
			}


		} catch (SQLException e) {
			e.printStackTrace();
		}
//		finally{
//			try{
//				if(rs != null) rs.close();
//				if(pstmt != null) pstmt.close();
//				if(conn != null) conn.close();
//
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
//		}

		return list;
	}
	
	// 구매자 buyer
	public void buyProduct(String buyUser, int pno) {
		sb.setLength(0);
		sb.append("UPDATE PRODUCT SET BUYER=? WHERE PNO = ?");
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, buyUser);
			pstmt.setInt(2, pno);

			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}



//	public static void main(String[] args) {
//		new ChatDAO();
//	}
}
