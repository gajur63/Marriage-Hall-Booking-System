<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${hall.hallName} - Marriage Hall Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/header.jsp"/>
<div class="container page-wrapper">
    <div class="breadcrumb mb-2">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a> <span>/</span>
        <a href="${pageContext.request.contextPath}/HallServlet?action=list">Halls</a> <span>/</span>
        ${hall.hallName}
    </div>

    <div class="hall-detail-grid">
        <!-- LEFT -->
        <div>
            <div class="hall-detail-hero">
                <div style="font-size:5rem;text-align:center;margin-bottom:15px;"><img src="${pageContext.request.contextPath}/${hall.imageUrl}"
                                                                                       alt="Hall Image"></div></div>
                <h1 style="font-size:1.8rem;font-weight:800;color:var(--primary);">${hall.hallName}</h1>
                <p style="color:var(--gray);margin-top:5px;"><i class="fa-solid fa-thumbtack"></i> ${hall.location}, ${hall.city}</p>
                <p style="color:var(--gray);"><i class="fa-solid fa-phone"></i> ${hall.contactNumber}</p>
                <p style="color:var(--gray);"><i class="fa-solid fa-house" style="color: rgb(0, 0, 0);"></i>
                    Managed by ${hall.ownerName}</p>
            </div>

            <div class="info-panel">
                <h3>About This Hall</h3>
                <p style="color:var(--gray);line-height:1.7;">${hall.description}</p>
            </div>

            <div class="info-panel">
                <h3>Facilities & Amenities</h3>
                <div class="facilities-tags" style="gap:8px;">
                    <c:forEach var="f" items="${fn:split(hall.facilities, ',')}">
                        <span class="facility-tag" style="padding:5px 14px;font-size:0.88rem;">✓ ${fn:trim(f)}</span>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- RIGHT -->
        <div>
            <div class="info-panel">
                <h3>Hall Details</h3>
                <div class="detail-grid">
                    <div class="detail-item" style="margin-bottom:14px;">
                        <span class="detail-label">Price Per Day</span>
                        <span class="detail-value text-primary" style="font-size:1.3rem;">NPR <fmt:formatNumber value="${hall.pricePerDay}" pattern="#,##0"/></span>
                    </div>
                    <div class="detail-item" style="margin-bottom:14px;">
                        <span class="detail-label">Seating Capacity</span>
                        <span class="detail-value"><i class="fa-solid fa-people-group" style="color: rgb(0, 0, 0);"></i>

 Up to ${hall.seatingCapacity} guests</span>
                    </div>
                    <div class="detail-item" style="margin-bottom:14px;">
                        <span class="detail-label">Location</span>
                        <span class="detail-value">${hall.city}</span>
                    </div>
                    <div class="detail-item" style="margin-bottom:14px;">
                        <span class="detail-label">Availability</span>
                        <span class="status-badge status-${fn:toLowerCase(hall.status)}">${hall.status}</span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${sessionScope.user == null}">
                        <div class="alert alert-info" style="margin-top:16px;">
                            <a href="${pageContext.request.contextPath}/login.jsp">Login</a> or
                            <a href="${pageContext.request.contextPath}/register.jsp">Register</a> to book this hall.
                        </div>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'CUSTOMER' && hall.status == 'AVAILABLE'}">
                        <a href="${pageContext.request.contextPath}/BookingServlet?action=bookForm&hallId=${hall.hallId}" class="btn btn-primary w-100 btn-lg" style="margin-top:16px;"><i class="fa-solid fa-calendar-days"></i> Book This Hall</a>
                    </c:when>
                    <c:when test="${hall.status != 'AVAILABLE'}">
                        <div class="alert alert-warning" style="margin-top:16px;">This hall is currently not available for booking.</div>
                    </c:when>
                </c:choose>
            </div>

            <c:if test="${not empty blockedDates}">
            <div class="info-panel">
                <h3>Blocked / Unavailable Dates</h3>
                <div style="display:flex;flex-wrap:wrap;gap:6px;">
                    <c:forEach var="d" items="${blockedDates}">
                        <span style="background:#f8d7da;color:#721c24;padding:4px 10px;border-radius:12px;font-size:0.8rem;">
                            <fmt:formatDate value="${d}" pattern="dd MMM yyyy"/>
                        </span>
                    </c:forEach>
                </div>
            </div>
            </c:if>
        </div>
    </div>

<footer><p>© 2026 MarriageHall Booking System. Made with <span><i class="fa-solid fa-heart"></i></span> for your special day.</p></footer>
</body>
</html>
