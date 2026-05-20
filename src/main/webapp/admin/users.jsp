<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    com.javaproject.marriagehallbookingsystem.model.User u =
            (com.javaproject.marriagehallbookingsystem.model.User)
                    session.getAttribute("user");

    if (u == null || !"ADMIN".equals(u.getRole())) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );

        return;
    }

    String pt = (String) request.getAttribute("pageTitle");

    if (pt == null) {
        pt = "All Users";
    }

    String currentPage = "users";

    if (pt.equalsIgnoreCase("Customers")) {

        currentPage = "customers";

    } else if (pt.equalsIgnoreCase("Hall Owners")) {

        currentPage = "owners";

    } else if (pt.equalsIgnoreCase("Admins")) {

        currentPage = "admins";
    }

    request.setAttribute("currentPage", currentPage);
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>
        ${pageTitle != null ? pageTitle : 'All Users'} - Admin
    </title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>

        .toolbar{
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:20px;
            margin-bottom:24px;
            flex-wrap:wrap;
        }

        .filter-group{
            display:flex;
            align-items:center;
            gap:12px;
            flex-wrap:wrap;
        }

        .filter-tab{
            padding:10px 18px;
            border-radius:10px;
            text-decoration:none;
            font-weight:600;
            font-size:14px;
            color:#475569;
            background:#f8fafc;
            border:1px solid #e2e8f0;
            transition:all .2s ease;
        }

        .filter-tab:hover{
            background:#f1f5f9;
            border-color:#cbd5e1;
        }

        .filter-tab.active{
            background:#111827;
            color:#fff;
            border-color:#111827;
            box-shadow:0 4px 12px rgba(15,23,42,.12);
        }

        .filter-tab.customers.active{
            background:#0891b2;
            border-color:#0891b2;
        }

        .filter-tab.owners.active{
            background:#ea580c;
            border-color:#ea580c;
        }

        .filter-tab.admins.active{
            background:#7c3aed;
            border-color:#7c3aed;
        }

        .filter-indicator{
            display:flex;
            align-items:center;
            justify-content:space-between;
            margin-bottom:20px;
            padding:14px 18px;
            border:1px solid #e2e8f0;
            border-radius:14px;
            background:#ffffff;
        }

        .filter-indicator-title{
            font-size:14px;
            color:#64748b;
            margin-bottom:4px;
        }

        .filter-indicator-value{
            font-size:17px;
            font-weight:700;
            color:#0f172a;
        }

        .filter-count{
            background:#f1f5f9;
            color:#0f172a;
            padding:8px 14px;
            border-radius:999px;
            font-size:13px;
            font-weight:700;
        }

        .table-card{
            background:#fff;
            border-radius:16px;
            overflow:hidden;
            border:1px solid #e2e8f0;
            box-shadow:0 2px 10px rgba(15,23,42,.04);
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        thead{
            background:#f8fafc;
        }

        thead th{
            padding:16px;
            text-align:left;
            font-size:13px;
            font-weight:700;
            color:#475569;
            border-bottom:1px solid #e2e8f0;
        }

        tbody td{
            padding:16px;
            border-bottom:1px solid #f1f5f9;
            vertical-align:middle;
        }

        tbody tr:hover{
            background:#fafafa;
        }

        .user-name{
            font-weight:600;
            color:#0f172a;
        }

        .role-badge{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            font-weight:700;
        }

        .role-admin{
            background:#ede9fe;
            color:#6d28d9;
        }

        .role-owner{
            background:#ffedd5;
            color:#c2410c;
        }

        .role-customer{
            background:#dbeafe;
            color:#1d4ed8;
        }

        .status-badge{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            font-weight:700;
        }

        .status-active{
            background:#dcfce7;
            color:#15803d;
        }

        .status-inactive{
            background:#fee2e2;
            color:#b91c1c;
        }

        .action-buttons{
            display:flex;
            gap:8px;
            flex-wrap:wrap;
        }

    </style>

</head>

<body>

<jsp:include page="/WEB-INF/header.jsp"/>

<div class="page-shell">

    <div class="dashboard-layout">

        <jsp:include page="/WEB-INF/admin-sidebar.jsp"/>

        <div class="main-content">

            <div class="page-header">

                <h1>
                    ${not empty pageTitle ? pageTitle : 'All Users'}
                </h1>

            </div>


            <!-- FILTER STATUS -->
            <div class="filter-indicator">

                <div>

                    <div class="filter-indicator-title">
                        Currently Viewing
                    </div>

                    <div class="filter-indicator-value">
                        ${not empty pageTitle ? pageTitle : 'All Users'}
                    </div>

                </div>

                <div class="filter-count">

                    ${fn:length(users)} Users

                </div>

            </div>


            <!-- TOOLBAR -->
            <div class="toolbar">

                <div class="filter-group">

                    <a href="${pageContext.request.contextPath}/AdminServlet?action=users"
                       class="filter-tab ${currentPage == 'users' ? 'active' : ''}">

                        All Users

                    </a>

                    <a href="${pageContext.request.contextPath}/AdminServlet?action=customers"
                       class="filter-tab customers ${currentPage == 'customers' ? 'active' : ''}">

                        Customers

                    </a>

                    <a href="${pageContext.request.contextPath}/AdminServlet?action=owners"
                       class="filter-tab owners ${currentPage == 'owners' ? 'active' : ''}">

                        Hall Owners

                    </a>

                    <a href="${pageContext.request.contextPath}/AdminServlet?action=admins"
                       class="filter-tab admins ${currentPage == 'admins' ? 'active' : ''}">

                        Admins

                    </a>

                </div>


                <div>

                    <a href="${pageContext.request.contextPath}/AdminServlet?action=addUserForm"
                       class="btn btn-primary">

                        Add User

                    </a>

                </div>

            </div>


            <!-- SUCCESS MESSAGE -->
            <c:if test="${not empty param.msg}">

                <div class="alert alert-success">

                        ${param.msg}

                </div>

            </c:if>


            <!-- USERS TABLE -->
            <div class="table-card">

                <table>

                    <thead>

                    <tr>

                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Joined</th>
                        <th>Actions</th>

                    </tr>

                    </thead>

                    <tbody>

                    <c:forEach var="usr" items="${users}">

                        <tr>

                            <td>#${usr.userId}</td>

                            <td>

                                <div class="user-name">
                                        ${usr.fullName}
                                </div>

                            </td>

                            <td>${usr.email}</td>

                            <td>${usr.phone}</td>

                            <td>

                                <span class="role-badge role-${fn:toLowerCase(usr.role)}">

                                        ${usr.role}

                                </span>

                            </td>

                            <td>

                                <span class="status-badge status-${fn:toLowerCase(usr.status)}">

                                        ${usr.status}

                                </span>

                            </td>

                            <td>

                                <fmt:formatDate
                                        value="${usr.createdAt}"
                                        pattern="dd MMM yyyy"/>

                            </td>

                            <td>

                                <div class="action-buttons">

                                    <c:choose>

                                        <c:when test="${usr.status == 'ACTIVE'}">

                                            <a href="${pageContext.request.contextPath}/AdminServlet?action=toggleUserStatus&id=${usr.userId}&status=INACTIVE"
                                               class="btn btn-warning btn-sm">

                                                Deactivate

                                            </a>

                                        </c:when>

                                        <c:otherwise>

                                            <a href="${pageContext.request.contextPath}/AdminServlet?action=toggleUserStatus&id=${usr.userId}&status=ACTIVE"
                                               class="btn btn-success btn-sm">

                                                Activate

                                            </a>

                                        </c:otherwise>

                                    </c:choose>


                                    <c:if test="${usr.role != 'ADMIN'}">

                                        <a href="${pageContext.request.contextPath}/AdminServlet?action=deleteUser&id=${usr.userId}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Delete user ${usr.fullName}?')">

                                            Delete

                                        </a>

                                    </c:if>

                                </div>

                            </td>

                        </tr>

                    </c:forEach>


                    <c:if test="${empty users}">

                        <tr>

                            <td colspan="8"
                                style="text-align:center;
                                       padding:40px;
                                       color:#64748b;">

                                No users found

                            </td>

                        </tr>

                    </c:if>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

</body>
</html>