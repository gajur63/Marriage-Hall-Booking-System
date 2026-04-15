<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"OWNER".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Edit Hall - Owner</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/owner-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <h1>Edit Hall: ${hall.hallName}</h1>
        <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList" class="btn btn-outline">← Back</a>
    </div>
    <div class="form-card form-card-wide">
        <form action="${pageContext.request.contextPath}/HallServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="hallId" value="${hall.hallId}">
            <div class="form-row">
                <div class="form-group"><label>Hall Name *</label><input type="text" name="hallName" value="${hall.hallName}" required></div>
                <div class="form-group"><label>City *</label><input type="text" name="city" value="${hall.city}" required></div>
            </div>
            <div class="form-group"><label>Full Address *</label><input type="text" name="location" value="${hall.location}" required></div>
            <div class="form-row">
                <div class="form-group"><label>Seating Capacity *</label><input type="number" name="seatingCapacity" value="${hall.seatingCapacity}" required></div>
                <div class="form-group"><label>Price Per Day (NPR) *</label><input type="number" name="pricePerDay" value="${hall.pricePerDay}" required step="0.01"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Contact Number</label><input type="text" name="contactNumber" value="${hall.contactNumber}"></div>
                <div class="form-group"><label>Status</label>
                    <select name="status">
                        <option value="AVAILABLE"   ${hall.status=='AVAILABLE'  ?'selected':''}>Available</option>
                        <option value="UNAVAILABLE" ${hall.status=='UNAVAILABLE'?'selected':''}>Unavailable</option>
                    </select>
                </div>
            </div>
            <div class="form-group"><label>Facilities</label><input type="text" name="facilities" value="${hall.facilities}"></div>
            <div class="form-group"><label>Image URL</label><input type="text" name="imageUrl" value="${hall.imageUrl}"></div>
            <div class="form-group"><label>Description</label><textarea name="description" rows="4">${hall.description}</textarea></div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList" class="btn btn-outline">Cancel</a>
            </div>
        </form>
    </div>
</div>
</div>
</body></html>
