<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    com.javaproject.marriagehallbookingsystem.model.User navUser = (com.javaproject.marriagehallbookingsystem.model.User) session.getAttribute("user");
    int unread = 0;
    if (navUser != null) {
        com.javaproject.marriagehallbookingsystem.dao.NotificationDAO nd = new com.javaproject.marriagehallbookingsystem.dao.NotificationDAO();
        unread = nd.countUnread(navUser.getUserId());
    }
    request.setAttribute("navUser", navUser);
    request.setAttribute("unreadCount", unread);
%>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
        <div class="brand-ring">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
            </svg>
        </div>
        <span class="brand-name">Wedding<span>Hall</span></span>
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
                <li>
                    <a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications" class="nav-bell-link">
                        <span class="nav-bell">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                                <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                            </svg>
                            <c:if test="${unreadCount > 0}">
                                <span class="nav-badge"></span>
                            </c:if>
                        </span>
                    </a>
                </li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-nav">Logout</a></li>
            </c:when>

            <c:when test="${navUser.role == 'OWNER'}">
                <li><a href="${pageContext.request.contextPath}/owner/dashboard.jsp">Dashboard</a></li>
                <li>
                    <a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications" class="nav-bell-link">
                        <span class="nav-bell">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                                <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                            </svg>
                            <c:if test="${unreadCount > 0}">
                                <span class="nav-badge"></span>
                            </c:if>
                        </span>
                    </a>
                </li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-nav">Logout</a></li>
            </c:when>

            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a></li>
                <li>
                    <a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications" class="nav-bell-link">
                        <span class="nav-bell">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                                <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                            </svg>
                            <c:if test="${unreadCount > 0}">
                                <span class="nav-badge"></span>
                            </c:if>
                        </span>
                    </a>
                </li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-nav">Logout</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>
