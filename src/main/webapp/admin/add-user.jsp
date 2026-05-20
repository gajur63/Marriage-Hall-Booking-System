<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    com.javaproject.marriagehallbookingsystem.model.User u =
            (com.javaproject.marriagehallbookingsystem.model.User)
                    session.getAttribute("user");

    if (u == null || !"ADMIN".equals(u.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Add User - Admin</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<jsp:include page="/WEB-INF/header.jsp"/>

<div class="page-shell">

    <div class="dashboard-layout">

        <jsp:include page="/WEB-INF/admin-sidebar.jsp"/>

        <div class="main-content">

            <div class="page-header">

                <h1>Add User</h1>

                <a href="${pageContext.request.contextPath}/AdminServlet?action=users"
                   class="btn btn-outline">

                    ← Back

                </a>

            </div>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">

                    <i class="fa-solid fa-triangle-exclamation" style="color: rgb(0, 0, 0);"></i>
                ${param.error}

                </div>
            </c:if>

            <c:if test="${not empty param.msg}">
                <div class="alert alert-success">

                    <i class="fa-solid fa-circle-check"></i> ${param.msg}

                </div>
            </c:if>

            <div class="form-card">

                <form action="${pageContext.request.contextPath}/AdminServlet"
                      method="post">

                    <input type="hidden"
                           name="action"
                           value="addUser">

                    <div class="form-group">

                        <label>Full Name *</label>

                        <input type="text"
                               name="fullName"
                               required
                               placeholder="Enter full name">

                    </div>

                    <div class="form-group">

                        <label>Email Address *</label>

                        <input type="email"
                               name="email"
                               required
                               placeholder="example@gmail.com">

                    </div>

                    <div class="form-group">

                        <label>Password *</label>

                        <input type="password"
                               name="password"
                               required
                               minlength="6"
                               placeholder="Minimum 6 characters">

                    </div>

                    <div class="form-group">

                        <label>Phone Number</label>

                        <input type="tel"
                               name="phone"
                               placeholder="98XXXXXXXX">

                    </div>

                    <div class="form-group">

                        <label>Address</label>

                        <input type="text"
                               name="address"
                               placeholder="Enter address">

                    </div>

                    <div class="form-group">

                        <label>User Role *</label>

                        <select name="role" required>

                            <option value="">Select Role</option>

                            <option value="ADMIN">ADMIN</option>

                            <option value="OWNER">OWNER</option>

                            <option value="CUSTOMER">CUSTOMER</option>

                        </select>

                    </div>

                    <div class="form-actions">

                        <button type="submit"
                                class="btn btn-primary">

                            <i class="fa-solid fa-user-plus"
                               style="color:black;"></i>

                            Add User

                        </button>

                        <a href="${pageContext.request.contextPath}/AdminServlet?action=users"
                           class="btn btn-outline">

                            Cancel

                        </a>

                    </div>

                </form>

            </div>

        </div>

    </div>

</div>

</body>

</html>