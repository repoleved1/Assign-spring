<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: DuocNguyen
  Date: 6/10/2020
  Time: 2:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>User Management Application</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500&display=swap" rel="stylesheet">
</head>
<style>
  body {
    font-family: 'Playfair Display', serif;
  }
</style>
<body>
  <header>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand">User Manager App</a>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active">
            <a class="nav-link"  href="<%=request.getContextPath()%>/">Users</a>
          </li>
        </ul>
      </div>
    </nav>
  </header>
  <div class="container col-md-5">
    <div class="card" style="margin-top: 25px">
      <div class="card-body">
        <c:if test="${user != null}">
        <form action="update" method="post">
          </c:if>
          <c:if test="${user == null}">
          <form action="insert" method="post">
            </c:if>
            <h2>
              <c:if test="${user != null}">Edit User</c:if>
              <c:if test="${user == null}">Add New User</c:if>
            </h2>
            <c:if test="${user != null}">
              <input type="hidden" name="id" value="<c:out value="${user.id}"/>" required="required">
            </c:if>
            <div class="form-group">
              <label for="name">Name</label>
              <input type="text" class="form-control" id="name" name="name" value="<c:out value="${user.name}"/>" placeholder="Enter name user" required="required">
            </div>
            <div class="form-group">
              <label for="email">Email</label>
              <input type="email" class="form-control" id="email" name="email" value="<c:out value="${user.email}"/>" placeholder="Enter email"  required="required">
            </div>
            <div class="form-group">
              <label for="country">Country</label>
              <input type="text" class="form-control" id="country" name="country" value="<c:out value="${user.country}"/>" placeholder="Enter country"  required="required">
            </div>
            <button type="submit" class="btn btn-primary">Add</button>
          </form>
      </div>
    </div>
  </div>
</body>
</html>
