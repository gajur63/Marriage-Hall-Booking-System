<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    com.gajur.marriagehallbookingsystem.model.User navUser = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    int unread = 0;
    if (navUser != null) {
        com.gajur.marriagehallbookingsystem.dao.NotificationDAO nd = new com.gajur.marriagehallbookingsystem.dao.NotificationDAO();
        unread = nd.countUnread(navUser.getUserId());
    }
    request.setAttribute("navUser", navUser);
    request.setAttribute("unreadCount", unread);
%>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
        <span class="brand-icon">💍</span>
        <span>MarriageHall</span>
    </a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/HallServlet?action=list">Browse Halls</a></li>
        <c:choose>
            <c:when test="${navUser == null}">
                <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp" class="btn-nav">Register</a></li>
            </c:when>
            <c:when test="${navUser.role == 'ADMIN'}">
                <li><a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications">
                    🔔<c:if test="${unreadCount > 0}"><span class="nav-badge">${unreadCount}</span></c:if></a></li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-nav">Logout</a></li>
            </c:when>
            <c:when test="${navUser.role == 'OWNER'}">
                <li><a href="${pageContext.request.contextPath}/owner/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications">
                    🔔<c:if test="${unreadCount > 0}"><span class="nav-badge">${unreadCount}</span></c:if></a></li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-nav">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications">
                    🔔<c:if test="${unreadCount > 0}"><span class="nav-badge">${unreadCount}</span></c:if></a></li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-nav">Logout</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>
