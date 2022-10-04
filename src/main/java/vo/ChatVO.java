package vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ChatVO {
	int mno, cno, rno, pno;
	String nickname, cdetail, ctime, title, status;
}
