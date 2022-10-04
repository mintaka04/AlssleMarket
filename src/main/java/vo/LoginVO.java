package vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//MNO		INT
//EMAIL		STRING
//PW		STRING
//NICKNAME	STRING
//MPHONE	STRING
//MIMG		STRING
//MDETAIL	STRING

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginVO {
	int mno;
	String email;
	String pw;
	String nickname;
	String mphone;
	String mimg;
	String mdetail;
}
