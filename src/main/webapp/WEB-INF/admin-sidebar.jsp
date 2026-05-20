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
            <span>Management</span>
        </div>
    </div>

    <%-- Logged User --%>
    <div class="sidebar-user">

        <div class="avatar">
            ${user.fullName.charAt(0)}
        </div>

        <div class="sidebar-user-info">
            <div class="user-name">
                ${user.fullName}
            </div>

            <div class="user-role">
                Administrator
            </div>
        </div>

    </div>

    <%-- Navigation --%>
    <ul class="sidebar-nav">

        <%-- Main --%>
        <li class="nav-section">Main</li>

        <li>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard"
               class="${currentPage == 'dashboard' ? 'active' : ''}">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <rect x="3" y="3" width="7" height="7" rx="1"/>
                        <rect x="14" y="3" width="7" height="7" rx="1"/>
                        <rect x="3" y="14" width="7" height="7" rx="1"/>
                        <rect x="14" y="14" width="7" height="7" rx="1"/>

                    </svg>
                </span>

                Dashboard
            </a>
        </li>


        <%-- Halls --%>
        <li class="nav-section">Halls</li>

        <li>
            <a href="${pageContext.request.contextPath}/HallServlet?action=adminList"
               class="${currentPage == 'halls' ? 'active' : ''}">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <path d="M3 21h18"/>
                        <path d="M5 21V7l7-4 7 4v14"/>
                        <path d="M9 21v-4h6v4"/>

                    </svg>
                </span>

                All Halls
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/HallServlet?action=addForm">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <circle cx="12" cy="12" r="9"/>
                        <path d="M12 8v8"/>
                        <path d="M8 12h8"/>

                    </svg>
                </span>

                Add Hall
            </a>
        </li>


        <%-- Bookings --%>
        <li class="nav-section">Bookings</li>

        <li>
            <a href="${pageContext.request.contextPath}/BookingServlet?action=adminList"
               class="${currentPage == 'bookings' ? 'active' : ''}">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <rect x="3" y="4" width="18" height="18" rx="2"/>
                        <path d="M16 2v4"/>
                        <path d="M8 2v4"/>
                        <path d="M3 10h18"/>

                    </svg>
                </span>

                All Bookings
            </a>
        </li>


        <%-- Users --%>
        <li class="nav-section">Users</li>

        <li>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=users"
               class="${currentPage == 'users' ? 'active' : ''}">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>

                    </svg>
                </span>

                Users
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=addUserForm"
               class="${currentPage == 'addUser' ? 'active' : ''}">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <circle cx="12" cy="12" r="9"/>
                        <path d="M12 8v8"/>
                        <path d="M8 12h8"/>

                    </svg>
                </span>

                Add User
            </a>
        </li>


        <%-- Account --%>
        <li class="nav-section">Account</li>

        <li>
            <a href="${pageContext.request.contextPath}/ProfileServlet?action=view">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>

                    </svg>
                </span>

                My Profile
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/ProfileServlet?action=notifications">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"/>

                    </svg>
                </span>

                Notifications
            </a>
        </li>


        <%-- Logout --%>
        <li class="nav-logout">

            <a href="${pageContext.request.contextPath}/LogoutServlet">

                <span class="nav-icon">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                        <polyline points="16 17 21 12 16 7"/>
                        <line x1="21" y1="12" x2="9" y2="12"/>

                    </svg>
                </span>

                Logout
            </a>

        </li>

    </ul>

</aside>