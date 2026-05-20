<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    com.javaproject.marriagehallbookingsystem.model.User u =
            (com.javaproject.marriagehallbookingsystem.model.User) session.getAttribute("user");

    if (u == null || !"ADMIN".equals(u.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Load owners for dropdown
    com.javaproject.marriagehallbookingsystem.dao.UserDAO ud =
            new com.javaproject.marriagehallbookingsystem.dao.UserDAO();

    request.setAttribute("owners", ud.getUsersByRole("OWNER"));
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Add Hall - Admin</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>

        /* SEARCHABLE DROPDOWN */

        .owner-dropdown-wrapper {
            position: relative;
            width: 100%;
        }

        .owner-search-input {
            width: 100%;
        }

        .owner-dropdown-list {
            position: absolute;
            width: 100%;
            background: #fff;
            border: 1px solid #ddd;
            border-top: none;
            max-height: 220px;
            overflow-y: auto;
            z-index: 999;
            display: none;
            border-radius: 0 0 8px 8px;
        }

        .owner-dropdown-item {
            padding: 10px 12px;
            cursor: pointer;
            transition: 0.2s;
        }

        .owner-dropdown-item:hover {
            background: #f5f5f5;
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

                <div>
                    <h1>Add New Hall</h1>

                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/HallServlet?action=adminList">
                            Halls
                        </a>

                        <span>/</span>

                        Add New
                    </div>
                </div>

            </div>

            <div class="form-card form-card-wide">

                <form action="${pageContext.request.contextPath}/HallServlet"
                      method="post"
                      enctype="multipart/form-data">

                    <input type="hidden" name="action" value="add">

                    <!-- Hidden ownerId -->
                    <input type="hidden"
                           name="ownerId"
                           id="ownerId">

                    <div class="form-row">

                        <div class="form-group">

                            <label>Hall Name *</label>

                            <input type="text"
                                   name="hallName"
                                   required
                                   placeholder="e.g. Royal Garden Palace">

                        </div>

                        <!-- SEARCHABLE DROPDOWN -->
                        <div class="form-group">

                            <label>Hall Owner *</label>

                            <div class="owner-dropdown-wrapper">

                                <input type="text"
                                       id="ownerSearch"
                                       class="owner-search-input"
                                       placeholder="Search and select owner..."
                                       autocomplete="off"
                                       required>

                                <div class="owner-dropdown-list"
                                     id="ownerDropdown">

                                    <c:forEach var="o" items="${owners}">

                                        <div class="owner-dropdown-item"
                                             data-id="${o.userId}"
                                             data-name="${o.fullName} (${o.email})">

                                                ${o.fullName} (${o.email})

                                        </div>

                                    </c:forEach>

                                </div>

                            </div>

                        </div>

                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label>Full Address / Location *</label>

                            <input type="text"
                                   name="location"
                                   required
                                   placeholder="e.g. Baneshwor, Kathmandu">

                        </div>

                        <div class="form-group">

                            <label>City *</label>

                            <input type="text"
                                   name="city"
                                   required
                                   placeholder="e.g. Kathmandu">

                        </div>

                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label>Seating Capacity *</label>

                            <input type="number"
                                   name="seatingCapacity"
                                   required
                                   min="10"
                                   placeholder="e.g. 500">

                        </div>

                        <div class="form-group">

                            <label>Price Per Day (NPR) *</label>

                            <input type="number"
                                   name="pricePerDay"
                                   required
                                   min="1"
                                   step="0.01"
                                   placeholder="e.g. 75000">

                        </div>

                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label>Contact Number</label>

                            <input type="text"
                                   name="contactNumber"
                                   placeholder="e.g. 9800000001">

                        </div>

                        <div class="form-group">

                            <label>Status</label>

                            <select name="status">

                                <option value="AVAILABLE">
                                    Available
                                </option>

                                <option value="UNAVAILABLE">
                                    Unavailable
                                </option>

                            </select>

                        </div>

                    </div>

                    <div class="form-group">

                        <label>Facilities (comma-separated)</label>

                        <input type="text"
                               name="facilities"
                               placeholder="e.g. AC, Parking, Generator, Catering, Stage">

                    </div>

                    <div class="form-group">

                        <label>Hall Image</label>

                        <input type="file"
                               name="hallImage"
                               accept="image/*">

                    </div>

                    <div class="form-group">

                        <label>Description</label>

                        <textarea name="description"
                                  rows="4"
                                  placeholder="Describe the hall, its ambiance, and what makes it special..."></textarea>

                    </div>

                    <div class="form-actions">

                        <button type="submit"
                                class="btn btn-primary">

                            <i class="fa-solid fa-plus"
                               style="color: rgb(39, 49, 46);"></i>

                            Add Hall

                        </button>

                        <a href="${pageContext.request.contextPath}/HallServlet?action=adminList"
                           class="btn btn-outline">

                            Cancel

                        </a>

                    </div>

                </form>

            </div>

        </div>

    </div>

</div>

<script>

    const ownerSearch = document.getElementById("ownerSearch");
    const ownerDropdown = document.getElementById("ownerDropdown");
    const ownerItems = document.querySelectorAll(".owner-dropdown-item");
    const ownerId = document.getElementById("ownerId");

    // Show dropdown on focus
    ownerSearch.addEventListener("focus", () => {
        ownerDropdown.style.display = "block";
    });

    // Search functionality
    ownerSearch.addEventListener("keyup", () => {

        let filter = ownerSearch.value.toLowerCase();

        ownerItems.forEach(item => {

            let text = item.innerText.toLowerCase();

            if (text.includes(filter)) {
                item.style.display = "block";
            } else {
                item.style.display = "none";
            }

        });

    });

    // Select owner
    ownerItems.forEach(item => {

        item.addEventListener("click", () => {

            ownerSearch.value = item.dataset.name;

            ownerId.value = item.dataset.id;

            ownerDropdown.style.display = "none";

        });

    });

    // Hide dropdown when clicking outside
    document.addEventListener("click", (e) => {

        if (!e.target.closest(".owner-dropdown-wrapper")) {
            ownerDropdown.style.display = "none";
        }

    });

</script>

</body>
</html>