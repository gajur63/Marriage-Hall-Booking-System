package com.gajur.marriagehallbookingsystem.servlet;

import com.gajur.marriagehallbookingsystem.dao.UserDAO;
import com.gajur.marriagehallbookingsystem.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String role = req.getParameter("role");

        if (!password.equals(confirmPassword)) {
            res.sendRedirect(req.getContextPath() + "/register.jsp?error=Passwords+do+not+match");
            return;
        }
        if (userDAO.emailExists(email)) {
            res.sendRedirect(req.getContextPath() + "/register.jsp?error=Email+already+registered");
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole(role != null && role.equals("OWNER") ? "OWNER" : "CUSTOMER");

        if (userDAO.registerUser(user)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?success=Registration+successful!+Please+login.");
        } else {
            res.sendRedirect(req.getContextPath() + "/register.jsp?error=Registration+failed.+Try+again.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/register.jsp");
    }
}
