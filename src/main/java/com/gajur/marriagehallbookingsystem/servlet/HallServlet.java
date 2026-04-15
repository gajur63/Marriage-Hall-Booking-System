package com.gajur.marriagehallbookingsystem.servlet;

import com.gajur.marriagehallbookingsystem.dao.HallDAO;
import com.gajur.marriagehallbookingsystem.dao.BookingDAO;
import com.gajur.marriagehallbookingsystem.model.Hall;
import com.gajur.marriagehallbookingsystem.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/HallServlet")
public class HallServlet extends HttpServlet {
    private final HallDAO hallDAO = new HallDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        User user = (User) req.getSession().getAttribute("user");

        switch (action) {
            case "list":
                List<Hall> halls = hallDAO.getAvailableHalls();
                req.setAttribute("halls", halls);
                req.getRequestDispatcher("/halls.jsp").forward(req, res);
                break;
            case "view":
                int hallId = Integer.parseInt(req.getParameter("id"));
                Hall hall = hallDAO.getHallById(hallId);
                List<Date> blockedDates = hallDAO.getBlockedDates(hallId);
                List<com.gajur.marriagehallbookingsystem.model.Booking> bookings = bookingDAO.getBookingsByHall(hallId);
                req.setAttribute("hall", hall);
                req.setAttribute("blockedDates", blockedDates);
                req.setAttribute("bookings", bookings);
                req.getRequestDispatcher("/hall-detail.jsp").forward(req, res);
                break;
            case "adminList":
                req.setAttribute("halls", hallDAO.getAllHalls());
                req.getRequestDispatcher("/admin/halls.jsp").forward(req, res);
                break;
            case "ownerList":
                req.setAttribute("halls", hallDAO.getHallsByOwner(user.getUserId()));
                req.getRequestDispatcher("/owner/halls.jsp").forward(req, res);
                break;
            case "addForm":
                req.getRequestDispatcher("/admin/add-hall.jsp").forward(req, res);
                break;
            case "ownerAddForm":
                req.getRequestDispatcher("/owner/add-hall.jsp").forward(req, res);
                break;
            case "editForm":
                int eid = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("hall", hallDAO.getHallById(eid));
                String editPage = "ADMIN".equals(user.getRole()) ? "/admin/edit-hall.jsp" : "/owner/edit-hall.jsp";
                req.getRequestDispatcher(editPage).forward(req, res);
                break;
            case "delete":
                int did = Integer.parseInt(req.getParameter("id"));
                hallDAO.deleteHall(did);
                String redirect = "ADMIN".equals(user.getRole()) ? "/admin/halls.jsp" : "/owner/halls.jsp";
                res.sendRedirect(req.getContextPath() + "/HallServlet?action=" + ("ADMIN".equals(user.getRole()) ? "adminList" : "ownerList") + "&msg=Hall+deleted");
                break;
            case "availability":
                int avId = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("hall", hallDAO.getHallById(avId));
                req.setAttribute("blockedDates", hallDAO.getBlockedDates(avId));
                req.getRequestDispatcher("/owner/availability.jsp").forward(req, res);
                break;
            case "search":
                String city = req.getParameter("city");
                String capStr = req.getParameter("capacity");
                String priceStr = req.getParameter("maxPrice");
                int cap = (capStr != null && !capStr.isEmpty()) ? Integer.parseInt(capStr) : 0;
                BigDecimal price = (priceStr != null && !priceStr.isEmpty()) ? new BigDecimal(priceStr) : null;
                req.setAttribute("halls", hallDAO.searchHalls(city, cap, price));
                req.setAttribute("searchCity", city);
                req.setAttribute("searchCap", capStr);
                req.setAttribute("searchPrice", priceStr);
                req.getRequestDispatcher("/halls.jsp").forward(req, res);
                break;
            default:
                res.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        User user = (User) req.getSession().getAttribute("user");

        switch (action) {
            case "add":
                Hall newHall = extractHall(req);
                newHall.setOwnerId(user.getUserId());
                hallDAO.addHall(newHall);
                String addRedirect = "ADMIN".equals(user.getRole()) ? "adminList" : "ownerList";
                res.sendRedirect(req.getContextPath() + "/HallServlet?action=" + addRedirect + "&msg=Hall+added+successfully");
                break;
            case "update":
                Hall updHall = extractHall(req);
                updHall.setHallId(Integer.parseInt(req.getParameter("hallId")));
                hallDAO.updateHall(updHall);
                String updRedirect = "ADMIN".equals(user.getRole()) ? "adminList" : "ownerList";
                res.sendRedirect(req.getContextPath() + "/HallServlet?action=" + updRedirect + "&msg=Hall+updated");
                break;
            case "toggleStatus":
                int hid = Integer.parseInt(req.getParameter("hallId"));
                String status = req.getParameter("status");
                hallDAO.updateHallStatus(hid, status);
                res.sendRedirect(req.getContextPath() + "/HallServlet?action=adminList&msg=Status+updated");
                break;
            case "blockDate":
                int bid = Integer.parseInt(req.getParameter("hallId"));
                Date bd = Date.valueOf(req.getParameter("blockedDate"));
                hallDAO.blockDate(bid, bd, req.getParameter("reason"));
                res.sendRedirect(req.getContextPath() + "/HallServlet?action=availability&id=" + bid + "&msg=Date+blocked");
                break;
            case "unblockDate":
                int uid = Integer.parseInt(req.getParameter("hallId"));
                Date ud = Date.valueOf(req.getParameter("blockedDate"));
                hallDAO.unblockDate(uid, ud);
                res.sendRedirect(req.getContextPath() + "/HallServlet?action=availability&id=" + uid + "&msg=Date+unblocked");
                break;
            default:
                res.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    private Hall extractHall(HttpServletRequest req) {
        Hall h = new Hall();
        h.setHallName(req.getParameter("hallName"));
        h.setLocation(req.getParameter("location"));
        h.setCity(req.getParameter("city"));
        h.setSeatingCapacity(Integer.parseInt(req.getParameter("seatingCapacity")));
        h.setPricePerDay(new BigDecimal(req.getParameter("pricePerDay")));
        h.setDescription(req.getParameter("description"));
        h.setFacilities(req.getParameter("facilities"));
        h.setContactNumber(req.getParameter("contactNumber"));
        h.setImageUrl(req.getParameter("imageUrl"));
        h.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "AVAILABLE");
        return h;
    }
}
