<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Halls - Marriage Hall Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page-shell">
<jsp:include page="/WEB-INF/header.jsp"/>
<div class="container page-wrapper">
    <div class="page-header">
        <div>
            <h1>Browse Marriage Halls</h1>
            <div class="breadcrumb">Home <span>/</span> Halls</div>
        </div>
        <span style="color:var(--gray);font-size:0.9rem;">${fn:length(halls)} halls found</span>
    </div>

    <!-- Search Bar -->
    <div class="search-section" style="margin-bottom:30px;">
        <form action="${pageContext.request.contextPath}/HallServlet" method="get" class="search-form">
            <input type="hidden" name="action" value="search">
            <div class="form-group">
                <label>City</label>
                <input type="text" name="city" value="${searchCity}" placeholder="e.g. Kathmandu">
            </div>
            <div class="form-group">
                <label>Min. Capacity</label>
                <input type="number" name="capacity" value="${searchCap}" placeholder="e.g. 200">
            </div>
            <div class="form-group">
                <label>Max Price (NPR)</label>
                <input type="number" name="maxPrice" value="${searchPrice}" placeholder="e.g. 80000">
            </div>
            <div class="form-group">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
            </div>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty halls}">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fa-solid fa-house" style="color: rgb(0, 0, 0);"></i>
                </div>
                <p>No halls found matching your criteria.</p>
                <a href="${pageContext.request.contextPath}/HallServlet?action=list" class="btn btn-outline mt-2">Clear Filters</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="halls-grid">
                <c:forEach var="hall" items="${halls}">
                <div class="card hall-card">
                    <div class="card-img">
                        <img src="${pageContext.request.contextPath}/${hall.imageUrl}"
                                               alt="Hall Image">
                        </div>
                    <div class="card-body">
                        <span class="location-tag"><i class="fa-solid fa-hourglass-half" style="color: rgb(0, 0, 0);"></i>
                        ${hall.city}</span>
                        <div class="card-title">${hall.hallName}</div>
                        <div class="card-text"><i class="fa-solid fa-thumbtack"></i> ${hall.location}</div>
                        <div class="card-text" style="font-size:0.85rem;">${fn:substring(hall.description,0,80)}...</div>
                        <div class="facilities-tags">
                            <c:forEach var="f" items="${fn:split(hall.facilities, ',')}">
                                <span class="facility-tag">${fn:trim(f)}</span>
                            </c:forEach>
                        </div>
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:8px;">
                            <span class="price">NPR <fmt:formatNumber value="${hall.pricePerDay}" pattern="#,##0"/>/day</span>
                            <span class="capacity"><i class="fa-solid fa-people-group" style="color: rgb(0, 0, 0);"></i>
 Up to ${hall.seatingCapacity}</span>
                        </div>
                    </div>
                    <div class="card-footer">
                        <span class="status-badge status-${fn:toLowerCase(hall.status)}">${hall.status}</span>
                        <a href="${pageContext.request.contextPath}/HallServlet?action=view&id=${hall.hallId}" class="btn btn-primary btn-sm">View & Book</a>
                    </div>
                </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<footer><p>© 2026 MarriageHall Booking System. Made with <span><i class="fa-solid fa-heart"></i></span> for your special day.</p></footer>
</body>
</html>
