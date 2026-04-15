<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"OWNER".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Add Hall - Owner</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/owner-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <h1>Add New Hall</h1>
        <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList" class="btn btn-outline">← Back</a>
    </div>
    <div class="form-card form-card-wide">
        <form action="${pageContext.request.contextPath}/HallServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-row">
                <div class="form-group"><label>Hall Name *</label><input type="text" name="hallName" required placeholder="e.g. Royal Garden Palace"></div>
                <div class="form-group"><label>City *</label><input type="text" name="city" required placeholder="e.g. Kathmandu"></div>
            </div>
            <div class="form-group"><label>Full Address / Location *</label><input type="text" name="location" required placeholder="e.g. Baneshwor, Kathmandu"></div>
            <div class="form-row">
                <div class="form-group"><label>Seating Capacity *</label><input type="number" name="seatingCapacity" required min="10" placeholder="e.g. 500"></div>
                <div class="form-group"><label>Price Per Day (NPR) *</label><input type="number" name="pricePerDay" required min="1" step="0.01" placeholder="e.g. 75000"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Contact Number</label><input type="text" name="contactNumber" placeholder="e.g. 9800000001"></div>
                <div class="form-group"><label>Status</label>
                    <select name="status"><option value="AVAILABLE">Available</option><option value="UNAVAILABLE">Unavailable</option></select>
                </div>
            </div>
            <div class="form-group"><label>Facilities (comma-separated)</label><input type="text" name="facilities" placeholder="e.g. AC, Parking, Generator, Catering, Stage, Wi-Fi"></div>
            <div class="form-group"><label>Image URL (optional)</label><input type="text" name="imageUrl" placeholder="https://..."></div>
            <div class="form-group"><label>Description</label><textarea name="description" rows="4" placeholder="Describe your hall..."></textarea></div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">➕ Add Hall</button>
                <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList" class="btn btn-outline">Cancel</a>
            </div>
        </form>
    </div>
</div>
</div>
</body></html>
