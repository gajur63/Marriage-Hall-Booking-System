<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Access Denied</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(--light);">
<div style="text-align:center;padding:40px;">
    <div style="font-size:5rem;">🚫</div>
    <h1 style="font-size:2rem;color:var(--primary);margin:16px 0 8px;">Access Denied</h1>
    <p style="color:var(--gray);margin-bottom:24px;">You don't have permission to view this page.</p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">← Go Home</a>
</div>
</body></html>
