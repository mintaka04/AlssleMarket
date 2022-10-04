package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import vo.ImageVO;
import vo.MainProdVO;
import vo.ProductVO;

public class ImageDAO {

	Connection conn = null;
	PreparedStatement pstmt = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	
	public ImageDAO() {
		conn = MakeConnection.getInstance().getConnection();
	}
	
	public ArrayList<ImageVO> imgSelect(int pno){
		ArrayList<ImageVO> imglist = new ArrayList<ImageVO>();
		
		sb.setLength(0);
		sb.append("SELECT IMG FROM IMAGE WHERE PNO=?");
		
		try {
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setInt(1, pno);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				String img = rs.getString("IMG");
				ImageVO vo = new ImageVO(pno, img);
				imglist.add(vo);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		return imglist;
	
	}
}
