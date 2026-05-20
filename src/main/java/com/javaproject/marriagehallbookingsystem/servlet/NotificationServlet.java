package com.javaproject.marriagehallbookingsystem.servlet;

import com.javaproject.marriagehallbookingsystem.dao.NotificationDAO;
import com.javaproject.marriagehallbookingsystem.model.Notification;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Action required");
            return;
        }

        switch(action) {

            case "list":
                getNotifications(request, response);
                break;

            case "unreadCount":
                getUnreadCount(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid action");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if(action == null){
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Action required");
            return;
        }

        switch(action){

            case "create":
                createNotification(request, response);
                break;

            case "markRead":
                markAllRead(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid action");
        }
    }

    // Add notification
    private void createNotification(HttpServletRequest request,
                                    HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(
                request.getParameter("userId"));

        String message =
                request.getParameter("message");

        boolean success =
                notificationDAO.addNotification(userId,
                        message);

        response.setContentType("text/plain");

        if(success){
            response.getWriter().write(
                    "Notification created");
        }else{
            response.getWriter().write(
                    "Failed");
        }
    }


    // Get notification list
    private void getNotifications(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(
                request.getParameter("userId"));

        List<Notification> notifications =
                notificationDAO
                        .getNotificationsForUser(userId);

        response.setContentType(
                "application/json");

        Gson gson = new Gson();
        response.getWriter().write(
                gson.toJson(notifications));
    }


    // Unread count
    private void getUnreadCount(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(
                request.getParameter("userId"));

        int count =
                notificationDAO.countUnread(userId);

        response.setContentType(
                "text/plain");

        response.getWriter()
                .write(String.valueOf(count));
    }


    // Mark all read
    private void markAllRead(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(
                request.getParameter("userId"));

        notificationDAO.markAllRead(userId);

        response.setContentType(
                "text/plain");

        response.getWriter()
                .write("Notifications marked read");
    }
}