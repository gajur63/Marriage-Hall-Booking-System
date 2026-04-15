<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    com.gajur.marriagehallbookingsystem.dao.HallDAO hd = new com.gajur.marriagehallbookingsystem.dao.HallDAO();
    java.util.List halls = hd.getAvailableHalls();
    request.setAttribute("featuredHalls", halls);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marriage Hall Booking System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/header.jsp"/>

<!-- HERO -->
<section class="hero">
    <div class="hero-content">
        <h1>Find Your Perfect<br>Wedding Venue 💍</h1>
        <p>Browse hundreds of beautiful marriage halls. Book your dream venue in minutes — no paperwork, no hassle.</p>
        <div class="hero-btns">
            <a href="${pageContext.request.contextPath}/HallServlet?action=list" class="btn btn-white btn-lg">Browse All Halls</a>
            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary btn-lg">Get Started</a>
        </div>
    </div>
</section>

<!-- SEARCH -->
<div class="container">
<div class="search-section">
    <form action="${pageContext.request.contextPath}/HallServlet" method="get" class="search-form">
        <input type="hidden" name="action" value="search">
        <div class="form-group">
            <label>City / Location</label>
            <input type="text" name="city" placeholder="e.g. Kathmandu">
        </div>
        <div class="form-group">
            <label>Min. Capacity</label>
            <input type="number" name="capacity" placeholder="e.g. 200" min="0">
        </div>
        <div class="form-group">
            <label>Max Price (NPR/day)</label>
            <input type="number" name="maxPrice" placeholder="e.g. 80000" min="0">
        </div>
        <div class="form-group">
            <label>&nbsp;</label>
            <button type="submit" class="btn btn-primary w-100">🔍 Search</button>
        </div>
    </form>
</div>
</div>

<!-- FEATURED HALLS -->
<section class="section">
    <div class="container">
        <h2 class="section-title">Featured Marriage Halls</h2>
        <p class="section-sub">Handpicked top venues for your special day</p>
        <div class="halls-grid">
            <c:forEach var="hall" items="${featuredHalls}" end="5">
            <div class="card hall-card">
                <div class="card-img">🏛️</div>
                <div class="card-body">
                    <span class="location-tag">📍 ${hall.city}</span>
                    <div class="card-title">${hall.hallName}</div>
                    <div class="card-text">${hall.location}</div>
                    <div class="facilities-tags">
                        <c:forEach var="f" items="${fn:split(hall.facilities, ',')}">
                            <span class="facility-tag">${fn:trim(f)}</span>
                        </c:forEach>
                    </div>
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-top:8px;">
                        <span class="price">NPR <fmt:formatNumber value="${hall.pricePerDay}" pattern="#,##0"/>/day</span>
                        <span class="capacity">👥 ${hall.seatingCapacity} guests</span>
                    </div>
                </div>
                <div class="card-footer">
                    <span class="status-badge status-${fn:toLowerCase(hall.status)}">${hall.status}</span>
                    <a href="${pageContext.request.contextPath}/HallServlet?action=view&id=${hall.hallId}" class="btn btn-primary btn-sm">View Details</a>
                </div>
            </div>
            </c:forEach>
        </div>
        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/HallServlet?action=list" class="btn btn-outline btn-lg">View All Halls →</a>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="section" style="background:#fff;">
    <div class="container">
        <h2 class="section-title">Why Choose Us?</h2>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:24px;margin-top:30px;">
            <div style="text-align:center;padding:20px;">
                <div style="font-size:2.5rem;margin-bottom:10px;">🔍</div>
                <h3 style="color:var(--primary);margin-bottom:8px;">Easy Search</h3>
                <p style="color:var(--gray);font-size:0.9rem;">Filter by location, capacity & budget to find the perfect venue instantly.</p>
            </div>
            <div style="text-align:center;padding:20px;">
                <div style="font-size:2.5rem;margin-bottom:10px;">📅</div>
                <h3 style="color:var(--primary);margin-bottom:8px;">Real-time Availability</h3>
                <p style="color:var(--gray);font-size:0.9rem;">Know instantly which dates are available — no back-and-forth calls.</p>
            </div>
            <div style="text-align:center;padding:20px;">
                <div style="font-size:2.5rem;margin-bottom:10px;">✅</div>
                <h3 style="color:var(--primary);margin-bottom:8px;">Instant Confirmation</h3>
                <p style="color:var(--gray);font-size:0.9rem;">Get notified the moment your booking is approved by the hall owner.</p>
            </div>
            <div style="text-align:center;padding:20px;">
                <div style="font-size:2.5rem;margin-bottom:10px;">🛡️</div>
                <h3 style="color:var(--primary);margin-bottom:8px;">Secure & Reliable</h3>
                <p style="color:var(--gray);font-size:0.9rem;">Your booking records are safely stored with no risk of double-booking.</p>
            </div>
        </div>
    </div>
</section>

<footer>
    <p>© 2026 MarriageHall Booking System. Made with <span>♥</span> for your special day.</p>
</footer>
</body>
</html>
