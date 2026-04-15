package com.gajur.marriagehallbookingsystem.servlet;

import com.gajur.marriagehallbookingsystem.dao.NotificationDAO;
import com.gajur.marriagehallbookingsystem.dao.UserDAO;
import com.gajur.marriagehallbookingsystem.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "view";
        User sessionUser = (User) req.getSession().getAttribute("user");

        switch (action) {
            case "view":
                User fresh = userDAO.getUserById(sessionUser.getUserId());
                req.setAttribute("profileUser", fresh);
                req.getRequestDispatcher("/profile.jsp").forward(req, res);
                break;
            case "notifications":
                notifDAO.markAllRead(sessionUser.getUserId());
                req.setAttribute("notifications", notifDAO.getNotificationsForUser(sessionUser.getUserId()));
                req.getRequestDispatcher("/notifications.jsp").forward(req, res);
                break;
            default:
                res.sendRedirect(req.getContextPath() + "/profile.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        User sessionUser = (User) req.getSession().getAttribute("user");

        if ("updateProfile".equals(action)) {
            User u = new User();
            u.setUserId(sessionUser.getUserId());
            u.setFullName(req.getParameter("fullName"));
            u.setPhone(req.getParameter("phone"));
            u.setAddress(req.getParameter("address"));
            userDAO.updateUser(u);
            // refresh session
            User refreshed = userDAO.getUserById(sessionUser.getUserId());
            req.getSession().setAttribute("user", refreshed);
            req.getSession().setAttribute("userName", refreshed.getFullName());
            res.sendRedirect(req.getContextPath() + "/ProfileServlet?action=view&msg=Profile+updated");
        } else if ("changePassword".equals(action)) {
            String current = req.getParameter("currentPassword");
            String newPass = req.getParameter("newPassword");
            String confirm = req.getParameter("confirmPassword");
            User dbUser = userDAO.getUserById(sessionUser.getUserId());
            // re-fetch with password for verification
            User authUser = userDAO.authenticate(dbUser.getEmail(), current);
            if (authUser == null) {
                res.sendRedirect(req.getContextPath() + "/ProfileServlet?action=view&error=Current+password+incorrect");
            } else if (!newPass.equals(confirm)) {
                res.sendRedirect(req.getContextPath() + "/ProfileServlet?action=view&error=Passwords+do+not+match");
            } else {
                userDAO.updatePassword(sessionUser.getUserId(), newPass);
                res.sendRedirect(req.getContextPath() + "/ProfileServlet?action=view&msg=Password+changed+successfully");
            }
        }
    }
}
