package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MakeConnection {
	private static MakeConnection mc;
	
	DBInfo dbInfo = new DBInfo();
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	
	private MakeConnection() {
	}
	
	public static MakeConnection getInstance() {
		if(mc==null)
			mc = new MakeConnection();
		return mc;
	}
	
	public Connection getConnection() {
		if(conn==null) {
			try {
				Class.forName(dbInfo.DRIVER);
				conn = DriverManager.getConnection(dbInfo.URL, dbInfo.USER, dbInfo.PASSWORD);
			} catch (ClassNotFoundException e) {
				System.out.println("드라이버로딩실패");
			} catch (SQLException e) {
				System.out.println("db 연결 실패");
				e.printStackTrace();
			}
		}
		return conn;
	}
}
