<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.marriagehall.model.User u = (com.marriagehall.model.User) session.getAttribute("user");
    if (u == null || !"CUSTOMER".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    request.setAttribute("currentPage","browse");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Book Hall - ${hall.hallName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/customer-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <div>
            <h1>Book a Hall</h1>
            <div class="breadcrumb"><a href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a> <span>/</span> Book Hall</div>
        </div>
        <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn btn-outline">← Back</a>
    </div>

    <c:if test="${not empty param.error}"><div class="alert alert-danger">⚠️ ${param.error}</div></c:if>

    <div style="display:grid;grid-template-columns:1fr 380px;gap:24px;">
        <!-- Booking Form -->
        <div class="form-card" style="max-width:100%;align-self:start;">
            <h3 style="color:var(--primary);margin-bottom:20px;">📅 Booking Details</h3>
            <form action="${pageContext.request.contextPath}/BookingServlet" method="post">
                <input type="hidden" name="action" value="book">
                <input type="hidden" name="hallId" value="${hall.hallId}">
                <div class="form-group">
                    <label>Event Date *</label>
                    <input type="date" name="eventDate" required
                           min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                    <div class="form-hint">Choose your preferred event date. Blocked/booked dates are not available.</div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Event Type *</label>
                        <select name="eventType" required>
                            <option value="Wedding">Wedding</option>
                            <option value="Reception">Reception</option>
                            <option value="Engagement">Engagement</option>
                            <option value="Birthday">Birthday Party</option>
                            <option value="Anniversary">Anniversary</option>
                            <option value="Corporate">Corporate Event</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Number of Guests *</label>
                        <input type="number" name="guestCount" required min="1" max="${hall.seatingCapacity}" placeholder="Max: ${hall.seatingCapacity}">
                        <div class="form-hint">Max capacity: ${hall.seatingCapacity}</div>
                    </div>
                </div>
                <div class="form-group">
                    <label>Special Requests (optional)</label>
                    <textarea name="specialRequests" rows="3" placeholder="Any special requirements, decoration preferences, dietary needs, etc."></textarea>
                </div>
                <div class="alert alert-warning">
                    ⚠️ Your booking will be <strong>PENDING</strong> until approved by the hall manager or admin. You will be notified once confirmed.
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-lg">📅 Confirm Booking</button>
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>

        <!-- Hall Summary Card -->
        <div style="align-self:start;">
            <div class="info-panel">
                <h3>🏛️ Hall Summary</h3>
                <div style="background:linear-gradient(135deg,var(--accent),#ead5c0);border-radius:10px;height:120px;display:flex;align-items:center;justify-content:center;font-size:3.5rem;margin-bottom:16px;">🏛️</div>
                <div class="detail-item" style="margin-bottom:12px;">
                    <span class="detail-label">Hall Name</span>
                    <span class="detail-value">${hall.hallName}</span>
                </div>
                <div class="detail-item" style="margin-bottom:12px;">
                    <span class="detail-label">Location</span>
                    <span class="detail-value">📍 ${hall.location}, ${hall.city}</span>
                </div>
                <div class="detail-item" style="margin-bottom:12px;">
                    <span class="detail-label">Seating Capacity</span>
                    <span class="detail-value">👥 Up to ${hall.seatingCapacity} guests</span>
                </div>
                <div class="detail-item" style="margin-bottom:12px;">
                    <span class="detail-label">Contact</span>
                    <span class="detail-value">📞 ${hall.contactNumber}</span>
                </div>
                <div style="background:var(--primary);color:white;border-radius:10px;padding:16px;text-align:center;margin-top:12px;">
                    <div style="font-size:0.8rem;opacity:0.8;margin-bottom:4px;">Price Per Day</div>
                    <div style="font-size:1.6rem;font-weight:800;">NPR <fmt:formatNumber value="${hall.pricePerDay}" pattern="#,##0"/></div>
                </div>
            </div>

            <div class="info-panel">
                <h3>✓ Facilities</h3>
                <div class="facilities-tags">
                    <c:forEach var="f" items="${fn:split(hall.facilities,',')}">
                        <span class="facility-tag" style="padding:5px 12px;">✓ ${fn:trim(f)}</span>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</body>
</html>
