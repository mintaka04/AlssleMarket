package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import vo.MyPageVO;

public class MyPageDAO {
	
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuffer sb = new StringBuffer();
		ResultSet rs = null;
		
		public MyPageDAO() {
			conn = MakeConnection.getInstance().getConnection();
			
		}
		
		//총상품수 건수 조회
		 public int getTotalCount(int MNO) {
			 sb.setLength(0);
			 sb.append("SELECT COUNT(*) CNT FROM PRODUCT WHERE MNO=? " );
			 int count = 0;
			 try {
				pstmt =conn.prepareStatement(sb.toString());
				pstmt.setInt(1, MNO);
				rs=pstmt.executeQuery();
				rs.next();
				count =rs.getInt("CNT");
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			 return count;
		 }
		 
		 // 판매 상품 갯수
		 public int getSellCount(int mno) {
			 sb.setLength(0);
			 sb.append("SELECT COUNT(*) TOTAL FROM (SELECT TITLE, STATUS, I.IMG, pno,plike ");
			 sb.append("FROM PRODUCT P NATURAL JOIN IMAGE I ");
			 sb.append("WHERE PNO in (SELECT PNO FROM PRODUCT WHERE STATUS='판매중' AND MNO=? ) GROUP BY PNO) as TOTAL");	 
			 
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
		 
		 // 관심 목록 갯수
		 public int getLikeCount(int mno) {
			 sb.setLength(0);
			 sb.append("SELECT COUNT(*) AS TOTAL FROM(SELECT TITLE, STATUS, IMG,PNO,plike ");
			 sb.append("FROM PRODUCT NATURAL JOIN IMAGE ");
			 sb.append("WHERE PNO IN (SELECT PNO FROM LIKELIST WHERE MNO=?) GROUP BY PNO) AS TOTAL");
			 
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
		 
		 // 구매 상품 갯수
		 public int getBuyCount(int mno) {
			 sb.setLength(0);
			 sb.append("SELECT COUNT(*) AS TOTAL FROM (SELECT TITLE, STATUS, PLIKE, BUYER, I.IMG,PNO ");
			 sb.append("FROM PRODUCT NATURAL JOIN IMAGE I ");
			 sb.append("WHERE BUYER in (SELECT EMAIL FROM MEMBER WHERE MNO = ?) GROUP BY PNO) AS TOTAL");	 
			 
			 
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
		 
		 // 판매완료 갯수
		 public int getSellOkCount(int mno) {
			 sb.setLength(0);
			 sb.append("SELECT COUNT(*) AS TOTAL FROM (SELECT TITLE,STATUS,I.IMG,PNO,Plike ");
			 sb.append("FROM PRODUCT P NATURAL JOIN IMAGE I ");
			 sb.append("WHERE PNO in (SELECT PNO FROM PRODUCT WHERE STATUS='판매완료'AND MNO=? ) GROUP BY PNO) AS TOTAL");	 
			 

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
		 
		 
		 
			//판매목록 조회
			public ArrayList<MyPageVO> selectAll(int MNO, int startRow, int pageSize) {
				ArrayList<MyPageVO> list =new ArrayList<MyPageVO>();
				sb.setLength(0);
				sb.append("SELECT TITLE, STATUS, I.IMG, pno,plike ");
				sb.append("FROM PRODUCT P NATURAL JOIN IMAGE I ");
				sb.append("WHERE PNO in (SELECT PNO FROM PRODUCT WHERE STATUS='판매중'AND MNO=?  ) GROUP BY PNO limit ?, ?");
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
		 
		 //관심목록
		 public ArrayList<MyPageVO>likeAll(int MNO, int startRow, int pageSize){
			 ArrayList<MyPageVO>list4= new  ArrayList<MyPageVO>();
			 
			 sb.setLength(0);
			 sb.append("SELECT TITLE, STATUS, IMG,PNO,plike ");
			 sb.append("FROM PRODUCT NATURAL JOIN IMAGE ");
			 sb.append("WHERE PNO IN (SELECT PNO FROM LIKELIST WHERE MNO=?) GROUP BY PNO limit ?, ?");
			 
			 MyPageVO vo =null;
			 try {
				pstmt=conn.prepareStatement(sb.toString());
				pstmt.setInt(1, MNO);
				pstmt.setInt(2, startRow-1);
				pstmt.setInt(3, pageSize);
				rs=pstmt.executeQuery();
				
				while(rs.next()) {
					String title =rs.getString("title");
					String status =rs.getString("status");
					String img  =rs.getString("img");
					int  pno  =rs.getInt("pno");
					int  plike =rs.getInt("plike");
					vo=new MyPageVO(pno, MNO, title, plike, status, null, img);
					list4.add(vo);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return list4;
			
			 
			 
			  
		 }
		//구매목록 조회
         public ArrayList<MyPageVO>buyAll(int MNO, int startRow, int pageSize){

             ArrayList<MyPageVO> list2 =new ArrayList<MyPageVO>();
             sb.setLength(0);
             sb.append("SELECT TITLE, STATUS, PLIKE, BUYER, I.IMG, PNO " );
             sb.append("FROM PRODUCT NATURAL JOIN IMAGE I " );
             sb.append("WHERE BUYER = (SELECT NICKNAME FROM MEMBER WHERE MNO = ?) GROUP BY PNO limit ?,?");


             try {
                    pstmt=conn.prepareStatement(sb.toString());

                    pstmt.setInt(1, MNO);
                    pstmt.setInt(2, startRow-1);
                    pstmt.setInt(3, pageSize);

                    rs=pstmt.executeQuery();
                    //System.out.println("rs 실행");


                while(rs.next()) {
                    int  pno  =rs.getInt("PNO");
                    String title =rs.getString("TITLE");
                    String status=rs.getString("STATUS");
                    int  plike =rs.getInt("PLIKE");
                    String buyer=rs.getString("BUYER");
                    String img = rs.getString("IMG");


                    MyPageVO vo= new MyPageVO(pno, MNO, title, plike, status, buyer, img);
                    //System.out.println("rs.next 실행");

                    list2.add(vo);
                }

                return list2;

            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            return list2;

         }
		 
	
		 
		//판매완료 목록조회
		 public ArrayList<MyPageVO> sellComplete(int MNO, int startRow, int pageSize){
			 ArrayList<MyPageVO> list3 =new ArrayList<MyPageVO>();
			  sb.setLength(0);
			  sb.append("SELECT TITLE,STATUS,I.IMG,PNO,Plike  ");
			  sb.append("FROM PRODUCT P NATURAL JOIN IMAGE I ");
			  sb.append("WHERE PNO in (SELECT PNO FROM PRODUCT WHERE STATUS='판매완료'AND MNO=? ) GROUP BY PNO limit ?, ?");
			  
			  try {
				pstmt=conn.prepareStatement(sb.toString());
				pstmt.setInt(1, MNO);
				pstmt.setInt(2, startRow-1);
				pstmt.setInt(3, pageSize);
				rs=pstmt.executeQuery();
				
				MyPageVO vo =null;
				while(rs.next()) {
					String title=rs.getString("title");
					String status=rs.getString("status");
					String IMG  = rs.getString("IMG");
					int  pno     =rs.getInt("pno");
					int plike  =rs.getInt("plike");
					 vo =new MyPageVO(pno, MNO, title, plike, status, null, IMG);
					 list3.add(vo);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return list3;
			  
		 }
	
		 

		
		//판매완료상태로 변경
		public void sellUp(int pno) {
			sb.setLength(0);
			sb.append("update PRODUCT set status = '판매완료' where pno = ? ");
			
			try {
				pstmt=conn.prepareStatement(sb.toString());
				pstmt.setInt(1, pno);
				 pstmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		//판매중상태로 변경
		public void sellDown(int pno) {
			sb.setLength(0);
			sb.append("update PRODUCT set status = '판매중' where pno = ? ");
			try {
				pstmt=conn.prepareStatement(sb.toString());
				pstmt.setInt(1, pno);
				pstmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		
		
		
		
		//삭제
		public void deletOne(int pno){
			  sb.setLength(0);
			  sb.append("SET foreign_key_checks = 0" );
			 try {
						pstmt=conn.prepareStatement(sb.toString());
						pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					 
					
				 }



			public void deletProudct(int pno) {
					 sb.setLength(0);
					 sb.append("DELETE FROM PRODUCT " );
					 sb.append("WHERE PNO =?" );
					 
					 try {
						pstmt=conn.prepareStatement(sb.toString());
						pstmt.setInt(1, pno);
						
						pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					 
					
				 }


			public void deletImage(int pno) {
					 sb.setLength(0);
					 sb.append("delete from IMAGE " );
					 sb.append("where pno =? " );
					 
					 try {
						pstmt=conn.prepareStatement(sb.toString());
						pstmt.setInt(1, pno);
						
						pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					 
					
				 }



			 public void deletLike(int pno) {
					 sb.setLength(0);
					 sb.append("delete from LIKE " );
					 sb.append("where pno =? " );
					 
					 try {
						pstmt=conn.prepareStatement(sb.toString());
						pstmt.setInt(1, pno);
						
						pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					 
					
				 }

			 
		
			public void deletChatting(int pno){
			  sb.setLength(0);
			  sb.append("DELETE FROM CHATTING " );
			  sb.append("WHERE RNO=(SELECT RNO FROM CHATTINGROOM WHERE PNO = ?)" );
			   
					 try {
						pstmt=conn.prepareStatement(sb.toString());
						pstmt.setInt(1, pno);
						
						pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();

					}
			}

			public void deletChattingRoom(int pno) {
					 sb.setLength(0);
					 sb.append("delete from CHATTINGROOM " );
					 sb.append("where pno =? " );
					 
					 try {
						pstmt=conn.prepareStatement(sb.toString());
						pstmt.setInt(1, pno);
						
						pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					 
					
				 }

			public void deletFinish(int pno){
			  sb.setLength(0);
			  sb.append("SET foreign_key_checks = 1" );
			 try {
						pstmt=conn.prepareStatement(sb.toString());
						pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					 
					
				 }
			

			public void deletAll(int pno){
			deletOne(pno);
			deletProudct(pno);
			deletImage(pno);
			deletLike(pno);
			deletChatting(pno);
			deletChattingRoom(pno);
			deletFinish(pno);
			System.out.println("삭제완료");
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