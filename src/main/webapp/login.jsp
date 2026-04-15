<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- Redirect if already logged in --%>
<%
    if (session.getAttribute("user") != null) {
        com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
        if ("ADMIN".equals(u.getRole())) response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        else if ("OWNER".equals(u.getRole())) response.sendRedirect(request.getContextPath() + "/owner/dashboard.jsp");
        else response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Marriage Hall Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <div class="auth-logo">
            <div class="logo-icon">💍</div>
            <h2>Welcome Back</h2>
            <p>Sign in to your account</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">⚠️ ${param.error}</div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">✅ ${param.success}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="you@example.com" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn btn-primary w-100 btn-lg">Sign In</button>
        </form>

        <div class="auth-footer">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a></p>
            <p style="margin-top:10px;"><a href="${pageContext.request.contextPath}/index.jsp">← Back to Home</a></p>
        </div>

        <div style="margin-top:20px;padding:15px;background:var(--accent);border-radius:8px;font-size:0.82rem;">
            <strong>Demo Credentials:</strong><br>
            Admin: admin@marriagehall.com / admin123<br>
            Owner: rajesh@owner.com / owner123<br>
            Customer: amit@customer.com / customer123
        </div>
    </div>
</div>
</body>
</html>
