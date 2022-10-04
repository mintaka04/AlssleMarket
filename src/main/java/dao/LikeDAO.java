package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import vo.ImageVO;
import vo.LikeVO;
import vo.LoginVO;

public class LikeDAO {
	Connection conn;
	PreparedStatement pstmt = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	
	public LikeDAO() {
		conn = MakeConnection.getInstance().getConnection();
		System.out.println("conn : " + conn);
	}
	
	public ArrayList<LikeVO> likeList(int mno) {
		ArrayList<LikeVO> likelist = new ArrayList<LikeVO>();
		sb.setLength(0);
		sb.append("SELECT MNO, PNO FROM LIKELIST WHERE MNO=?");
		LikeVO vo = null;
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1,  mno);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				int pno = rs.getInt("PNO");
				vo = new LikeVO(mno, pno);
				likelist.add(vo);
			}			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return likelist;
	}
	
	public LikeVO isLike(int mno, int pno) {
		sb.setLength(0);
		sb.append("SELECT PNO FROM LIKELIST WHERE MNO=? AND PNO=?");
		LikeVO vo = null;
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1,  mno);
			pstmt.setInt(2,  pno);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				vo = new LikeVO(mno, pno);
			}			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return vo;
	}
	
	public void addLike(int mno, int pno) {
		sb.setLength(0);
		sb.append("INSERT INTO LIKELIST VALUES(NULL,?,?)");
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1,  pno);
			pstmt.setInt(2,  mno);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void deleteLike(int mno, int pno) {
		sb.setLength(0);
		sb.append("DELETE FROM LIKELIST WHERE MNO=? AND PNO=?");
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1,  mno);
			pstmt.setInt(2,  pno);
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