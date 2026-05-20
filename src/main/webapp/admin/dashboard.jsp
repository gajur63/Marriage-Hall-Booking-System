<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    com.javaproject.marriagehallbookingsystem.model.User u =
            (com.javaproject.marriagehallbookingsystem.model.User) session.getAttribute("user");

    if (u == null || !"ADMIN".equals(u.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Load dashboard data
    com.javaproject.marriagehallbookingsystem.dao.HallDAO hd =
            new com.javaproject.marriagehallbookingsystem.dao.HallDAO();

    com.javaproject.marriagehallbookingsystem.dao.BookingDAO bd =
            new com.javaproject.marriagehallbookingsystem.dao.BookingDAO();

    com.javaproject.marriagehallbookingsystem.dao.UserDAO ud =
            new com.javaproject.marriagehallbookingsystem.dao.UserDAO();

    request.setAttribute("totalHalls", hd.countHalls());
    request.setAttribute("totalBookings", bd.countAllBookings());
    request.setAttribute("pendingBookings", bd.countByStatus("PENDING"));
    request.setAttribute("totalCustomers", ud.countByRole("CUSTOMER"));
    request.setAttribute("totalOwners", ud.countByRole("OWNER"));
    request.setAttribute("revenue", bd.getTotalRevenue());
    request.setAttribute("recentBookings", bd.getAllBookings());
    request.setAttribute("currentPage", "dashboard");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .chart-container {
            background: #fff;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .chart-title {
            margin-bottom: 20px;
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
        }

        #dashboardChart {
            max-height: 400px;
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/header.jsp"/>

<div class="page-shell">
<div class="dashboard-layout">

    <jsp:include page="/WEB-INF/admin-sidebar.jsp"/>

    <div class="main-content">

        <!-- Header -->
        <div class="page-header">
            <div>
                <h1>Admin Dashboard</h1>
                <div class="breadcrumb">
                    Welcome back, ${user.fullName}!
                </div>
            </div>
        </div>

        <!-- Stats -->
        <div class="stats-grid">

            <div class="stat-card">
                <div class="stat-icon icon-primary"><i class="fa-solid fa-house" style="color: rgb(0, 0, 0);"></i>
                </div>

                <div class="stat-info">
                    <div class="stat-value">${totalHalls}</div>
                    <div class="stat-label">Total Halls</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon icon-secondary">
                    <i class="fa-solid fa-file-lines"
                       style="color: rgb(39, 49, 46);"></i>
                </div>

                <div class="stat-info">
                    <div class="stat-value">${totalBookings}</div>
                    <div class="stat-label">Total Bookings</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon icon-danger">
                    <i class="fa-solid fa-hourglass-half"
                       style="color: rgb(39, 49, 46);"></i>
                </div>

                <div class="stat-info">
                    <div class="stat-value">${pendingBookings}</div>
                    <div class="stat-label">Pending Bookings</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon icon-info">
                    <i class="fa-solid fa-people-group"
                       style="color: rgb(39, 49, 46);"></i>
                </div>

                <div class="stat-info">
                    <div class="stat-value">${totalCustomers}</div>
                    <div class="stat-label">Customers</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon icon-success">
                    <i class="fa-solid fa-building"
                       style="color: rgb(39, 49, 46);"></i>
                </div>

                <div class="stat-info">
                    <div class="stat-value">${totalOwners}</div>
                    <div class="stat-label">Hall Owners</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon icon-secondary">
                    <i class="fa-solid fa-sack-dollar"
                       style="color: rgb(39, 49, 46);"></i>
                </div>

                <div class="stat-info">
                    <div class="stat-value" style="font-size:1.2rem;">
                        NPR
                        <fmt:formatNumber value="${revenue}"
                                          pattern="#,##0"/>
                    </div>

                    <div class="stat-label">Total Revenue</div>
                </div>
            </div>

        </div>

        <!-- Chart Section -->
        <div class="chart-container">

            <div class="chart-title">
                Dashboard Analytics
            </div>

            <canvas id="dashboardChart"></canvas>

        </div>

        <!-- Quick Actions -->
        <div style="display:flex;gap:12px;margin-bottom:24px;flex-wrap:wrap;">

            <a href="${pageContext.request.contextPath}/HallServlet?action=addForm"
               class="btn btn-primary">

                <i class="fa-solid fa-plus"
                   style="color: rgb(39, 49, 46);"></i>

                Add Hall
            </a>

            <a href="${pageContext.request.contextPath}/AdminServlet?action=addOwnerForm"
               class="btn btn-secondary">

                <i class="fa-solid fa-plus"
                   style="color: rgb(39, 49, 46);"></i>

                Add Owner
            </a>

            <a href="${pageContext.request.contextPath}/BookingServlet?action=adminList"
               class="btn btn-outline">

                <i class="fa-solid fa-file-lines"
                   style="color: rgb(39, 49, 46);"></i>

                All Bookings
            </a>

            <a href="${pageContext.request.contextPath}/AdminServlet?action=users"
               class="btn btn-outline">

                <i class="fa-solid fa-users"
                   style="color: rgb(177, 151, 252);"></i>

                Manage Users
            </a>

        </div>

        <!-- Recent Bookings -->
        <div class="table-card">

            <div class="table-header">

                <h3>Recent Bookings</h3>

                <a href="${pageContext.request.contextPath}/BookingServlet?action=adminList"
                   class="btn btn-outline btn-sm">

                    View All
                </a>

            </div>

            <table>

                <thead>
                <tr>
                    <th>#</th>
                    <th>Customer</th>
                    <th>Hall</th>
                    <th>Event Date</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="b" items="${recentBookings}" end="9">

                    <tr>

                        <td>#${b.bookingId}</td>

                        <td>${b.customerName}</td>

                        <td>${b.hallName}</td>

                        <td>
                            <fmt:formatDate value="${b.eventDate}"
                                            pattern="dd MMM yyyy"/>
                        </td>

                        <td>
                            NPR
                            <fmt:formatNumber value="${b.totalPrice}"
                                              pattern="#,##0"/>
                        </td>

                        <td>
                            <span class="badge badge-${fn:toLowerCase(b.status)}">
                                    ${b.status}
                            </span>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/BookingServlet?action=detail&id=${b.bookingId}"
                               class="btn btn-info btn-sm">

                                View
                            </a>
                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

    </div>

</div>

<!-- Chart Script -->
<script>

    const ctx = document.getElementById('dashboardChart');

    new Chart(ctx, {

        type: 'bar',

        data: {

            labels: [
                'Total Halls',
                'Total Bookings',
                'Pending Bookings',
                'Customers',
                'Hall Owners'
            ],

            datasets: [{

                label: 'Dashboard Statistics',

                data: [
                    ${totalHalls},
                    ${totalBookings},
                    ${pendingBookings},
                    ${totalCustomers},
                    ${totalOwners}
                ],

                backgroundColor: [
                    '#6366f1',
                    '#10b981',
                    '#f59e0b',
                    '#3b82f6',
                    '#ef4444'
                ],

                borderRadius: 8,
                borderWidth: 1
            }]
        },

        options: {

            responsive: true,

            plugins: {

                legend: {
                    display: false
                }

            },

            scales: {

                y: {
                    beginAtZero: true
                }

            }

        }

    });

</script>

</div></body>
</html>