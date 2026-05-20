package com.javaproject.marriagehallbookingsystem.servlet;

import com.javaproject.marriagehallbookingsystem.dao.BookingDAO;
import com.javaproject.marriagehallbookingsystem.dao.HallDAO;
import com.javaproject.marriagehallbookingsystem.model.Hall;
import com.javaproject.marriagehallbookingsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.List;
import java.util.UUID;

@WebServlet("/HallServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class HallServlet extends HttpServlet {

    private final HallDAO hallDAO = new HallDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null)
            action = "list";

        User user =
                (User) req.getSession()
                        .getAttribute("user");

        switch (action) {

            case "list":

                req.setAttribute(
                        "halls",
                        hallDAO.getAvailableHalls()
                );

                req.getRequestDispatcher("/halls.jsp")
                        .forward(req, res);

                break;


            case "view":

                int hallId =
                        Integer.parseInt(
                                req.getParameter("id")
                        );

                Hall hall =
                        hallDAO.getHallById(hallId);

                List<Date> blockedDates =
                        hallDAO.getBlockedDates(hallId);

                req.setAttribute("hall", hall);
                req.setAttribute(
                        "blockedDates",
                        blockedDates
                );

                req.setAttribute(
                        "bookings",
                        bookingDAO.getBookingsByHall(hallId)
                );

                req.getRequestDispatcher("/hall-detail.jsp")
                        .forward(req, res);

                break;


            case "adminList":

                req.setAttribute(
                        "halls",
                        hallDAO.getAllHalls()
                );

                req.getRequestDispatcher("/admin/halls.jsp")
                        .forward(req, res);

                break;


            case "ownerList":

                req.setAttribute(
                        "halls",
                        hallDAO.getHallsByOwner(
                                user.getUserId()
                        )
                );

                req.getRequestDispatcher("/owner/halls.jsp")
                        .forward(req, res);

                break;


            case "addForm":

                req.getRequestDispatcher("/admin/add-hall.jsp")
                        .forward(req, res);

                break;


            case "ownerAddForm":

                req.getRequestDispatcher("/owner/add-hall.jsp")
                        .forward(req, res);

                break;


            case "editForm":

                int editId =
                        Integer.parseInt(
                                req.getParameter("id")
                        );

                req.setAttribute(
                        "hall",
                        hallDAO.getHallById(editId)
                );

                String editPage =
                        "ADMIN".equals(user.getRole())
                                ? "/admin/edit-hall.jsp"
                                : "/owner/edit-hall.jsp";

                req.getRequestDispatcher(editPage)
                        .forward(req, res);

                break;


            case "delete":

                int deleteId =
                        Integer.parseInt(
                                req.getParameter("id")
                        );

                hallDAO.deleteHall(deleteId);

                res.sendRedirect(
                        req.getContextPath()
                                + "/HallServlet?action="
                                + ("ADMIN".equals(
                                user.getRole()
                        )
                                ? "adminList"
                                : "ownerList")
                                + "&msg=Hall deleted"
                );

                break;


            case "availability":

                int availId =
                        Integer.parseInt(
                                req.getParameter("id")
                        );

                req.setAttribute(
                        "hall",
                        hallDAO.getHallById(availId)
                );

                req.setAttribute(
                        "blockedDates",
                        hallDAO.getBlockedDates(availId)
                );

                req.getRequestDispatcher(
                                "/owner/availability.jsp")
                        .forward(req, res);

                break;


            default:

                res.sendRedirect(
                        req.getContextPath()
                                + "/index.jsp"
                );
        }

    }


    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        String action =
                req.getParameter("action");

        User user =
                (User) req.getSession()
                        .getAttribute("user");

        switch (action) {

            case "add":

                Hall newHall = extractHall(req);

                newHall.setOwnerId(
                        user.getUserId()
                );

                hallDAO.addHall(newHall);

                res.sendRedirect(
                        req.getContextPath()
                                + "/HallServlet?action="
                                + ("ADMIN".equals(
                                user.getRole()
                        )
                                ? "adminList"
                                : "ownerList")
                                + "&msg=Hall added successfully"
                );

                break;


            case "update":

                Hall updatedHall =
                        extractHall(req);

                updatedHall.setHallId(
                        Integer.parseInt(
                                req.getParameter(
                                        "hallId"
                                )
                        )
                );

                hallDAO.updateHall(
                        updatedHall
                );

                res.sendRedirect(
                        req.getContextPath()
                                + "/HallServlet?action="
                                + ("ADMIN".equals(
                                user.getRole()
                        )
                                ? "adminList"
                                : "ownerList")
                                + "&msg=Hall updated"
                );

                break;


            default:

                res.sendRedirect(
                        req.getContextPath()
                                + "/index.jsp"
                );

        }

    }


    private Hall extractHall(
            HttpServletRequest req)
            throws IOException,
            ServletException {

        Hall h = new Hall();

        h.setHallName(
                req.getParameter(
                        "hallName"
                )
        );

        h.setLocation(
                req.getParameter(
                        "location"
                )
        );

        h.setCity(
                req.getParameter(
                        "city"
                )
        );

        h.setSeatingCapacity(
                Integer.parseInt(
                        req.getParameter(
                                "seatingCapacity"
                        )
                )
        );

        h.setPricePerDay(
                new BigDecimal(
                        req.getParameter(
                                "pricePerDay"
                        )
                )
        );

        h.setDescription(
                req.getParameter(
                        "description"
                )
        );

        h.setFacilities(
                req.getParameter(
                        "facilities"
                )
        );

        h.setContactNumber(
                req.getParameter(
                        "contactNumber"
                )
        );

        h.setStatus(
                req.getParameter(
                        "status"
                )
        );


        // IMAGE UPLOAD

        Part filePart =
                req.getPart(
                        "hallImage"
                );

        String imagePath = null;

        if (filePart != null
                && filePart.getSize() > 0) {

            String fileName =
                    Paths.get(
                                    filePart.getSubmittedFileName()
                            )
                            .getFileName()
                            .toString();

            String extension = "";

            int dotIndex =
                    fileName.lastIndexOf(".");

            if (dotIndex > 0) {
                extension =
                        fileName.substring(
                                dotIndex
                        );
            }

            String uniqueFileName =
                    UUID.randomUUID()
                            .toString()
                            + extension;

            String uploadPath =
                    getServletContext()
                            .getRealPath(
                                    "/assets/hall_profile"
                            );

            File uploadDir =
                    new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(
                    uploadPath
                            + File.separator
                            + uniqueFileName
            );

            imagePath =
                    "assets/hall_profile/"
                            + uniqueFileName;
        }


        // Keep existing image during edit
        if (imagePath != null) {

            h.setImageUrl(
                    imagePath
            );

        } else {

            h.setImageUrl(
                    req.getParameter(
                            "existingImage"
                    )
            );

        }

        return h;
    }
}