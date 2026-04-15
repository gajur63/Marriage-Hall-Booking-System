<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"OWNER".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    com.gajur.marriagehallbookingsystem.dao.HallDAO hd    = new com.gajur.marriagehallbookingsystem.dao.HallDAO();
    com.gajur.marriagehallbookingsystem.dao.BookingDAO bd = new com.gajur.marriagehallbookingsystem.dao.BookingDAO();
    java.util.List myHalls    = hd.getHallsByOwner(u.getUserId());
    java.util.List myBookings = bd.getBookingsByOwner(u.getUserId());
    int pending = 0, approved = 0;
    for (Object o : myBookings) {
        com.gajur.marriagehallbookingsystem.model.Booking b = (com.gajur.marriagehallbookingsystem.model.Booking) o;
        if ("PENDING".equals(b.getStatus()))  pending++;
        if ("APPROVED".equals(b.getStatus())) approved++;
    }
    request.setAttribute("myHalls",    myHalls);
    request.setAttribute("myBookings", myBookings);
    request.setAttribute("hallCount",  myHalls.size());
    request.setAttribute("bookingCount", myBookings.size());
    request.setAttribute("pendingCount", pending);
    request.setAttribute("approvedCount", approved);
    request.setAttribute("currentPage","dashboard");
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Owner Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/owner-sidebar.jsp"/>
<div class="main-content">
    <div class="welcome-banner" style="background:linear-gradient(135deg,#6a1238,#8B1A4A);border-radius:14px;padding:26px 30px;color:white;margin-bottom:24px;display:flex;justify-content:space-between;align-items:center;">
        <div><h2 style="font-size:1.4rem;font-weight:800;margin-bottom:4px;">Welcome, ${user.fullName}! 🏛️</h2>
        <p style="opacity:0.85;font-size:0.9rem;">Manage your halls and approve booking requests from here.</p></div>
        <span style="font-size:3.5rem;opacity:0.3;">🏢</span>
    </div>

    <div class="stats-grid" style="grid-template-columns:repeat(4,1fr);margin-bottom:26px;">
        <div class="stat-card"><div class="stat-icon icon-primary">🏛️</div><div class="stat-info"><div class="stat-value">${hallCount}</div><div class="stat-label">My Halls</div></div></div>
        <div class="stat-card"><div class="stat-icon icon-secondary">📋</div><div class="stat-info"><div class="stat-value">${bookingCount}</div><div class="stat-label">Total Bookings</div></div></div>
        <div class="stat-card"><div class="stat-icon icon-danger">⏳</div><div class="stat-info"><div class="stat-value">${pendingCount}</div><div class="stat-label">Pending</div></div></div>
        <div class="stat-card"><div class="stat-icon icon-success">✅</div><div class="stat-info"><div class="stat-value">${approvedCount}</div><div class="stat-label">Approved</div></div></div>
    </div>

    <div style="display:flex;gap:10px;margin-bottom:24px;flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/HallServlet?action=ownerAddForm" class="btn btn-primary">➕ Add Hall</a>
        <a href="${pageContext.request.contextPath}/BookingServlet?action=ownerBookings" class="btn btn-outline">📋 View All Bookings</a>
    </div>

    <!-- Pending booking requests -->
    <div class="table-card" style="margin-bottom:24px;">
        <div class="table-header"><h3>⏳ Pending Booking Requests</h3>
            <a href="${pageContext.request.contextPath}/BookingServlet?action=ownerBookings" class="btn btn-outline btn-sm">View All</a>
        </div>
        <c:set var="hasPending" value="false"/>
        <c:forEach var="b" items="${myBookings}">
        <c:if test="${b.status=='PENDING'}">
        <c:set var="hasPending" value="true"/>
        <div style="padding:14px 18px;border-bottom:1px solid var(--border);display:grid;grid-template-columns:1fr auto;gap:12px;align-items:center;">
            <div>
                <div style="font-weight:600;">${b.hallName} — ${b.customerName}</div>
                <div style="font-size:0.82rem;color:var(--gray);">📅 <fmt:formatDate value="${b.eventDate}" pattern="dd MMM yyyy"/> &nbsp;·&nbsp; ${b.eventType} &nbsp;·&nbsp; 👥 ${b.guestCount} guests</div>
            </div>
            <div style="display:flex;gap:8px;">
                <form method="post" action="${pageContext.request.contextPath}/BookingServlet" style="display:inline;">
                    <input type="hidden" name="action" value="approve"><input type="hidden" name="bookingId" value="${b.bookingId}">
                    <button class="btn btn-success btn-sm">✅ Approve</button>
                </form>
                <form method="post" action="${pageContext.request.contextPath}/BookingServlet" style="display:inline;">
                    <input type="hidden" name="action" value="reject"><input type="hidden" name="bookingId" value="${b.bookingId}">
                    <button class="btn btn-danger btn-sm">❌ Reject</button>
                </form>
            </div>
        </div>
        </c:if>
        </c:forEach>
        <c:if test="${!hasPending}">
            <div class="empty-state"><div class="empty-icon">✅</div><p>No pending requests.</p></div>
        </c:if>
    </div>

    <!-- My Halls summary -->
    <div class="table-card">
        <div class="table-header"><h3>🏛️ My Halls</h3>
            <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList" class="btn btn-outline btn-sm">Manage</a>
        </div>
        <table>
            <thead><tr><th>Hall Name</th><th>City</th><th>Capacity</th><th>Price/Day</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
            <c:forEach var="h" items="${myHalls}">
            <tr>
                <td><strong>${h.hallName}</strong></td>
                <td>${h.city}</td>
                <td>👥 ${h.seatingCapacity}</td>
                <td>NPR <fmt:formatNumber value="${h.pricePerDay}" pattern="#,##0"/></td>
                <td><span class="badge badge-${h.status=='AVAILABLE'?'approved':'cancelled'}">${h.status}</span></td>
                <td>
                    <a href="${pageContext.request.contextPath}/HallServlet?action=editForm&id=${h.hallId}" class="btn btn-warning btn-sm">Edit</a>
                    <a href="${pageContext.request.contextPath}/HallServlet?action=availability&id=${h.hallId}" class="btn btn-info btn-sm">Availability</a>
                </td>
            </tr>
            </c:forEach>
            <c:if test="${empty myHalls}"><tr><td colspan="6" style="text-align:center;padding:24px;color:var(--gray);">No halls yet. <a href="${pageContext.request.contextPath}/HallServlet?action=ownerAddForm">Add one →</a></td></tr></c:if>
            </tbody>
        </table>
    </div>
</div>
</div>
</body></html>
