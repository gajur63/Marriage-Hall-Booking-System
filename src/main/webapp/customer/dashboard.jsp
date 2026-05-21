<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.javaproject.marriagehallbookingsystem.model.User u = (com.javaproject.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"CUSTOMER".equals(u.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    com.javaproject.marriagehallbookingsystem.dao.HallDAO hd = new com.javaproject.marriagehallbookingsystem.dao.HallDAO();
    com.javaproject.marriagehallbookingsystem.dao.BookingDAO bd = new com.javaproject.marriagehallbookingsystem.dao.BookingDAO();
    com.javaproject.marriagehallbookingsystem.dao.NotificationDAO nd = new com.javaproject.marriagehallbookingsystem.dao.NotificationDAO();

    java.util.List availableHalls = hd.getAvailableHalls();
    java.util.List myBookings     = bd.getBookingsByCustomer(u.getUserId());
    int unread = nd.countUnread(u.getUserId());

    int total     = myBookings.size();
    int pending   = 0, approved = 0, cancelled = 0, completed = 0;
    for (Object obj : myBookings) {
        com.javaproject.marriagehallbookingsystem.model.Booking b = (com.javaproject.marriagehallbookingsystem.model.Booking) obj;
        switch (b.getStatus()) {
            case "PENDING":   pending++;   break;
            case "APPROVED":  approved++;  break;
            case "CANCELLED": cancelled++; break;
            case "COMPLETED": completed++; break;

        }
    }

    // Only show last 5 bookings on dashboard
    java.util.List recent = myBookings.size() > 5 ? myBookings.subList(0, 5) : myBookings;

    request.setAttribute("availableHalls", availableHalls);
    request.setAttribute("myBookings", recent);
    request.setAttribute("totalBookings", total);
    request.setAttribute("pendingBookings", pending);
    request.setAttribute("approvedBookings", approved);
    request.setAttribute("cancelledBookings", cancelled);
    request.setAttribute("completedBookings", completed);
    request.setAttribute("unreadCount", unread);
    request.setAttribute("currentPage", "dashboard");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - Marriage Hall Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .hall-book-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
        }
        .hall-book-card:hover { transform: translateY(-4px); box-shadow: 0 8px 28px rgba(0,0,0,0.14); }
        .hall-book-card .hall-thumb {
            height: 130px;
            background: linear-gradient(135deg, #f3e5f5 0%, #fce4ec 100%);
            display: flex; align-items: center; justify-content: center;
            font-size: 3.5rem;
        }
        .hall-book-card .hall-info { padding: 16px; flex: 1; }
        .hall-book-card .hall-name { font-weight: 700; font-size: 1rem; color: var(--dark); margin-bottom: 4px; }
        .hall-book-card .hall-meta { font-size: 0.82rem; color: var(--gray); margin-bottom: 6px; }
        .hall-book-card .hall-price { font-weight: 700; color: var(--primary); font-size: 1.05rem; }
        .hall-book-card .hall-cap   { font-size: 0.8rem; color: var(--gray); }
        .hall-book-card .hall-footer { padding: 12px 16px; border-top: 1px solid var(--border); background: #fafafa; display: flex; gap: 8px; }

        .quick-book-modal {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.5); z-index: 2000;
            align-items: center; justify-content: center;
        }
        .quick-book-modal.open { display: flex; }
        .modal-box {
            background: white; border-radius: 16px; padding: 32px;
            width: 100%; max-width: 480px; box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            position: relative; animation: popIn 0.25s ease;
        }
        @keyframes popIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .modal-close { position: absolute; top: 14px; right: 18px; font-size: 1.4rem; cursor: pointer; color: var(--gray); background: none; border: none; }
        .modal-title { font-size: 1.2rem; font-weight: 700; color: var(--primary); margin-bottom: 4px; }
        .modal-sub   { font-size: 0.85rem; color: var(--gray); margin-bottom: 20px; }

        .tab-bar { display: flex; gap: 0; border-bottom: 2px solid var(--border); margin-bottom: 22px; }
        .tab-btn { padding: 10px 20px; background: none; border: none; font-size: 0.93rem; font-weight: 600; color: var(--gray); cursor: pointer; border-bottom: 3px solid transparent; margin-bottom: -2px; transition: all 0.2s; }
        .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }
        .tab-pane { display: none; }
        .tab-pane.active { display: block; }

        .booking-row { display: grid; grid-template-columns: 40px 1fr auto; gap: 12px; align-items: center; padding: 14px 0; border-bottom: 1px solid var(--border); }
        .booking-row:last-child { border-bottom: none; }
        .booking-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .booking-info .b-hall  { font-weight: 600; font-size: 0.94rem; }
        .booking-info .b-date  { font-size: 0.8rem; color: var(--gray); margin-top: 2px; }
        .booking-actions { display: flex; gap: 6px; align-items: center; }

        .halls-scroll { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 18px; }

        .welcome-banner {
            background: linear-gradient(135deg, var(--primary) 0%, #c0392b 100%);
            border-radius: 14px; padding: 28px 30px; color: white; margin-bottom: 26px;
            display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;
        }
        .welcome-banner h2 { font-size: 1.5rem; font-weight: 800; margin-bottom: 4px; }
        .welcome-banner p  { opacity: 0.85; font-size: 0.92rem; }
        .welcome-banner .banner-icon { font-size: 4rem; opacity: 0.3; }
    </style>
</head>
<body>
<div class="page-shell">
<jsp:include page="/WEB-INF/header.jsp"/>
<div class="dashboard-layout">

    <jsp:include page="/WEB-INF/customer-sidebar.jsp"/>

    <div class="main-content">

        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <div>
                <h2>Welcome back, ${user.fullName}! <i class="fa-solid fa-hand" style="color: rgb(0, 0, 0);"></i></h2>
                <p>Ready to plan your perfect event? Browse halls and book your dream venue below.</p>
            </div>
            <div class="banner-icon"><i class="fa-solid fa-ring" style="color: rgb(0, 0, 0);"></i></div>
        </div>

        <!-- Alert messages -->
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success">✅ ${param.msg}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">⚠️ ${param.error}</div>
        </c:if>

        <!-- Stats -->
        <div class="stats-grid" style="grid-template-columns: repeat(4, 1fr); margin-bottom: 28px;">
            <div class="stat-card">
                <div class="stat-icon icon-secondary"><i class="fa-solid fa-file-lines" style="color: rgb(0, 0, 0);"></i></div>
                <div class="stat-info">
                    <div class="stat-value">${totalBookings}</div>
                    <div class="stat-label">Total Bookings</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-danger"><i class="fa-solid fa-hourglass-half" style="color: rgb(0, 0, 0);"></i></div>
                <div class="stat-info">
                    <div class="stat-value">${pendingBookings}</div>
                    <div class="stat-label">Pending</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-success"><i class="fa-solid fa-circle-check" style="color: rgb(0, 0, 0);"></i></div>
                <div class="stat-info">
                    <div class="stat-value">${approvedBookings}</div>
                    <div class="stat-label">Approved</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-info"><i class="fa-solid fa-calendar-check" style="color: rgb(0, 0, 0);"></i></div>
                <div class="stat-info">
                    <div class="stat-value">${completedBookings}</div>
                    <div class="stat-label">Completed</div>
                </div>
            </div>
        </div>

        <!-- Tabs -->
        <div class="tab-bar">
            <button class="tab-btn active" onclick="switchTab(event,'tab-halls')"><i class="fa-solid fa-house" style="color: rgb(0, 0, 0);"></i> Browse &amp; Book Halls</button>
            <button class="tab-btn"        onclick="switchTab(event,'tab-bookings')"><i class="fa-solid fa-file-lines" style="color: rgb(0, 0, 0);"></i> My Bookings</button>
        </div>

        <!-- TAB: Browse Halls -->
        <div id="tab-halls" class="tab-pane active">

            <!-- Search / Filter -->
            <div style="background:white;border-radius:10px;padding:18px 20px;box-shadow:0 2px 10px rgba(0,0,0,0.06);margin-bottom:20px;">
                <form action="${pageContext.request.contextPath}/HallServlet" method="get"
                      style="display:grid;grid-template-columns:1fr 1fr 1fr auto;gap:12px;align-items:end;">
                    <input type="hidden" name="action" value="search">
                    <div class="form-group" style="margin:0;">
                        <label>City</label>
                        <input type="text" name="city" placeholder="e.g. Kathmandu">
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Min. Capacity</label>
                        <input type="number" name="capacity" placeholder="e.g. 200" min="0">
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Max Price (NPR/day)</label>
                        <input type="number" name="maxPrice" placeholder="e.g. 80000" min="0">
                    </div>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-magnifying-glass" style="color: rgb(0, 0, 0);"></i> Search</button>
                </form>
            </div>

            <!-- Hall Cards -->
            <c:choose>
                <c:when test="${empty availableHalls}">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fa-solid fa-house" style="color: rgb(0, 0, 0);"></i></div>
                        <p>No halls available at the moment.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="halls-scroll">
                        <c:forEach var="hall" items="${availableHalls}">
                        <div class="hall-book-card">
                            <div class="hall-thumb">
<%--                                hall_image endpoint--%>
                                <img src="${pageContext.request.contextPath}/${hall.imageUrl}"
                                                         alt="Hall Image"></div>
                            <div class="hall-info">
                                <div class="hall-name">${hall.hallName}</div>
                                <div class="hall-meta"><i class="fa-solid fa-location-dot" style="color: rgb(0, 0, 0);"></i> ${hall.location}, ${hall.city}</div>
                                <div class="hall-meta"><i class="fa-solid fa-phone" style="color: rgb(0, 0, 0);"></i> ${hall.contactNumber}</div>
                                <div style="display:flex;flex-wrap:wrap;gap:4px;margin:6px 0;">
                                    <c:forEach var="f" items="${fn:split(hall.facilities,',')}">
                                        <span class="facility-tag">${fn:trim(f)}</span>
                                    </c:forEach>
                                </div>
                                <div style="display:flex;justify-content:space-between;align-items:center;margin-top:8px;">
                                    <span class="hall-price">NPR <fmt:formatNumber value="${hall.pricePerDay}" pattern="#,##0"/>/day</span>
                                    <span class="hall-cap"><i class="fa-solid fa-users" style="color: rgb(0, 0, 0);"></i> ${hall.seatingCapacity}</span>
                                </div>
                            </div>
                            <div class="hall-footer">
                                <button class="btn btn-primary btn-sm"
                                        style="flex:1;"
                                        onclick="openBookModal(
                                            '${hall.hallId}',
                                            '${hall.hallName}',
                                            '${hall.location}, ${hall.city}',
                                            '${hall.pricePerDay}',
                                            '${hall.seatingCapacity}'
                                        )">
                                    Quick Book
                                </button>
                                <a href="${pageContext.request.contextPath}/HallServlet?action=view&id=${hall.hallId}"
                                   class="btn btn-outline btn-sm">Details</a>
                            </div>
                        </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- TAB: My Bookings -->
        <div id="tab-bookings" class="tab-pane">

            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                <p style="color:var(--gray);font-size:0.9rem;">Showing your ${totalBookings} booking(s).</p>
                <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="btn btn-outline btn-sm">View All</a>
            </div>

            <div class="table-card">
                <c:choose>
                    <c:when test="${empty myBookings}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fa-solid fa-file-lines" style="color: rgb(0, 0, 0);"></i></div>
                            <p>You haven't made any bookings yet.</p>
                            <button onclick="switchTabByName('tab-halls')" class="btn btn-primary mt-2">Browse Halls →</button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${myBookings}">
                        <div class="booking-row">
                            <div class="booking-icon
                                <c:choose>
                                    <c:when test="${b.status=='APPROVED'}">icon-success</c:when>
                                    <c:when test="${b.status=='PENDING'}">icon-secondary</c:when>
                                    <c:when test="${b.status=='CANCELLED'}">icon-danger</c:when>
                                    <c:otherwise>icon-info</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${b.status=='APPROVED'}"><i class="fa-solid fa-circle-check" style="color: rgb(0, 0, 0);"></i></c:when>
                                    <c:when test="${b.status=='PENDING'}"><i class="fa-solid fa-hourglass-half" style="color: rgb(0, 0, 0);"></i></c:when>
                                    <c:when test="${b.status=='CANCELLED'}"><i class="fa-solid fa-circle-xmark" style="color: rgb(0, 0, 0);"></i></c:when>
                                    <c:otherwise><i class="fa-solid fa-gift" style="color: rgb(0, 0, 0);"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="booking-info">
                                <div class="b-hall">${b.hallName}</div>
                                <div class="b-date">
                                    <i class="fa-solid fa-calendar-days" style="color: rgb(0, 0, 0);"></i> <fmt:formatDate value="${b.eventDate}" pattern="dd MMM yyyy"/>
                                    &nbsp;·&nbsp; ${b.eventType}
                                    &nbsp;·&nbsp; <i class="fa-solid fa-people-group" style="color: rgb(0, 0, 0);"></i> ${b.guestCount} guests
                                    &nbsp;·&nbsp; NPR <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0"/>
                                </div>
                            </div>
                            <div class="booking-actions">
                                <span class="badge badge-${fn:toLowerCase(b.status)}">${b.status}</span>
                                <a href="${pageContext.request.contextPath}/BookingServlet?action=detail&id=${b.bookingId}"
                                   class="btn btn-info btn-sm">View</a>
                                <c:if test="${b.status == 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/BookingServlet?action=cancel&id=${b.bookingId}"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Cancel this booking?')">Cancel</a>
                                </c:if>
                            </div>
                        </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div><!-- /main-content -->
</div><!-- /dashboard-layout -->


<!-- ============ QUICK BOOK MODAL ============ -->
<div class="quick-book-modal" id="bookModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeBookModal()">✕</button>
        <div class="modal-title" id="modal-hall-name">Book Hall</div>
        <div class="modal-sub"  id="modal-hall-loc"></div>

        <div style="display:flex;justify-content:space-between;background:var(--accent);border-radius:8px;padding:12px 16px;margin-bottom:18px;">
            <div>
                <div style="font-size:0.75rem;color:var(--gray);">Price Per Day</div>
                <div style="font-weight:700;color:var(--primary);" id="modal-hall-price">NPR -</div>
            </div>
            <div>
                <div style="font-size:0.75rem;color:var(--gray);">Max Capacity</div>
                <div style="font-weight:700;" id="modal-hall-cap">- guests</div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/BookingServlet" method="post" id="bookingForm">
            <input type="hidden" name="action" value="book">
            <input type="hidden" name="hallId" id="modal-hall-id">

            <div class="form-row">
                <div class="form-group">
                    <label>Event Date *</label>
                    <input type="date" name="eventDate" id="modal-event-date" required
                           min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                </div>
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
            </div>
            <div class="form-group">
                <label>Number of Guests *</label>
                <input type="number" name="guestCount" id="modal-guest-count" required min="1" placeholder="e.g. 300">
            </div>
            <div class="form-group">
                <label>Special Requests (optional)</label>
                <textarea name="specialRequests" rows="2"
                          placeholder="Any special requirements, decoration preferences, etc."></textarea>
            </div>

            <div style="background:#fff3cd;border-radius:8px;padding:10px 14px;margin-bottom:16px;font-size:0.82rem;color:#856404;">
                <i class="fa-solid fa-triangle-exclamation" style="color: rgb(0, 0, 0);"></i> Booking will be <strong>PENDING</strong> until approved by the hall owner / admin.
            </div>

            <div class="form-actions" style="margin-top:0;">
                <button type="submit" class="btn btn-primary" style="flex:1;"><i class="fa-solid fa-calendar-days" style="color: rgb(0, 0, 0);"></i> Submit Booking</button>
                <button type="button" onclick="closeBookModal()" class="btn btn-outline">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function switchTab(e, tabId) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    e.currentTarget.classList.add('active');
    document.getElementById(tabId).classList.add('active');
}
function switchTabByName(tabId) {
    const idx = tabId === 'tab-halls' ? 0 : 1;
    document.querySelectorAll('.tab-btn')[idx].classList.add('active');
    document.querySelectorAll('.tab-btn')[1-idx].classList.remove('active');
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
}

function openBookModal(hallId, hallName, hallLoc, price, cap) {
    document.getElementById('modal-hall-id').value   = hallId;
    document.getElementById('modal-hall-name').textContent =  "Book: " + hallName;
    document.getElementById('modal-hall-loc').textContent  =  hallLoc;
    document.getElementById('modal-hall-price').textContent = 'NPR ' + Number(price).toLocaleString() + '/day';
    document.getElementById('modal-hall-cap').textContent   = cap + ' guests';
    document.getElementById('modal-guest-count').max = cap;
    document.getElementById('bookModal').classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeBookModal() {
    document.getElementById('bookModal').classList.remove('open');
    document.body.style.overflow = '';
}
// Close on backdrop click
document.getElementById('bookModal').addEventListener('click', function(e){
    if (e.target === this) closeBookModal();
});

// Validate guest count vs capacity on submit
document.getElementById('bookingForm').addEventListener('submit', function(e) {
    const guests = parseInt(document.getElementById('modal-guest-count').value);
    const cap    = parseInt(document.getElementById('modal-hall-cap').textContent);
    if (guests > cap) {
        e.preventDefault();
        alert('Guest count (' + guests + ') exceeds hall capacity (' + cap + '). Please reduce the number of guests.');
    }
});
</script>
</body>
</html>
