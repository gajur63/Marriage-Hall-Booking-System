<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<aside class="sidebar">

    <%-- Brand --%>
    <div class="sidebar-brand">
        <div class="sidebar-brand-mark">
            <svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
                <path d="M8 2L10 6H14L11 9L12 13L8 10.5L4 13L5 9L2 6H6L8 2Z"/>
            </svg>
        </div>
        <div class="sidebar-brand-text">
            <strong>WeddingHall</strong>
            Management
        </div>
    </div>

    <%-- User --%>
    <div class="sidebar-user">
        <div class="avatar">${user.fullName.charAt(0)}</div>
        <div class="sidebar-user-info">
            <div class="user-name">${user.fullName}</div>
            <div class="user-role">Administrator</div>
        </div>
    </div>

    <%-- Navigation --%>
    <ul class="sidebar-nav">

        <li class="nav-section">Main</li>
        <li>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard"
               class="<c:if test="${currentPage=='dashboard'}">active</c:if>">
                <span class="nav-icon" data-icon="dashboard"></span>
                Dashboard
            </a>
        </li>

        <li class="nav-section">Halls</li>
        <li>
            <a href="${pageContext.request.contextPath}/HallServlet?action=adminList"
               class="<c:if test="${currentPage=='halls'}">active</c:if>">
                <span class="nav-icon" data-icon="halls"></span>
                All Halls
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/HallServlet?action=addForm">
                <span class="nav-icon" data-icon="add"></span>
                Add Hall
            </a>
        </li>

        <li class="nav-section">Bookings</li>
        <li>
            <a href="${pageContext.request.contextPath}/BookingServlet?action=adminList"
               class="<c:if test="${currentPage=='bookings'}">active</c:if>">
                <span class="nav-icon" data-icon="bookings"></span>
                All Bookings
            </a>
        </li>

        <li class="nav-section">Users</li>
        <li>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=customers"
               class="<c:if test="${currentPage=='customers'}">active</c:if>">
                <span class="nav-icon" data-icon="customers"></span>
                Customers
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=owners"
               class="<c:if test="${currentPage=='owners'}">active</c:if>">
                <span class="nav-icon" data-icon="owners"></span>
                Hall Owners
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=addOwnerForm">
                <span class="nav-icon" data-icon="add"></span>
                Add Owner
            </a>
        </li>

        <li class="nav-section">Account</li>
        <li>
            <a href="${pageContext.request.contextPath}/ProfileServlet?action=view">
                <span class="nav-icon" data-icon="profile"></span>
                My Profile
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications">
                <span class="nav-icon" data-icon="notifications"></span>
                Notifications
            </a>
        </li>
        <li class="nav-logout">
            <a href="${pageContext.request.contextPath}/LogoutServlet">
                <span class="nav-icon" data-icon="logout"></span>
                Logout
            </a>
        </li>

    </ul>
</aside>
