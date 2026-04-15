package com.gajur.marriagehallbookingsystem.servlet;

import com.gajur.marriagehallbookingsystem.dao.BookingDAO;
import com.gajur.marriagehallbookingsystem.dao.HallDAO;
import com.gajur.marriagehallbookingsystem.dao.NotificationDAO;
import com.gajur.marriagehallbookingsystem.model.Booking;
import com.gajur.marriagehallbookingsystem.model.Hall;
import com.gajur.marriagehallbookingsystem.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final HallDAO hallDAO = new HallDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "myBookings";
        User user = (User) req.getSession().getAttribute("user");

        switch (action) {
            case "bookForm":
                int hallId = Integer.parseInt(req.getParameter("hallId"));
                Hall hall = hallDAO.getHallById(hallId);
                req.setAttribute("hall", hall);
                req.getRequestDispatcher("/customer/book-hall.jsp").forward(req, res);
                break;
            case "myBookings":
                req.setAttribute("bookings", bookingDAO.getBookingsByCustomer(user.getUserId()));
                req.getRequestDispatcher("/customer/my-bookings.jsp").forward(req, res);
                break;
            case "adminList":
                req.setAttribute("bookings", bookingDAO.getAllBookings());
                req.getRequestDispatcher("/admin/bookings.jsp").forward(req, res);
                break;
            case "ownerBookings":
                req.setAttribute("bookings", bookingDAO.getBookingsByOwner(user.getUserId()));
                req.getRequestDispatcher("/owner/bookings.jsp").forward(req, res);
                break;
            case "detail":
                int bid = Integer.parseInt(req.getParameter("id"));
                Booking b = bookingDAO.getBookingById(bid);
                req.setAttribute("booking", b);
                String detailPage;
                switch (user.getRole()) {
                    case "ADMIN":    detailPage = "/admin/booking-detail.jsp"; break;
                    case "OWNER":    detailPage = "/owner/booking-detail.jsp"; break;
                    default:         detailPage = "/customer/booking-detail.jsp";
                }
                req.getRequestDispatcher(detailPage).forward(req, res);
                break;
            case "cancel":
                int cid = Integer.parseInt(req.getParameter("id"));
                bookingDAO.cancelBooking(cid, user.getUserId());
                Booking cb = bookingDAO.getBookingById(cid);
                if (cb != null) {
                    notifDAO.addNotification(user.getUserId(), "Your booking for " + cb.getHallName() + " has been cancelled.");
                }
                res.sendRedirect(req.getContextPath() + "/BookingServlet?action=myBookings&msg=Booking+cancelled");
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
            case "book":
                int hallId = Integer.parseInt(req.getParameter("hallId"));
                Date eventDate = Date.valueOf(req.getParameter("eventDate"));
                Hall hall = hallDAO.getHallById(hallId);

                if (bookingDAO.isDateBooked(hallId, eventDate) || hallDAO.isDateBlocked(hallId, eventDate)) {
                    res.sendRedirect(req.getContextPath() + "/BookingServlet?action=bookForm&hallId=" + hallId + "&error=Date+not+available");
                    return;
                }

                Booking booking = new Booking();
                booking.setHallId(hallId);
                booking.setCustomerId(user.getUserId());
                booking.setEventDate(eventDate);
                booking.setEventType(req.getParameter("eventType"));
                booking.setGuestCount(Integer.parseInt(req.getParameter("guestCount")));
                booking.setTotalPrice(hall.getPricePerDay());
                booking.setSpecialRequests(req.getParameter("specialRequests"));

                if (bookingDAO.createBooking(booking)) {
                    notifDAO.addNotification(user.getUserId(),
                        "Booking submitted for " + hall.getHallName() + " on " + eventDate + ". Awaiting approval.");
                    // Notify owner
                    notifDAO.addNotification(hall.getOwnerId(),
                        "New booking request from " + user.getFullName() + " for " + hall.getHallName() + " on " + eventDate);
                    res.sendRedirect(req.getContextPath() + "/customer/dashboard.jsp?action=myBookings&msg=Booking+submitted+successfully");
                } else {
                    res.sendRedirect(req.getContextPath() + "/BookingServlet?action=bookForm&hallId=" + hallId + "&error=Booking+failed");
                }
                break;

            case "approve":
            case "reject":
            case "complete":
            case "cancel":
                int bid = Integer.parseInt(req.getParameter("bookingId"));
                String newStatus = "approve".equals(action) ? "APPROVED"
                    : "reject".equals(action) ? "CANCELLED"
                    : "complete".equals(action) ? "COMPLETED" : "CANCELLED";
                bookingDAO.updateBookingStatus(bid, newStatus);
                Booking updated = bookingDAO.getBookingById(bid);
                if (updated != null) {
                    notifDAO.addNotification(updated.getCustomerId(),
                        "Your booking for " + updated.getHallName() + " on " + updated.getEventDate() + " has been " + newStatus.toLowerCase() + ".");
                }
                String redirectAction = "ADMIN".equals(user.getRole()) ? "adminList" : "ownerBookings";
                res.sendRedirect(req.getContextPath() + "/BookingServlet?action=" + redirectAction + "&msg=Status+updated");
                break;

            default:
                res.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}
