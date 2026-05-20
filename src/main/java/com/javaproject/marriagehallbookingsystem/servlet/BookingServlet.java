package com.gajur.marriagehallbookingsystem.servlet;

import com.gajur.marriagehallbookingsystem.dao.BookingDAO;
import com.gajur.marriagehallbookingsystem.dao.HallDAO;
import com.gajur.marriagehallbookingsystem.dao.NotificationDAO;
import com.gajur.marriagehallbookingsystem.model.Booking;
import com.gajur.marriagehallbookingsystem.model.Hall;
import com.gajur.marriagehallbookingsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final HallDAO hallDAO = new HallDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {

            String action = req.getParameter("action");

            if (action == null || action.trim().isEmpty()) {
                action = "myBookings";
            }

            User user = (User) req.getSession().getAttribute("user");

            // Check login session
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            switch (action) {

                case "bookForm":

                    String hallIdStr = req.getParameter("hallId");

                    if (hallIdStr == null || hallIdStr.isEmpty()) {
                        res.sendRedirect(req.getContextPath() + "/index.jsp?error=Invalid+Hall");
                        return;
                    }

                    int hallId = Integer.parseInt(hallIdStr);

                    Hall hall = hallDAO.getHallById(hallId);

                    if (hall == null) {
                        res.sendRedirect(req.getContextPath() + "/index.jsp?error=Hall+not+found");
                        return;
                    }

                    req.setAttribute("hall", hall);
                    req.getRequestDispatcher("/customer/book-hall.jsp")
                            .forward(req, res);

                    break;

                case "myBookings":

                    req.setAttribute(
                            "bookings",
                            bookingDAO.getBookingsByCustomer(user.getUserId())
                    );

                    req.getRequestDispatcher("/customer/my-bookings.jsp")
                            .forward(req, res);

                    break;

                case "adminList":

                    req.setAttribute(
                            "bookings",
                            bookingDAO.getAllBookings()
                    );

                    req.getRequestDispatcher("/admin/bookings.jsp")
                            .forward(req, res);

                    break;

                case "ownerBookings":

                    req.setAttribute(
                            "bookings",
                            bookingDAO.getBookingsByOwner(user.getUserId())
                    );

                    req.getRequestDispatcher("/owner/bookings.jsp")
                            .forward(req, res);

                    break;

                case "detail":

                    String bookingIdStr = req.getParameter("id");

                    if (bookingIdStr == null || bookingIdStr.isEmpty()) {
                        res.sendRedirect(req.getContextPath() + "/BookingServlet?action=myBookings");
                        return;
                    }

                    int bookingId = Integer.parseInt(bookingIdStr);

                    Booking booking = bookingDAO.getBookingById(bookingId);

                    if (booking == null) {
                        res.sendRedirect(
                                req.getContextPath()
                                        + "/BookingServlet?action=myBookings&error=Booking+not+found"
                        );
                        return;
                    }

                    req.setAttribute("booking", booking);

                    String detailPage;

                    switch (user.getRole()) {

                        case "ADMIN":
                            detailPage = "/admin/booking-detail.jsp";
                            break;

                        case "OWNER":
                            detailPage = "/owner/booking-detail.jsp";
                            break;

                        default:
                            detailPage = "/customer/booking-detail.jsp";
                            break;
                    }

                    req.getRequestDispatcher(detailPage)
                            .forward(req, res);

                    break;

                case "cancel":

                    String cancelIdStr = req.getParameter("id");

                    if (cancelIdStr == null || cancelIdStr.isEmpty()) {
                        res.sendRedirect(
                                req.getContextPath()
                                        + "/BookingServlet?action=myBookings"
                        );
                        return;
                    }

                    int cancelId = Integer.parseInt(cancelIdStr);

                    bookingDAO.cancelBooking(cancelId, user.getUserId());

                    Booking cancelledBooking = bookingDAO.getBookingById(cancelId);

                    if (cancelledBooking != null) {

                        notifDAO.addNotification(
                                cancelledBooking.getCustomerId(),
                                "Your booking for "
                                        + cancelledBooking.getHallName()
                                        + " has been cancelled."
                        );
                    }

                    res.sendRedirect(
                            req.getContextPath()
                                    + "/BookingServlet?action=myBookings&msg=Booking+cancelled"
                    );

                    break;

                default:

                    res.sendRedirect(req.getContextPath() + "/index.jsp");
            }

        } catch (NumberFormatException e) {

            e.printStackTrace();

            res.sendRedirect(
                    req.getContextPath()
                            + "/index.jsp?error=Invalid+number+format"
            );

        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            res.sendRedirect(
                    req.getContextPath()
                            + "/index.jsp?error=Invalid+date+format"
            );

        } catch (Exception e) {

            e.printStackTrace();

            res.sendRedirect(
                    req.getContextPath()
                            + "/error.jsp?error=Internal+server+error"
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {

            String action = req.getParameter("action");

            if (action == null || action.trim().isEmpty()) {
                res.sendRedirect(req.getContextPath() + "/index.jsp");
                return;
            }

            User user = (User) req.getSession().getAttribute("user");

            // Check login session
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            switch (action) {

                case "book":

                    String hallIdStr = req.getParameter("hallId");
                    String eventDateStr = req.getParameter("eventDate");
                    String guestCountStr = req.getParameter("guestCount");

                    // Validation
                    if (hallIdStr == null || hallIdStr.isEmpty()
                            || eventDateStr == null || eventDateStr.isEmpty()
                            || guestCountStr == null || guestCountStr.isEmpty()) {

                        res.sendRedirect(
                                req.getContextPath()
                                        + "/BookingServlet?action=bookForm&error=All+fields+required"
                        );

                        return;
                    }

                    int hallId = Integer.parseInt(hallIdStr);

                    int guestCount = Integer.parseInt(guestCountStr);

                    Date eventDate = Date.valueOf(eventDateStr);

                    Hall hall = hallDAO.getHallById(hallId);

                    if (hall == null) {

                        res.sendRedirect(
                                req.getContextPath()
                                        + "/index.jsp?error=Hall+not+found"
                        );

                        return;
                    }

                    // Check booked/blocked date
                    if (bookingDAO.isDateBooked(hallId, eventDate)
                            || hallDAO.isDateBlocked(hallId, eventDate)) {

                        res.sendRedirect(
                                req.getContextPath()
                                        + "/BookingServlet?action=bookForm&hallId="
                                        + hallId
                                        + "&error=Date+not+available"
                        );

                        return;
                    }

                    Booking booking = new Booking();

                    booking.setHallId(hallId);
                    booking.setCustomerId(user.getUserId());
                    booking.setEventDate(eventDate);
                    booking.setEventType(req.getParameter("eventType"));
                    booking.setGuestCount(guestCount);
                    booking.setTotalPrice(hall.getPricePerDay());
                    booking.setSpecialRequests(req.getParameter("specialRequests"));

                    boolean success = bookingDAO.createBooking(booking);

                    if (success) {

                        // Notify customer
                        notifDAO.addNotification(
                                user.getUserId(),
                                "Booking submitted for "
                                        + hall.getHallName()
                                        + " on "
                                        + eventDate
                                        + ". Awaiting approval."
                        );

                        // Notify owner
                        notifDAO.addNotification(
                                hall.getOwnerId(),
                                "New booking request from "
                                        + user.getFullName()
                                        + " for "
                                        + hall.getHallName()
                                        + " on "
                                        + eventDate
                        );

                        // FIXED REDIRECT
                        res.sendRedirect(
                                req.getContextPath()
                                        + "/BookingServlet?action=myBookings&msg=Booking+submitted+successfully"
                        );

                    } else {

                        res.sendRedirect(
                                req.getContextPath()
                                        + "/BookingServlet?action=bookForm&hallId="
                                        + hallId
                                        + "&error=Booking+failed"
                        );
                    }

                    break;

                case "approve":
                case "reject":
                case "complete":
                case "cancel":

                    String bookingIdStr = req.getParameter("bookingId");

                    if (bookingIdStr == null || bookingIdStr.isEmpty()) {

                        res.sendRedirect(
                                req.getContextPath()
                                        + "/BookingServlet?action=myBookings"
                        );

                        return;
                    }

                    int bookingId = Integer.parseInt(bookingIdStr);

                    String newStatus;

                    if ("approve".equals(action)) {
                        newStatus = "APPROVED";
                    } else if ("reject".equals(action)) {
                        newStatus = "CANCELLED";
                    } else if ("complete".equals(action)) {
                        newStatus = "COMPLETED";
                    } else {
                        newStatus = "CANCELLED";
                    }

                    bookingDAO.updateBookingStatus(bookingId, newStatus);

                    Booking updatedBooking = bookingDAO.getBookingById(bookingId);

                    if (updatedBooking != null) {

                        notifDAO.addNotification(
                                updatedBooking.getCustomerId(),
                                "Your booking for "
                                        + updatedBooking.getHallName()
                                        + " on "
                                        + updatedBooking.getEventDate()
                                        + " has been "
                                        + newStatus.toLowerCase()
                                        + "."
                        );
                    }

                    String redirectAction;

                    if ("ADMIN".equals(user.getRole())) {
                        redirectAction = "adminList";
                    } else {
                        redirectAction = "ownerBookings";
                    }

                    res.sendRedirect(
                            req.getContextPath()
                                    + "/BookingServlet?action="
                                    + redirectAction
                                    + "&msg=Status+updated"
                    );

                    break;

                default:

                    res.sendRedirect(req.getContextPath() + "/index.jsp");
            }

        } catch (NumberFormatException e) {

            e.printStackTrace();

            res.sendRedirect(
                    req.getContextPath()
                            + "/index.jsp?error=Invalid+number+format"
            );

        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            res.sendRedirect(
                    req.getContextPath()
                            + "/index.jsp?error=Invalid+date+format"
            );

        } catch (Exception e) {

            e.printStackTrace();

            res.sendRedirect(
                    req.getContextPath()
                            + "/error.jsp?error=Internal+server+error"
            );
        }
    }
}