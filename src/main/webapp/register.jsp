<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Marriage Hall Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-page" style="padding:40px 20px;">
    <div class="auth-card" style="max-width:520px;">
        <div class="auth-logo">
            <div class="logo-icon">💍</div>
            <h2>Create Account</h2>
            <p>Join us to book your dream venue</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">⚠️ ${param.error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name *</label>
                    <input type="text" name="fullName" placeholder="Your full name" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" name="phone" placeholder="98XXXXXXXX">
                </div>
            </div>
            <div class="form-group">
                <label>Email Address *</label>
                <input type="email" name="email" placeholder="you@example.com" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Password *</label>
                    <input type="password" name="password" placeholder="Min. 6 characters" required minlength="6">
                </div>
                <div class="form-group">
                    <label>Confirm Password *</label>
                    <input type="password" name="confirmPassword" placeholder="Repeat password" required>
                </div>
            </div>
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="address" placeholder="Your city / address">
            </div>
            <div class="form-group">
                <label>Register As *</label>
                <select name="role">
                    <option value="CUSTOMER">Customer (Book Halls)</option>
                    <option value="OWNER">Hall Owner (List My Halls)</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100 btn-lg">Create Account</button>
        </form>

        <div class="auth-footer">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a></p>
            <p style="margin-top:8px;"><a href="${pageContext.request.contextPath}/index.jsp">← Back to Home</a></p>
        </div>
    </div>
</div>
</body>
</html>
