<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"ADMIN".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Booking Detail - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/admin-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <h1>Booking #${booking.bookingId}</h1>
        <a href="${pageContext.request.contextPath}/BookingServlet?action=adminList" class="btn btn-outline">← Back</a>
    </div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div class="info-panel">
            <h3>Booking Information</h3>
            <div class="detail-grid">
                <div class="detail-item"><span class="detail-label">Booking ID</span><span class="detail-value">#${booking.bookingId}</span></div>
                <div class="detail-item"><span class="detail-label">Status</span><span class="badge badge-${fn:toLowerCase(booking.status)}">${booking.status}</span></div>
                <div class="detail-item"><span class="detail-label">Event Date</span><span class="detail-value"><fmt:formatDate value="${booking.eventDate}" pattern="dd MMM yyyy"/></span></div>
                <div class="detail-item"><span class="detail-label">Event Type</span><span class="detail-value">${booking.eventType}</span></div>
                <div class="detail-item"><span class="detail-label">Guest Count</span><span class="detail-value">${booking.guestCount}</span></div>
                <div class="detail-item"><span class="detail-label">Total Price</span><span class="detail-value text-primary">NPR <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0"/></span></div>
                <div class="detail-item"><span class="detail-label">Booked On</span><span class="detail-value"><fmt:formatDate value="${booking.createdAt}" pattern="dd MMM yyyy"/></span></div>
            </div>
            <c:if test="${not empty booking.specialRequests}">
                <div style="margin-top:14px;"><div class="detail-label">Special Requests</div><div style="margin-top:4px;color:var(--gray);">${booking.specialRequests}</div></div>
            </c:if>
        </div>
        <div>
            <div class="info-panel">
                <h3>Hall Information</h3>
                <div class="detail-grid">
                    <div class="detail-item"><span class="detail-label">Hall Name</span><span class="detail-value">${booking.hallName}</span></div>
                    <div class="detail-item"><span class="detail-label">Location</span><span class="detail-value">${booking.hallLocation}</span></div>
                </div>
            </div>
            <div class="info-panel">
                <h3>Customer Information</h3>
                <div class="detail-grid">
                    <div class="detail-item"><span class="detail-label">Name</span><span class="detail-value">${booking.customerName}</span></div>
                    <div class="detail-item"><span class="detail-label">Email</span><span class="detail-value">${booking.customerEmail}</span></div>
                    <div class="detail-item"><span class="detail-label">Phone</span><span class="detail-value">${booking.customerPhone}</span></div>
                </div>
            </div>
            <c:if test="${booking.status == 'PENDING'}">
            <div class="info-panel">
                <h3>Actions</h3>
                <div style="display:flex;gap:10px;">
                    <form method="post" action="${pageContext.request.contextPath}/BookingServlet">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        <button class="btn btn-success">✅ Approve</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/BookingServlet">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        <button class="btn btn-danger">❌ Cancel</button>
                    </form>
                </div>
            </div>
            </c:if>
        </div>
    </div>
</div>
</div>
</body></html>
