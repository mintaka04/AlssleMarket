package chattingServlet;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ChatDAO;

@WebServlet("/chatting/chatSend")
public class ChatSubmitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response ) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        int roomNo = Integer.parseInt(request.getParameter("roomNo"));
        String chatName = request.getParameter("chatName");
        String chatContent = request.getParameter("chatContent");

        //System.out.println(chatName);
        //System.out.println(chatContent);
        
        if(chatName == null || chatName.equals("") || chatContent == null || chatContent.equals("")){
            response.getWriter().write("0");

        }
        else{
        	response.getWriter().write(new ChatDAO().submit(roomNo, chatName, chatContent)+"");
        	ChatDAO.recentCno+=1;
        	//System.out.println("recentCno : "+ChatDAO.recentCno);
        }
    }
}
