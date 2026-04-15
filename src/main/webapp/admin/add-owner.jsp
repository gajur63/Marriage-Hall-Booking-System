<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"ADMIN".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Add Hall Owner - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/admin-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <h1>Add Hall Owner</h1>
        <a href="${pageContext.request.contextPath}/AdminServlet?action=owners" class="btn btn-outline">← Back</a>
    </div>
    <c:if test="${not empty param.error}"><div class="alert alert-danger">⚠️ ${param.error}</div></c:if>
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
            <input type="hidden" name="action" value="addOwner">
            <div class="form-group"><label>Full Name *</label><input type="text" name="fullName" required placeholder="Owner's full name"></div>
            <div class="form-group"><label>Email Address *</label><input type="email" name="email" required placeholder="owner@example.com"></div>
            <div class="form-group"><label>Password *</label><input type="password" name="password" required minlength="6" placeholder="Min. 6 characters"></div>
            <div class="form-group"><label>Phone</label><input type="tel" name="phone" placeholder="98XXXXXXXX"></div>
            <div class="form-group"><label>Address</label><input type="text" name="address" placeholder="City / Address"></div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">➕ Add Owner</button>
                <a href="${pageContext.request.contextPath}/AdminServlet?action=owners" class="btn btn-outline">Cancel</a>
            </div>
        </form>
    </div>
</div>
</div>
</body></html>
