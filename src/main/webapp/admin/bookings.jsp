<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"ADMIN".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    request.setAttribute("currentPage","bookings");
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>All Bookings - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/admin-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header"><h1>All Bookings</h1></div>
    <c:if test="${not empty param.msg}"><div class="alert alert-success">✅ ${param.msg}</div></c:if>
    <div class="table-card">
        <table>
            <thead>
                <tr><th>#</th><th>Customer</th><th>Hall</th><th>Event Date</th><th>Type</th><th>Guests</th><th>Amount</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${bookings}">
            <tr>
                <td>#${b.bookingId}</td>
                <td>${b.customerName}<br><small style="color:var(--gray)">${b.customerEmail}</small></td>
                <td>${b.hallName}<br><small style="color:var(--gray)">${b.hallLocation}</small></td>
                <td><fmt:formatDate value="${b.eventDate}" pattern="dd MMM yyyy"/></td>
                <td>${b.eventType}</td>
                <td>${b.guestCount}</td>
                <td>NPR <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0"/></td>
                <td><span class="badge badge-${fn:toLowerCase(b.status)}">${b.status}</span></td>
                <td style="white-space:nowrap;">
                    <a href="${pageContext.request.contextPath}/BookingServlet?action=detail&id=${b.bookingId}" class="btn btn-info btn-sm">View</a>
                    <c:if test="${b.status == 'PENDING'}">
                        <form method="post" action="${pageContext.request.contextPath}/BookingServlet" style="display:inline;">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                            <button type="submit" class="btn btn-success btn-sm">✓</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/BookingServlet" style="display:inline;">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                            <button type="submit" class="btn btn-danger btn-sm">✗</button>
                        </form>
                    </c:if>
                    <c:if test="${b.status == 'APPROVED'}">
                        <form method="post" action="${pageContext.request.contextPath}/BookingServlet" style="display:inline;">
                            <input type="hidden" name="action" value="complete">
                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                            <button type="submit" class="btn btn-info btn-sm">Done</button>
                        </form>
                    </c:if>
                </td>
            </tr>
            </c:forEach>
            <c:if test="${empty bookings}">
                <tr><td colspan="9" style="text-align:center;padding:30px;color:var(--gray);">No bookings found</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</div>
</body></html>
