<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="dashboard-layout">
    <c:choose>
        <c:when test="${user.role == 'ADMIN'}"><jsp:include page="/WEB-INF/admin-sidebar.jsp"/></c:when>
        <c:when test="${user.role == 'OWNER'}"><jsp:include page="/WEB-INF/owner-sidebar.jsp"/></c:when>
        <c:otherwise><jsp:include page="/WEB-INF/customer-sidebar.jsp"/></c:otherwise>
    </c:choose>

    <div class="main-content">
        <div class="page-header">
            <h1>My Profile</h1>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success">✅ ${param.msg}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">⚠️ ${param.error}</div>
        </c:if>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">
            <!-- Profile Info -->
            <div class="form-card">
                <h3 style="margin-bottom:20px;color:var(--primary);">👤 Personal Information</h3>
                <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" value="${profileUser.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" value="${profileUser.email}" disabled style="background:#f5f5f5;">
                    </div>
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="tel" name="phone" value="${profileUser.phone}">
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address" value="${profileUser.address}">
                    </div>
                    <div class="form-group">
                        <label>Role</label>
                        <input type="text" value="${profileUser.role}" disabled style="background:#f5f5f5;">
                    </div>
                    <div class="form-group">
                        <label>Member Since</label>
                        <input type="text" value="<fmt:formatDate value='${profileUser.createdAt}' pattern='dd MMM yyyy'/>" disabled style="background:#f5f5f5;">
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>

            <!-- Change Password -->
            <div class="form-card">
                <h3 style="margin-bottom:20px;color:var(--primary);">🔒 Change Password</h3>
                <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="form-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="btn btn-warning">Update Password</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
