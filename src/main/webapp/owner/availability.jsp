<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    com.gajur.marriagehallbookingsystem.model.User u = (com.gajur.marriagehallbookingsystem.model.User) session.getAttribute("user");
    if (u == null || !"OWNER".equals(u.getRole())) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Hall Availability - Owner</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="page-shell">
<jsp:include page="/WEB-INF/header.jsp"/>
<div class="dashboard-layout">
<jsp:include page="/WEB-INF/owner-sidebar.jsp"/>
<div class="main-content">
    <div class="page-header">
        <div>
            <h1>Manage Availability</h1>
            <div class="breadcrumb">${hall.hallName}</div>
        </div>
        <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList" class="btn btn-outline">← Back</a>
    </div>
    <c:if test="${not empty param.msg}"><div class="alert alert-success">✅ ${param.msg}</div></c:if>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">
        <!-- Block a Date -->
        <div class="form-card">
            <h3 style="color:var(--primary);margin-bottom:18px;">🚫 Block a Date</h3>
            <p style="color:var(--gray);font-size:0.88rem;margin-bottom:16px;">Block dates when your hall is unavailable (holidays, maintenance, private events).</p>
            <form action="${pageContext.request.contextPath}/HallServlet" method="post">
                <input type="hidden" name="action" value="blockDate">
                <input type="hidden" name="hallId" value="${hall.hallId}">
                <div class="form-group">
                    <label>Select Date *</label>
                    <input type="date" name="blockedDate" required
                           min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                </div>
                <div class="form-group">
                    <label>Reason (optional)</label>
                    <input type="text" name="reason" placeholder="e.g. Maintenance, Holiday, Private Event">
                </div>
                <button type="submit" class="btn btn-danger">🚫 Block Date</button>
            </form>
        </div>

        <!-- Blocked Dates List -->
        <div class="info-panel">
            <h3>📅 Currently Blocked Dates</h3>
            <c:choose>
                <c:when test="${empty blockedDates}">
                    <div class="empty-state" style="padding:30px 10px;">
                        <div class="empty-icon" style="font-size:2.5rem;">📅</div>
                        <p>No dates are currently blocked.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display:flex;flex-direction:column;gap:8px;">
                    <c:forEach var="d" items="${blockedDates}">
                        <div style="display:flex;justify-content:space-between;align-items:center;background:var(--light);padding:10px 14px;border-radius:8px;">
                            <span style="font-weight:600;">📅 <fmt:formatDate value="${d}" pattern="dd MMMM yyyy"/></span>
                            <form method="post" action="${pageContext.request.contextPath}/HallServlet" style="margin:0;">
                                <input type="hidden" name="action" value="unblockDate">
                                <input type="hidden" name="hallId" value="${hall.hallId}">
                                <input type="hidden" name="blockedDate" value="<fmt:formatDate value='${d}' pattern='yyyy-MM-dd'/>">
                                <button type="submit" class="btn btn-success btn-sm">Unblock</button>
                            </form>
                        </div>
                    </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</div>
</div>
</body></html>
