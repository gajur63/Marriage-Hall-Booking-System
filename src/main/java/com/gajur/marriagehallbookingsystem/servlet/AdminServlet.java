package com.gajur.marriagehallbookingsystem.servlet;

import com.gajur.marriagehallbookingsystem.dao.*;
import com.gajur.marriagehallbookingsystem.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final HallDAO hallDAO = new HallDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                req.setAttribute("totalHalls", hallDAO.countHalls());
                req.setAttribute("totalBookings", bookingDAO.countAllBookings());
                req.setAttribute("pendingBookings", bookingDAO.countByStatus("PENDING"));
                req.setAttribute("totalCustomers", userDAO.countByRole("CUSTOMER"));
                req.setAttribute("totalOwners", userDAO.countByRole("OWNER"));
                req.setAttribute("revenue", bookingDAO.getTotalRevenue());
                req.setAttribute("recentBookings", bookingDAO.getAllBookings());
                req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, res);
                break;
            case "users":
                req.setAttribute("users", userDAO.getAllUsers());
                req.getRequestDispatcher("/admin/users.jsp").forward(req, res);
                break;
            case "customers":
                req.setAttribute("users", userDAO.getUsersByRole("CUSTOMER"));
                req.setAttribute("pageTitle", "Customers");
                req.getRequestDispatcher("/admin/users.jsp").forward(req, res);
                break;
            case "owners":
                req.setAttribute("users", userDAO.getUsersByRole("OWNER"));
                req.setAttribute("pageTitle", "Hall Owners");
                req.getRequestDispatcher("/admin/users.jsp").forward(req, res);
                break;
            case "toggleUserStatus":
                int uid = Integer.parseInt(req.getParameter("id"));
                String status = req.getParameter("status");
                userDAO.updateUserStatus(uid, status);
                res.sendRedirect(req.getContextPath() + "/AdminServlet?action=users&msg=Status+updated");
                break;
            case "deleteUser":
                int did = Integer.parseInt(req.getParameter("id"));
                userDAO.deleteUser(did);
                res.sendRedirect(req.getContextPath() + "/AdminServlet?action=users&msg=User+deleted");
                break;
            case "addOwnerForm":
                req.getRequestDispatcher("/admin/add-owner.jsp").forward(req, res);
                break;
            default:
                res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("addOwner".equals(action)) {
            User owner = new User();
            owner.setFullName(req.getParameter("fullName"));
            owner.setEmail(req.getParameter("email"));
            owner.setPassword(req.getParameter("password"));
            owner.setPhone(req.getParameter("phone"));
            owner.setAddress(req.getParameter("address"));
            owner.setRole("OWNER");
            if (userDAO.registerUser(owner)) {
                res.sendRedirect(req.getContextPath() + "/AdminServlet?action=owners&msg=Owner+added");
            } else {
                res.sendRedirect(req.getContextPath() + "/AdminServlet?action=addOwnerForm&error=Failed+to+add+owner");
            }
        }
    }
}
