package dao;

import java.sql.Connection;	import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import vo.MainProdVO;
import vo.ProductVO;

public class ProductDAO {
	Connection conn;
	PreparedStatement pstmt = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	
	public ProductDAO() {
		conn = MakeConnection.getInstance().getConnection();
		System.out.println("conn : " + conn);
	}
	
	//like 증가
	public void plusLikes(int pno) {
		sb.setLength(0);
		sb.append("UPDATE PRODUCT set PLike=PLike+1 WHERE pno=?");
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, pno);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	//like 감소
	public void minusLikes(int pno) {
		sb.setLength(0);
		sb.append("UPDATE PRODUCT set PLike=PLike-1 WHERE pno=?");
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, pno);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	//조회수 증가
	public void plusHits(int pno) {
		sb.setLength(0);
		sb.append("UPDATE PRODUCT set HITS=HITS+1 WHERE pno=?");
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, pno);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	//판매자의 다른상품조회
	public ArrayList<Integer> salesList(int mno, int nowpno){
		ArrayList<Integer> mlist = new ArrayList<Integer>();
		
		sb.setLength(0);
		sb.append("SELECT PNO FROM PRODUCT WHERE MNO=? AND STATUS='판매중' AND PNO!=? ORDER BY PLIKE DESC LIMIT 4");
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1, mno);
			pstmt.setInt(2, nowpno);
			rs = pstmt.executeQuery();
			while(rs.next()){
				int pno = rs.getInt("pno");
				mlist.add(pno);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mlist;
	}
	
	//이미지 저장
	public void imgsave(String imgsrc){
				sb.setLength(0);
				sb.append("INSERT INTO IMAGE(PNO,IMG) ");
				sb.append("VALUES((SELECT MAX(PNO) FROM PRODUCT),?)");
				try {
					pstmt = conn.prepareStatement(sb.toString());
					
					pstmt.setString(1, imgsrc);
					pstmt.executeUpdate();
					} catch (SQLException e) {
				// TODO Auto-generated catch block
						e.printStackTrace();
				}
		}
		
	public void updateOne(int pno, String title, String category, String loc, int price, String trade, String detail, String fee) {
		ProductVO vo = null;
		sb.setLength(0);
		sb.append("UPDATE PRODUCT set title=?, category=?, date=now(), loc=?, price=?, trade=?, pdetail=?, fee=? WHERE pno=?");
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setString(1, title);
			pstmt.setString(2, category);
			pstmt.setString(3, loc);
			pstmt.setInt(4, price);
			pstmt.setString(5, trade);
			pstmt.setString(6, detail);
			pstmt.setString(7, fee);
			pstmt.setInt(8, pno);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	//1건 조회
	public ProductVO selectOne(int pno) {
		ProductVO vo = null;
		sb.setLength(0);
		sb.append("SELECT pno, mno, title, category, date, loc, price, trade, pdetail, plike, status, fee, buyer, hits FROM PRODUCT WHERE pno=?");
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, pno);
			rs=pstmt.executeQuery();
			DecimalFormat df = new DecimalFormat("###,###");
			SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date now = new Date();
			while(rs.next()) {
				int mno=rs.getInt("mno");
				String title=rs.getString("title");
				String category=rs.getString("category");
				
				String dd = rs.getString("date");
				Date date = fm.parse(dd);
				
				String loc=rs.getString("loc");
				
				int pp = rs.getInt("price");
				String price = df.format(pp); 
				
				String trade=rs.getString("trade");
				String pdetail=rs.getString("pdetail");
				int plike=rs.getInt("plike");
				String status=rs.getString("status");
				String fee=rs.getString("fee");
				String buyer=rs.getString("buyer");
				int hits=rs.getInt("hits");
				
				long diffSec = (now.getTime() - date.getTime())/1000;
				
				vo = new ProductVO(pno, mno, title, category, category, loc, price, trade, pdetail, plike, status, fee, buyer, hits, diffSec);
			}
		} catch (SQLException | ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return vo;
	}
	
	//소개 조회
	public String getmdetail(int mno) {
		sb.setLength(0);
		sb.append("SELECT MDETAIL FROM MEMBER WHERE MNO=?");
		String mdetail="";
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, mno);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				mdetail=rs.getString("mdetail");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mdetail;
	}

	//닉네임 조회
	public String getNick(int mno) {
		sb.setLength(0);
		sb.append("SELECT NICKNAME FROM MEMBER WHERE MNO=?");
		String nickname="";
		try {
			pstmt=conn.prepareStatement(sb.toString());
			pstmt.setInt(1, mno);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				nickname=rs.getString("nickname");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return nickname;
	}
	
	public void write(int mno, String category, String title, int price,
						String loc, String trade, String fee, String detail){
		sb.setLength(0);
		sb.append("INSERT INTO PRODUCT(mno, title, category, loc, price, trade, fee, pdetail, date, hits, plike, status) ");
		sb.append("VALUES(?,?,?,?,?,?,?,?,now(),0,0,'판매중')");
		try {
			pstmt = conn.prepareStatement(sb.toString());
			
			pstmt.setInt(1, mno); //임시값, 나중에 mno값
			pstmt.setString(2, title);
			pstmt.setString(3, category);
			pstmt.setString(4, loc);
			pstmt.setInt(5, price);
			pstmt.setString(6, trade);
			pstmt.setString(7, fee);
			pstmt.setString(8, detail);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public ArrayList<MainProdVO> selectMain(){
		ArrayList<MainProdVO> mlist = new ArrayList<MainProdVO>();
		
		sb.setLength(0);
		sb.append("SELECT P.PNO, P.TITLE, P.PRICE, P.DATE, I.IMG ");
		sb.append("FROM PRODUCT P ");
		sb.append("LEFT JOIN ");
		sb.append("(SELECT A.INO, A.PNO, A.IMG FROM IMAGE A, ");
		sb.append("(SELECT PNO, MIN(INO) AS INO FROM IMAGE ");
		sb.append("GROUP BY PNO) B ");
		sb.append("WHERE A.INO = B.INO) I ");
		sb.append("ON I.PNO = P.PNO ");
		sb.append("WHERE STATUS = '판매중' ORDER BY HITS DESC ");
		sb.append("LIMIT 15");
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			rs = pstmt.executeQuery();
			
			DecimalFormat df = new DecimalFormat("###,###");
			SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date now = new Date();
			while(rs.next()){
				String title = rs.getString("title");
				
				int pp = rs.getInt("price");
				String price = df.format(pp); 
				
				String dd = rs.getString("date");
				Date date = fm.parse(dd);
				long diffSec = (now.getTime() - date.getTime())/1000;
				
				String img = rs.getString("img");
				int pno = rs.getInt("pno");
				
				MainProdVO vo = new MainProdVO(pno, title, diffSec, price, img);
				mlist.add(vo);

			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mlist;
	}
	
	// 검색상품 전체조회
		public ArrayList<MainProdVO> selectAll(String searchenter) {
			ArrayList<MainProdVO> rlist = new ArrayList<MainProdVO>();
			
			sb.setLength(0);
			sb.append("SELECT P.PNO, P.TITLE, P.PRICE, P.DATE, I.IMG ");
			sb.append("FROM PRODUCT P ");
			sb.append("NATURAL JOIN IMAGE I ");
			sb.append("WHERE TITLE LIKE ? ");

			try {
				pstmt = conn.prepareStatement(sb.toString());
				pstmt.setString(1, "%"+searchenter+"%");
				rs = pstmt.executeQuery();
				
				DecimalFormat df = new DecimalFormat("###,###");
				SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date now = new Date();
				while (rs.next()) {
					String title = rs.getString("title");

					int pp = rs.getInt("price");
					String price = df.format(pp);
					System.out.println("price : "+price);

					String dd = rs.getString("date");
					Date date = fm.parse(dd);
					long diffSec = (now.getTime() - date.getTime()) / 1000;
					System.out.println(date);
					
					String img = rs.getString("img");
					int pno = rs.getInt("pno");

					MainProdVO vo = new MainProdVO(pno, title, diffSec, price, img);
					rlist.add(vo);

				}

			} catch (SQLException e) {
				e.printStackTrace();
			} catch (ParseException e) {
				e.printStackTrace();
			}
			return rlist;
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
