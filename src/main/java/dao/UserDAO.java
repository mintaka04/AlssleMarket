package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import vo.LoginVO;
import vo.MyPageVO;

public class UserDAO {

	Connection conn = null;
	PreparedStatement pstmt = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	
	public UserDAO() {
		conn = MakeConnection.getInstance().getConnection();
		
	}
	
	public LoginVO userone(int mno) {
		LoginVO vo = null;
		sb.setLength(0);
		sb.append("select mno,email,pw,nickname,mphone,mimg,mdetail from MEMBER WHERE MNO=? ");
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, mno);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				String email = rs.getString("email");
				String pw = rs.getString("pw");
				String nickname=rs.getString("nickname");
				String mphone =rs.getString("mphone");
				String mimg  =rs.getString("mimg");
				String mdetail =rs.getString("mdetail");
				vo =new LoginVO(mno, email, pw, nickname, mphone, mimg, mdetail);
			}
			
			  
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		return vo;
		
		
	}
	
	
	//판매목록 조회
	public ArrayList<MyPageVO> userAll(int MNO, int startRow, int pageSize) {
		ArrayList<MyPageVO> list =new ArrayList<MyPageVO>();
		sb.setLength(0);
		sb.append("SELECT TITLE, STATUS, I.IMG, pno,plike ");
		sb.append("FROM PRODUCT P NATURAL JOIN IMAGE I ");
		sb.append("WHERE PNO in (SELECT PNO FROM PRODUCT WHERE  MNO=?  ) GROUP BY PNO limit ?, ?");
		 MyPageVO  vo =null;
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, MNO);
			pstmt.setInt(2, startRow-1);
			pstmt.setInt(3, pageSize);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				String title =rs.getString("TITLE");
				String STATUS=rs.getString("STATUS");
				String IMG  = rs.getString("IMG");
				int  pno     =rs.getInt("pno");
				int plike  =rs.getInt("plike");
		        vo =new MyPageVO(pno, MNO, title, plike, STATUS, null, IMG);
				list.add(vo);

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return list;

	}
	
	 // 판매 상품 갯수
	 public int getSellCount(int mno) {
		 sb.setLength(0);
		 sb.append("SELECT COUNT(*) TOTAL FROM (SELECT TITLE, STATUS, I.IMG, pno,plike ");
		 sb.append("FROM PRODUCT P NATURAL JOIN IMAGE I ");
		 sb.append("WHERE PNO in (SELECT PNO FROM PRODUCT WHERE  MNO=? ) GROUP BY PNO) as TOTAL");	 
		 
		 try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1, mno);
			rs = pstmt.executeQuery();
			
			rs.next();
			
			int result = rs.getInt("TOTAL");

			return result;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
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
