<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>404 - Page Not Found</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(--light);">
<div style="text-align:center;padding:40px;">
    <div style="font-size:5rem;"><i class="fa-solid fa-face-frown"></i></div>
    <h1 style="font-size:3rem;color:var(--primary);margin:10px 0 8px;">404</h1>
    <p style="color:var(--gray);font-size:1.1rem;margin-bottom:24px;">Oops! The page you're looking for doesn't exist.</p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">← Back to Home</a>
</div>
</body></html>
