package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import vo.LoginVO;

public class LoginDAO {
	Connection conn;
	PreparedStatement pstmt = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	
	public LoginDAO() {
		conn = MakeConnection.getInstance().getConnection();
		System.out.println("conn : " + conn);
	}
	
	public LoginVO isExists(String email, String pw) {
		sb.setLength(0);
		sb.append("SELECT mno, nickname, mphone, mimg, mdetail FROM MEMBER WHERE email = ? AND pw = ?");
		LoginVO vo = null;
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1,  email);
			pstmt.setString(2,  pw);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				int mno = rs.getInt("mno");
				String nickname = rs.getString("nickname");
				String mphone = rs.getString("mphone");
				String mimg = rs.getString("mimg");
				String mdetail = rs.getString("mdetail");
				vo = new LoginVO( mno, email, pw, nickname, mphone, mimg, mdetail);
			}			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return vo;
	}
	
	public String isExists(String email) {
		sb.setLength(0);
		sb.append("SELECT mno FROM MEMBER WHERE email = ?");
		boolean result = false;
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1,  email);
			rs = pstmt.executeQuery();
			result = rs.next();		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return result?"true":"false";
	}
	
	public void insertOne(String email, String pw, String nickname, String pnum) {
		sb.setLength(0);
		sb.append("INSERT INTO MEMBER VALUES(null, ?, ?, ?, ?, null, ?)");
		String pdetail = "안녕하세요 "+nickname+" 입니다";
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1,  email);
			pstmt.setString(2, pw);
			pstmt.setString(3,  nickname);
			pstmt.setString(4,  pnum);
			pstmt.setString(5, pdetail);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	//자기소개 수정
		public void updateOne(String MDETAIL, int mno) {
			sb.setLength(0);
			sb.append("UPDATE MEMBER SET MDETAIL=? ");
			sb.append("WHERE MNO=? ");
			try {
				pstmt=conn.prepareStatement(sb.toString());
				pstmt.setString(1,MDETAIL );
				pstmt.setInt(2, mno);
			int result = pstmt.executeUpdate(); //결과가인트로나옴
				
				System.out.println("실행완료:"+result);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		//자기소개 사진 올리기
		
				public void imgOne(int mno, String imgsrc){
					sb.setLength(0);
					sb.append("UPDATE MEMBER SET MIMG=? ");
					sb.append("WHERE MNO=? ");
					try {
						pstmt = conn.prepareStatement(sb.toString());
						
						pstmt.setString(1, imgsrc );
						pstmt.setInt(2,mno);
						pstmt.executeUpdate();
						} catch (SQLException e) {
					// TODO Auto-generated catch block
							e.printStackTrace();
					}
			}
	
	
	public void close() {
		try {
			if(rs != null) rs.close();
			if(pstmt != null)pstmt.close();
			if(conn != null)conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
}
}
