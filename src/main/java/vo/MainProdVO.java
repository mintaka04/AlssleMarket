package vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MainProdVO {
	int pno;
	String title;
	long diffSec;
	String price;
	String img;
}
