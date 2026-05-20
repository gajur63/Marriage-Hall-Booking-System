<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    com.javaproject.marriagehallbookingsystem.model.User u =
            (com.javaproject.marriagehallbookingsystem.model.User)
                    session.getAttribute("user");

    if (u == null || !"OWNER".equals(u.getRole())) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Edit Hall - Owner</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<div class="page-shell">

    <jsp:include page="/WEB-INF/header.jsp"/>

    <div class="dashboard-layout">

        <jsp:include page="/WEB-INF/owner-sidebar.jsp"/>

        <div class="main-content">

            <div class="page-header">

                <h1>Edit Hall: ${hall.hallName}</h1>

                <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList"
                   class="btn btn-outline">

                    ← Back

                </a>

            </div>

            <div class="form-card form-card-wide">

                <form action="${pageContext.request.contextPath}/HallServlet"
                      method="post"
                      enctype="multipart/form-data">

                    <input type="hidden"
                           name="action"
                           value="update">

                    <input type="hidden"
                           name="hallId"
                           value="${hall.hallId}">

                    <!-- keep existing image -->
                    <input type="hidden"
                           name="existingImage"
                           value="${hall.imageUrl}">


                    <div class="form-row">

                        <div class="form-group">

                            <label>Hall Name *</label>

                            <input type="text"
                                   name="hallName"
                                   value="${hall.hallName}"
                                   required>

                        </div>

                        <div class="form-group">

                            <label>City *</label>

                            <input type="text"
                                   name="city"
                                   value="${hall.city}"
                                   required>

                        </div>

                    </div>


                    <div class="form-group">

                        <label>Full Address *</label>

                        <input type="text"
                               name="location"
                               value="${hall.location}"
                               required>

                    </div>


                    <div class="form-row">

                        <div class="form-group">

                            <label>Seating Capacity *</label>

                            <input type="number"
                                   name="seatingCapacity"
                                   value="${hall.seatingCapacity}"
                                   required
                                   min="10">

                        </div>

                        <div class="form-group">

                            <label>Price Per Day (NPR) *</label>

                            <input type="number"
                                   name="pricePerDay"
                                   value="${hall.pricePerDay}"
                                   required
                                   step="0.01">

                        </div>

                    </div>


                    <div class="form-row">

                        <div class="form-group">

                            <label>Contact Number</label>

                            <input type="text"
                                   name="contactNumber"
                                   value="${hall.contactNumber}">

                        </div>

                        <div class="form-group">

                            <label>Status</label>

                            <select name="status">

                                <option value="AVAILABLE"
                                ${hall.status=='AVAILABLE'?'selected':''}>
                                    Available
                                </option>

                                <option value="UNAVAILABLE"
                                ${hall.status=='UNAVAILABLE'?'selected':''}>
                                    Unavailable
                                </option>

                            </select>

                        </div>

                    </div>


                    <div class="form-group">

                        <label>Facilities</label>

                        <input type="text"
                               name="facilities"
                               value="${hall.facilities}">

                    </div>


                    <!-- IMAGE SECTION -->

                    <div class="form-group">

                        <label>Current Hall Image</label>

                        <c:if test="${not empty hall.imageUrl}">

                            <div style="margin-bottom:15px;">

                                <img src="${pageContext.request.contextPath}/${hall.imageUrl}"
                                     alt="Hall Image"
                                     width="220"
                                     style="border-radius:10px;
                                            border:1px solid #ddd;
                                            padding:5px;">

                            </div>

                        </c:if>


                        <label>Upload New Image</label>

                        <input type="file"
                               name="hallImage"
                               accept="image/*">

                        <small style="display:block;
                                      margin-top:6px;
                                      color:gray;">

                            Leave empty if you want to keep the current image

                        </small>

                    </div>


                    <div class="form-group">

                        <label>Description</label>

                        <textarea name="description"
                                  rows="4">${hall.description}</textarea>

                    </div>


                    <div class="form-actions">

                        <button type="submit"
                                class="btn btn-primary">

                            <i class="fa-solid fa-floppy-disk"></i>

                            Save Changes

                        </button>

                        <a href="${pageContext.request.contextPath}/HallServlet?action=ownerList"
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