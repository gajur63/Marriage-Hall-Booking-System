<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    com.javaproject.marriagehallbookingsystem.model.User u = (com.javaproject.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/header.jsp"/>
<div class="page-shell">
<div class="dashboard-layout">
    <c:choose>
        <c:when test="${user.role == 'ADMIN'}"><jsp:include page="/WEB-INF/admin-sidebar.jsp"/></c:when>
        <c:when test="${user.role == 'OWNER'}"><jsp:include page="/WEB-INF/owner-sidebar.jsp"/></c:when>
        <c:otherwise><jsp:include page="/WEB-INF/customer-sidebar.jsp"/></c:otherwise>
    </c:choose>
    <div class="main-content">
        <div class="page-header"><h1><i class="fa-solid fa-bell"></i> Notifications</h1></div>
        <div class="table-card" style="padding:20px;">
            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="empty-state"><div class="empty-icon"><i class="fa-solid fa-bell"></i></div><p>No notifications yet.</p></div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="n" items="${notifications}">
                    <div style="padding:14px;border-bottom:1px solid var(--border);display:flex;gap:12px;align-items:flex-start;">
                        <span style="font-size:1.4rem;"><i class="fa-solid fa-bullhorn"></i></span>
                        <div>
                            <p style="font-size:0.94rem;">${n.message}</p>
                            <p style="font-size:0.78rem;color:var(--gray);margin-top:4px;"><fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></p>
                        </div>
                    </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
