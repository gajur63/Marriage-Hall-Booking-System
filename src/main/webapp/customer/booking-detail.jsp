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
    <title>Booking #${booking.bookingId} Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="page-shell">
<jsp:include page="/WEB-INF/header.jsp"/>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/customer-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <div>
            <h1>Booking #${booking.bookingId}</h1>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a> <span>/</span>
                <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings">My Bookings</a> <span>/</span>
                #${booking.bookingId}
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="btn btn-outline">← Back</a>
    </div>

    <!-- Status Banner -->
    <div style="border-radius:12px;padding:20px 24px;margin-bottom:24px;display:flex;align-items:center;gap:16px;
        background:${booking.status=='APPROVED'?'#d4edda':booking.status=='PENDING'?'#fff3cd':booking.status=='CANCELLED'?'#f8d7da':'#d1ecf1'};
        border-left:5px solid ${booking.status=='APPROVED'?'#28a745':booking.status=='PENDING'?'#ffc107':booking.status=='CANCELLED'?'#dc3545':'#17a2b8'};">
        <span style="font-size:2rem;">
            <c:choose>
                <c:when test="${booking.status=='APPROVED'}">✅</c:when>
                <c:when test="${booking.status=='PENDING'}">⏳</c:when>
                <c:when test="${booking.status=='CANCELLED'}">❌</c:when>
                <c:otherwise>🎉</c:otherwise>
            </c:choose>
        </span>
        <div>
            <div style="font-weight:700;font-size:1.05rem;">Booking Status: <span class="badge badge-${fn:toLowerCase(booking.status)}">${booking.status}</span></div>
            <div style="font-size:0.85rem;margin-top:4px;">
                <c:choose>
                    <c:when test="${booking.status=='PENDING'}">Your booking is awaiting approval from the hall manager.</c:when>
                    <c:when test="${booking.status=='APPROVED'}">Congratulations! Your booking has been confirmed.</c:when>
                    <c:when test="${booking.status=='CANCELLED'}">This booking has been cancelled.</c:when>
                    <c:otherwise>This event has been completed. Thank you!</c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div class="info-panel">
            <h3>📋 Booking Information</h3>
            <div class="detail-grid">
                <div class="detail-item" style="margin-bottom:14px;">
                    <span class="detail-label">Booking ID</span>
                    <span class="detail-value">#${booking.bookingId}</span>
                </div>
                <div class="detail-item" style="margin-bottom:14px;">
                    <span class="detail-label">Event Date</span>
                    <span class="detail-value">📅 <fmt:formatDate value="${booking.eventDate}" pattern="dd MMMM yyyy"/></span>
                </div>
                <div class="detail-item" style="margin-bottom:14px;">
                    <span class="detail-label">Event Type</span>
                    <span class="detail-value">${booking.eventType}</span>
                </div>
                <div class="detail-item" style="margin-bottom:14px;">
                    <span class="detail-label">Number of Guests</span>
                    <span class="detail-value">👥 ${booking.guestCount}</span>
                </div>
                <div class="detail-item" style="margin-bottom:14px;">
                    <span class="detail-label">Total Price</span>
                    <span class="detail-value text-primary" style="font-size:1.15rem;font-weight:800;">NPR <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0"/></span>
                </div>
                <div class="detail-item" style="margin-bottom:14px;">
                    <span class="detail-label">Booked On</span>
                    <span class="detail-value"><fmt:formatDate value="${booking.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></span>
                </div>
            </div>
            <c:if test="${not empty booking.specialRequests}">
                <div style="margin-top:8px;">
                    <div class="detail-label">Special Requests</div>
                    <div style="margin-top:6px;background:var(--light);padding:10px;border-radius:8px;font-size:0.9rem;">${booking.specialRequests}</div>
                </div>
            </c:if>
        </div>

        <div>
            <div class="info-panel">
                <h3>🏛️ Hall Details</h3>
                <div class="detail-item" style="margin-bottom:12px;">
                    <span class="detail-label">Hall Name</span>
                    <span class="detail-value">${booking.hallName}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Location</span>
                    <span class="detail-value">📍 ${booking.hallLocation}</span>
                </div>
            </div>

            <c:if test="${booking.status == 'PENDING'}">
            <div class="info-panel">
                <h3>⚙️ Actions</h3>
                <p style="color:var(--gray);font-size:0.88rem;margin-bottom:14px;">You can cancel a pending booking if your plans change.</p>
                <a href="${pageContext.request.contextPath}/BookingServlet?action=cancel&id=${booking.bookingId}"
                   class="btn btn-danger"
                   onclick="return confirm('Are you sure you want to cancel this booking?')">
                   ❌ Cancel Booking
                </a>
            </div>
            </c:if>

            <div class="info-panel" style="text-align:center;">
                <div style="font-size:3rem;margin-bottom:8px;">
                    <c:choose>
                        <c:when test="${booking.status=='APPROVED'}">🎊</c:when>
                        <c:when test="${booking.status=='PENDING'}">⏳</c:when>
                        <c:when test="${booking.status=='CANCELLED'}">😔</c:when>
                        <c:otherwise>🎉</c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${booking.status == 'APPROVED'}">
                    <p style="color:var(--success);font-weight:600;">Your venue is confirmed! Enjoy your event 🎊</p>
                </c:if>
                <c:if test="${booking.status == 'PENDING'}">
                    <p style="color:#856404;font-weight:600;">Waiting for hall manager confirmation...</p>
                </c:if>
                <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn btn-outline btn-sm mt-2">← Back to Dashboard</a>
            </div>
        </div>
    </div>
</div>
</div>
</body>
</html>
