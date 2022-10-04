package vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//PNO			int
//MNO			int
//TITLE			string
//CATEGORY		string
//DATE			timestamp..string
//LOC			string
//PRICE			int
//TRADE			string
//PDETAIL		string
//PLIKE			int
//STATUS		string
//FEE			string
//BUYER			string
//HITS			int

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductVO {
	int pno;
	int mno;
	String title;
	String category;
	String date;
	String loc;
	String price;
	String trade;
	String pdetail;
	int plike;
	String status;
	String fee;
	String buyer;
	int hits;
	long diffSec;
	
	public ProductVO(int pno) {
		this.pno=pno;
	}
	
}
