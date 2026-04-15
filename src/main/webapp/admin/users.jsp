<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"ADMIN".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    String pt = (String) request.getAttribute("pageTitle");
    if (pt == null) pt = "All Users";
    request.setAttribute("currentPage", pt.contains("Customer") ? "customers" : pt.contains("Owner") ? "owners" : "users");
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>${pageTitle != null ? pageTitle : 'All Users'} - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/admin-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <h1>${not empty pageTitle ? pageTitle : 'All Users'}</h1>
        <a href="${pageContext.request.contextPath}/AdminServlet?action=addOwnerForm" class="btn btn-primary">➕ Add Owner</a>
    </div>
    <c:if test="${not empty param.msg}"><div class="alert alert-success">✅ ${param.msg}</div></c:if>
    <div class="table-card">
        <table>
            <thead><tr><th>#</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Status</th><th>Joined</th><th>Actions</th></tr></thead>
            <tbody>
            <c:forEach var="usr" items="${users}">
            <tr>
                <td>${usr.userId}</td>
                <td><strong>${usr.fullName}</strong></td>
                <td>${usr.email}</td>
                <td>${usr.phone}</td>
                <td><span class="badge badge-${fn:toLowerCase(usr.role)}">${usr.role}</span></td>
                <td><span class="badge badge-${fn:toLowerCase(usr.status)}">${usr.status}</span></td>
                <td><fmt:formatDate value="${usr.createdAt}" pattern="dd MMM yyyy"/></td>
                <td style="white-space:nowrap;">
                    <c:choose>
                        <c:when test="${usr.status=='ACTIVE'}">
                            <a href="${pageContext.request.contextPath}/AdminServlet?action=toggleUserStatus&id=${usr.userId}&status=INACTIVE" class="btn btn-warning btn-sm">Deactivate</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/AdminServlet?action=toggleUserStatus&id=${usr.userId}&status=ACTIVE" class="btn btn-success btn-sm">Activate</a>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${usr.role != 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/AdminServlet?action=deleteUser&id=${usr.userId}" class="btn btn-danger btn-sm" onclick="return confirm('Delete user ${usr.fullName}?')">Del</a>
                    </c:if>
                </td>
            </tr>
            </c:forEach>
            <c:if test="${empty users}"><tr><td colspan="8" style="text-align:center;padding:30px;color:var(--gray);">No users found</td></tr></c:if>
            </tbody>
        </table>
    </div>
</div>
</div>
</body></html>
