<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    com.javaproject.marriagehallbookingsystem.model.User u = (com.javaproject.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"ADMIN".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    request.setAttribute("currentPage","halls");
%>
<head>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Manage Halls - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/header.jsp"/>

<div class="page-shell">

    <div class="dashboard-layout">

        <jsp:include page="/WEB-INF/admin-sidebar.jsp"/>

        <div class="main-content">
    <div class="page-header">
        <h1>Manage Halls</h1>
        <a href="${pageContext.request.contextPath}/HallServlet?action=addForm" class="btn btn-primary"><i class="fa-solid fa-plus" style="color: rgb(39, 49, 46);"></i> Add New Hall</a>
    </div>
    <c:if test="${not empty param.msg}"><div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> ${param.msg}</div></c:if>
    <div class="table-card">
        <table>
            <thead><tr><th>#</th><th>Hall Name</th><th>Owner</th><th>City</th><th>Capacity</th><th>Price/Day</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
            <c:forEach var="hall" items="${halls}">
            <tr>
                <td>${hall.hallId}</td>
                <td><strong>${hall.hallName}</strong><br><small style="color:var(--gray)">${hall.location}</small></td>
                <td>${hall.ownerName}</td>
                <td>${hall.city}</td>
                <td><i class="fa-solid fa-users" style="color: rgb(177, 151, 252);"></i> ${hall.seatingCapacity}</td>
                <td>NPR <fmt:formatNumber value="${hall.pricePerDay}" pattern="#,##0"/></td>
                <td><span class="badge badge-${hall.status=='AVAILABLE'?'approved':hall.status=='UNAVAILABLE'?'cancelled':'pending'}">${hall.status}</span></td>
                <td style="white-space:nowrap;">
                    <a href="${pageContext.request.contextPath}/HallServlet?action=view&id=${hall.hallId}" class="btn btn-info btn-sm">View</a>
                    <a href="${pageContext.request.contextPath}/HallServlet?action=editForm&id=${hall.hallId}" class="btn btn-warning btn-sm">Edit</a>
                    <a href="${pageContext.request.contextPath}/HallServlet?action=delete&id=${hall.hallId}" class="btn btn-danger btn-sm" onclick="return confirm('Delete this hall?')">Del</a>
                </td>
            </tr>
            </c:forEach>
            <c:if test="${empty halls}">
                <tr><td colspan="8" style="text-align:center;padding:30px;color:var(--gray);">No halls found</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</div>
</div></body></html>
