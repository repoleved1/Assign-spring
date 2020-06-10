<%--
  Created by IntelliJ IDEA.
  User: DuocNguyen
  Date: 6/10/2020
  Time: 2:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>List User</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
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
  <div class="container">
    <div style="text-align: center">
      <h2>List of Users</h2>
    </div>
    <div style="margin: 15px 0">
      <a class="btn btn-success" href="<%=request.getContextPath()%>/new">Add New User</a>
    </div>
    <table class="table">
      <thead>
      <tr>
        <th scope="col">ID</th>
        <th scope="col">Name</th>
        <th scope="col">Email</th>
        <th scope="col">Country</th>
        <th scope="col">Actions</th>
      </tr>
      </thead>
      <tbody>
        <c:forEach var="user" items="${listUser}">
          <tr>
            <th scope="row"><c:out value="${user.id}" /></th>
            <td><c:out value="${user.name}" /></td>
            <td><c:out value="${user.email}" /></td>
            <td><c:out value="${user.country}" /></td>
            <td>
              <a href="edit?id=<c:out value="${user.id}" />">Edit</a>
              <a href="delete?id=<c:out value="${user.id}" />">Delete</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</body>
</html>
