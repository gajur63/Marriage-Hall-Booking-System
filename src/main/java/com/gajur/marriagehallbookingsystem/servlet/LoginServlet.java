package com.gajur.marriagehallbookingsystem.servlet;

import com.gajur.marriagehallbookingsystem.dao.UserDAO;
import com.gajur.marriagehallbookingsystem.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60);

            switch (user.getRole()) {
                case "ADMIN":    res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp"); break;
                case "OWNER":    res.sendRedirect(req.getContextPath() + "/owner/dashboard.jsp"); break;
                case "CUSTOMER": res.sendRedirect(req.getContextPath() + "/customer/dashboard.jsp"); break;
                default:         res.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+email+or+password");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
