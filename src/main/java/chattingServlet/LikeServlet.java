package chattingServlet;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ChatDAO;
import dao.LikeDAO;
import dao.ProductDAO;
import vo.LikeVO;
import vo.LoginVO;

@WebServlet("/write/detailServlet")
public class LikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response ) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        int mno = Integer.parseInt(request.getParameter("mno"));
        int pno = Integer.parseInt(request.getParameter("pno"));

        ProductDAO dao = new ProductDAO();
        LikeDAO ldao = new LikeDAO();
        
        System.out.println(mno);
        System.out.println(pno);
        
        if(ldao.isLike(mno, pno)==null) {
        	System.out.println("추가");
        	ldao.addLike(mno, pno);
        	response.getWriter().write("1");
        	ldao.addLike(mno, pno);
			dao.plusLikes(pno);
        }else {
        	System.out.println("삭제");
        	ldao.deleteLike(mno, pno);
        	response.getWriter().write("0");
        	ldao.deleteLike(mno, pno);
			dao.minusLikes(pno);
        }
        

    }
}
