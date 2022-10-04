package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Objects;

import vo.MainProdVO;

public class SearchDAO {
	Connection conn;
	PreparedStatement pstmt = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	

	public SearchDAO() {
		conn = MakeConnection.getInstance().getConnection();
		System.out.println("conn : " + conn);
	}

	// total 검색결과
	public int getSearchTotal(String searchenter, String min, String max, String radio, String category) {
		
	
	boolean lpindex = false;
	boolean hpindex = false;
	
	sb.setLength(0);
	sb.append("SELECT COUNT(*) AS TOTAL FROM ");
	sb.append("(SELECT PNO, I.IMG, P.TITLE, P.PRICE, P.DATE ");
	sb.append("FROM IMAGE I ");
	sb.append("NATURAL JOIN PRODUCT P ");
	sb.append("WHERE P.TITLE LIKE ? ");

	// 가격필터 적용
	if (min != null && min != "" && !Objects.equals(min, null) && !Objects.equals(min, "null")) {
		System.out.println("최소값 if 생김");
		sb.append("AND P.PRICE >= ? ");
		lpindex = true;
	}
	if (max != null && max != "" && !Objects.equals(max, null) && !Objects.equals(max, "null")) {
		System.out.println("최대값 if 생김");
		sb.append("AND P.PRICE <= ? ");
		hpindex = true;
	}
//	System.out.println("라디오 값 : " + radio);
//	System.out.println("라디오값 1일과 같은지 확인 : ");
//	System.out.println(Objects.equals(radio, "1일"));

	// 기간 필터 적용
	if (Objects.equals(radio, "1일")) {
		sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -1 DAY) AND NOW() ");
	} else if (Objects.equals(radio, "7일")) {
		sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -7 DAY) AND NOW() ");
	} else if (Objects.equals(radio, "1달")) {
		sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -1 MONTH) AND NOW() ");
	} else if (Objects.equals(radio, "3달")) {
		sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -3 MONTH) AND NOW() ");
	}

	// 카테고리 필터 적용
	if (Objects.equals(category, "디지털기기")) {
		sb.append("AND P.CATEGORY = '디지털기기'  ");
	} else if (Objects.equals(category, "생활가전")) {
		sb.append("AND P.CATEGORY = '생활가전' ");
	} else if (Objects.equals(category, "가구/인테리어")) {
		sb.append("AND P.CATEGORY = '가구/인테리어' ");
	} else if (Objects.equals(category, "유아동")) {
		sb.append("AND P.CATEGORY = '유아동' ");
	} else if (Objects.equals(category, "생활/가공식품")) {
		sb.append("AND P.CATEGORY = '생활/가공식품' ");
	}else if (Objects.equals(category, "패션/잡화")) {
		sb.append("AND P.CATEGORY = '남성패션/잡화' ");
	}else if (Objects.equals(category, "게임/취미")) {
		sb.append("AND P.CATEGORY = '게임/취미' ");
	}else if (Objects.equals(category, "반려동물용품")) {
		sb.append("AND P.CATEGORY = '반려동물용품' ");
	}else if (Objects.equals(category, "도서/티켓/음반")) {
		sb.append("AND P.CATEGORY = '도서/티켓/음반' ");
	} else if (Objects.equals(category, "기타중고물품")) {
		sb.append("AND P.CATEGORY = '기타 중고물품' ");
	}

	sb.append("GROUP BY PNO ) AS TOTAL");

	//System.out.println(sb);

	try {
		pstmt = conn.prepareStatement(sb.toString());
		// 현재 sql 문을 저장
		
		pstmt.setString(1, "%" + searchenter + "%");

		if (lpindex) {
			pstmt.setString(2, min);
		}
		if (hpindex && lpindex) {
			//낮은가격 지정시
			pstmt.setString(3, max);
		}else if(hpindex && !lpindex) {
			//낮은가격 미지정시
			pstmt.setString(2, max);
		}
		
		rs = pstmt.executeQuery();

		rs.next();
		int result = rs.getInt("TOTAL");
		System.out.println("Result : "+result);
		
		return result;

		} catch (SQLException e) {
			e.printStackTrace();
			return -1;
		} 
	}


	// 필터 없는 && 필터적용 paging 
	public ArrayList<MainProdVO> selectFilter(String searchenter, String min, String max, String radio, String order,
		String category, int startPno, int pageSize) {
		
		ArrayList<MainProdVO> rlist = new ArrayList<MainProdVO>();
		
		//System.out.println("---------------------------");
		//System.out.println("searchenter : " + searchenter + ", min : " + min + ", max : " + max + ", radio : " + radio + ", order : " + order + ", cat : " + category);
		//System.out.println("null과 같은지 확인");
		//System.out.println(min != null);
		//System.out.println("따옴표랑 같은지 확인");
		//System.out.println(min != "");
		//System.out.println("obects확인");
		//System.out.println(!Objects.equals(min, null));
		//System.out.println("스트링눌값확인");
		//System.out.println(!Objects.equals(min, "null"));
		//System.out.println("스트링빈값확인");
		//System.out.println(!Objects.equals(min, ""));
		
		boolean lpindex = false;
		boolean hpindex = false;
		
		sb.setLength(0);
		sb.append("SELECT PNO, I.IMG, P.TITLE, P.PRICE, P.DATE ");
		sb.append("FROM IMAGE I ");
		sb.append("NATURAL JOIN PRODUCT P ");
		sb.append("WHERE P.TITLE LIKE ? ");

		// 가격필터 적용
		if (min != null && min != "" && !Objects.equals(min, null) && !Objects.equals(min, "null")) {
			System.out.println("최소값 if 생김");
			sb.append("AND P.PRICE >= ? ");
			lpindex = true;
		}
		if (max != null && max != "" && !Objects.equals(max, null) && !Objects.equals(max, "null")) {
			System.out.println("최대값 if 생김");
			sb.append("AND P.PRICE <= ? ");
			hpindex = true;
		}
		
//		System.out.println("라디오 값 : " + radio);
//		System.out.println("라디오값 1일과 같은지 확인 : ");
//		System.out.println(Objects.equals(radio, "1일"));

		// 기간 필터 적용
		if (Objects.equals(radio, "1일")) {
			sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -1 DAY) AND NOW() ");
		} else if (Objects.equals(radio, "7일")) {
			sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -7 DAY) AND NOW() ");
		} else if (Objects.equals(radio, "1달")) {
			sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -1 MONTH) AND NOW() ");
		} else if (Objects.equals(radio, "3달")) {
			sb.append("AND P.DATE BETWEEN DATE_ADD(NOW(), INTERVAL -3 MONTH) AND NOW() ");
		}

		// 카테고리 필터 적용
		if (Objects.equals(category, "디지털기기")) {
			sb.append("AND P.CATEGORY = '디지털기기'  ");
		} else if (Objects.equals(category, "인기매물")) {
			sb.append("AND P.CATEGORY = '인기매물' ");
		} else if (Objects.equals(category, "생활가전")) {
			sb.append("AND P.CATEGORY = '생활가전' ");
		} else if (Objects.equals(category, "가구/인테리어")) {
			sb.append("AND P.CATEGORY = '가구/인테리어' ");
		} else if (Objects.equals(category, "유아동")) {
			sb.append("AND P.CATEGORY = '유아동' ");
		} else if (Objects.equals(category, "유아도서")) {
			sb.append("AND P.CATEGORY = '유아도서' ");
		} else if (Objects.equals(category, "생활/가공식품")) {
			sb.append("AND P.CATEGORY = '생활/가공식품' ");
		} else if (Objects.equals(category, "스포츠/레저")) {
			sb.append("AND P.CATEGORY = '스포츠/레저' ");
		} else if (Objects.equals(category, "여성잡화")) {
			sb.append("AND P.CATEGORY = '여성잡화' ");
		}else if (Objects.equals(category, "여성의류")) {
			sb.append("AND P.CATEGORY = '여성의류' ");
		}else if (Objects.equals(category, "남성패션/잡화")) {
			sb.append("AND P.CATEGORY = '남성패션/잡화' ");
		}else if (Objects.equals(category, "게임/취미")) {
			sb.append("AND P.CATEGORY = '게임/취미' ");
		}else if (Objects.equals(category, "뷰티/미용")) {
			sb.append("AND P.CATEGORY = '뷰티/미용' ");
		}else if (Objects.equals(category, "반려동물용품")) {
			sb.append("AND P.CATEGORY = '반려동물용품' ");
		}else if (Objects.equals(category, "도서/티켓/음반")) {
			sb.append("AND P.CATEGORY = '도서/티켓/음반' ");
		}else if (Objects.equals(category, "식물")) {
			sb.append("AND P.CATEGORY = '식물' ");
		} else if (Objects.equals(category, "기타중고물품")) {
			sb.append("AND P.CATEGORY = '기타 중고물품' ");
		} else if (Objects.equals(category, "중고차")) {
			sb.append("AND P.CATEGORY = '중고차' ");
		} else if (Objects.equals(category, "삽니다")) {
			sb.append("AND P.CATEGORY = '삽니다' ");
		}

		sb.append("GROUP BY PNO ");

		// 정렬 적용
		if (Objects.equals(order, "최신순" )) {
			sb.append("ORDER BY DATE desc ");
		} else if (Objects.equals(order, "낮은가격순" )) {
			sb.append("ORDER BY PRICE ");
		} else if (Objects.equals(order, "높은가격순" )) {
			sb.append("ORDER BY PRICE desc ");
		}

		sb.append("LIMIT ?, ?");
		
		System.out.println("SQL : "+sb);

		try {
			pstmt = conn.prepareStatement(sb.toString());
			// 현재 sql 문을 저장
			
			pstmt.setString(1, "%" + searchenter + "%");

			if (lpindex) {
				pstmt.setString(2, min);
			}
			if (hpindex && lpindex) {
				//낮은가격 지정시
				pstmt.setString(3, max);
			}else if(hpindex && !lpindex) {
				//낮은가격 미지정시
				pstmt.setString(2, max);
			}
			if(!lpindex && !hpindex) {
				//가격 미지정시
				pstmt.setInt(2, startPno-1);
				pstmt.setInt(3, pageSize);
			}else if((!lpindex && hpindex) || (lpindex && !hpindex)) {
				//가격 하나만 지정시
				pstmt.setInt(3, startPno-1);
				pstmt.setInt(4, pageSize);
			}else {
				//가격 둘다 지정시
				pstmt.setInt(4,  startPno-1);
				pstmt.setInt(5,  pageSize);
			}
			
			rs = pstmt.executeQuery();

			DecimalFormat df = new DecimalFormat("###,###");
			SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date now = new Date();
			
			while (rs.next()) {
				String title = rs.getString("title");

				int pp = rs.getInt("price");
				String price = df.format(pp);

				String dd = rs.getString("date");
				Date date = fm.parse(dd);
				long diffSec = (now.getTime() - date.getTime()) / 1000;

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
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
