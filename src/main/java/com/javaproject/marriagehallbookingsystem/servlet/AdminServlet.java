package com.javaproject.marriagehallbookingsystem.servlet;

import com.javaproject.marriagehallbookingsystem.dao.*;
import com.javaproject.marriagehallbookingsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO =
            new UserDAO();

    private final HallDAO hallDAO =
            new HallDAO();

    private final BookingDAO bookingDAO =
            new BookingDAO();

    private final NotificationDAO notificationDAO =
            new NotificationDAO();


    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        String action =
                req.getParameter("action");

        if(action == null){
            action = "dashboard";
        }

        switch(action){

            /* DASHBOARD */

            case "dashboard":

                req.setAttribute(
                        "currentPage",
                        "dashboard"
                );

                req.getRequestDispatcher(
                        "/admin/dashboard.jsp"
                ).forward(req,res);

                break;


            /* ALL USERS */

            case "users":

                req.setAttribute(
                        "users",
                        userDAO.getAllUsers()
                );

                req.setAttribute(
                        "pageTitle",
                        "All Users"
                );

                req.setAttribute(
                        "currentPage",
                        "users"
                );

                req.getRequestDispatcher(
                        "/admin/users.jsp"
                ).forward(req,res);

                break;


            /* CUSTOMERS */

            case "customers":

                req.setAttribute(
                        "users",
                        userDAO.getUsersByRole("CUSTOMER")
                );

                req.setAttribute(
                        "pageTitle",
                        "Customers"
                );

                req.setAttribute(
                        "currentPage",
                        "customers"
                );

                req.getRequestDispatcher(
                        "/admin/users.jsp"
                ).forward(req,res);

                break;


            /* OWNERS */

            case "owners":

                req.setAttribute(
                        "users",
                        userDAO.getUsersByRole("OWNER")
                );

                req.setAttribute(
                        "pageTitle",
                        "Hall Owners"
                );

                req.setAttribute(
                        "currentPage",
                        "owners"
                );

                req.getRequestDispatcher(
                        "/admin/users.jsp"
                ).forward(req,res);

                break;


            /* ADMINS */

            case "admins":

                req.setAttribute(
                        "users",
                        userDAO.getUsersByRole("ADMIN")
                );

                req.setAttribute(
                        "pageTitle",
                        "Admins"
                );

                req.setAttribute(
                        "currentPage",
                        "admins"
                );

                req.getRequestDispatcher(
                        "/admin/users.jsp"
                ).forward(req,res);

                break;


            /* ADD USER FORM */

            case "addUserForm":

                req.setAttribute(
                        "currentPage",
                        "addUser"
                );

                req.getRequestDispatcher(
                        "/admin/add-user.jsp"
                ).forward(req,res);

                break;



            /* TOGGLE USER STATUS */

            case "toggleUserStatus":

                int uid =
                        Integer.parseInt(
                                req.getParameter("id")
                        );

                String status =
                        req.getParameter("status");

                userDAO.updateUserStatus(
                        uid,
                        status
                );

                notificationDAO.addNotification(
                        uid,
                        "Your account status changed to "
                                + status
                );

                res.sendRedirect(
                        req.getContextPath()
                                + "/AdminServlet?action=users"
                );

                break;



            /* DELETE USER */

            case "deleteUser":

                int did =
                        Integer.parseInt(
                                req.getParameter("id")
                        );

                notificationDAO.addNotification(
                        did,
                        "Your account removed by admin"
                );

                userDAO.deleteUser(
                        did
                );

                res.sendRedirect(
                        req.getContextPath()
                                + "/AdminServlet?action=users&msg=Deleted"
                );

                break;



            default:

                req.getRequestDispatcher(
                        "/admin/dashboard.jsp"
                ).forward(req,res);

        }

    }



    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        String action =
                req.getParameter("action");


        if("addUser".equals(action)){

            String email =
                    req.getParameter("email");


            if(userDAO.emailExists(email)){

                res.sendRedirect(
                        req.getContextPath()
                                + "/AdminServlet?action=addUserForm&error=Email exists"
                );

                return;
            }


            User user =
                    new User();

            user.setFullName(
                    req.getParameter("fullName")
            );

            user.setEmail(email);

            user.setPassword(
                    req.getParameter("password")
            );

            user.setPhone(
                    req.getParameter("phone")
            );

            user.setAddress(
                    req.getParameter("address")
            );

            user.setRole(
                    req.getParameter("role")
            );

            user.setStatus(
                    "ACTIVE"
            );


            boolean success =
                    userDAO.registerUser(user);


            if(success){

                User newUser =
                        userDAO.getUserByEmail(email);

                if(newUser != null){

                    notificationDAO.addNotification(
                            newUser.getUserId(),
                            "Welcome to Marriage Hall Booking System"
                    );
                }

                res.sendRedirect(
                        req.getContextPath()
                                + "/AdminServlet?action=users&msg=User Added"
                );

            }else{

                res.sendRedirect(
                        req.getContextPath()
                                + "/AdminServlet?action=addUserForm&error=Failed"
                );
            }
        }
    }
}