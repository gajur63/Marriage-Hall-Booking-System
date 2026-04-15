<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"CUSTOMER".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    request.setAttribute("currentPage","bookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>My Bookings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/customer-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <h1>My Bookings</h1>
        <a href="${pageContext.request.contextPath}/HallServlet?action=list" class="btn btn-primary">➕ Book a Hall</a>
    </div>
    <c:if test="${not empty param.msg}"><div class="alert alert-success">✅ ${param.msg}</div></c:if>

    <div class="table-card">
        <c:choose>
            <c:when test="${empty bookings}">
                <div class="empty-state">
                    <div class="empty-icon">📋</div>
                    <p>No bookings yet. Start by browsing available halls!</p>
                    <a href="${pageContext.request.contextPath}/HallServlet?action=list" class="btn btn-primary mt-2">Browse Halls</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr><th>#</th><th>Hall</th><th>Event Date</th><th>Type</th><th>Guests</th><th>Amount</th><th>Status</th><th>Booked On</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="b" items="${bookings}">
                    <tr>
                        <td>#${b.bookingId}</td>
                        <td><strong>${b.hallName}</strong><br><small style="color:var(--gray)">📍 ${b.hallLocation}</small></td>
                        <td><fmt:formatDate value="${b.eventDate}" pattern="dd MMM yyyy"/></td>
                        <td>${b.eventType}</td>
                        <td>👥 ${b.guestCount}</td>
                        <td>NPR <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0"/></td>
                        <td><span class="badge badge-${fn:toLowerCase(b.status)}">${b.status}</span></td>
                        <td><fmt:formatDate value="${b.createdAt}" pattern="dd MMM yyyy"/></td>
                        <td style="white-space:nowrap;">
                            <a href="${pageContext.request.contextPath}/BookingServlet?action=detail&id=${b.bookingId}" class="btn btn-info btn-sm">View</a>
                            <c:if test="${b.status == 'PENDING'}">
                                <a href="${pageContext.request.contextPath}/BookingServlet?action=cancel&id=${b.bookingId}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel</a>
                            </c:if>
                        </td>
                    </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</div>
</body>
</html>
