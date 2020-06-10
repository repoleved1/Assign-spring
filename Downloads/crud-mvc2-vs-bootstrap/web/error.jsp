<%--
  Created by IntelliJ IDEA.
  User: DuocNguyen
  Date: 6/10/2020
  Time: 2:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" language="java" %>
<html>
<head>
  <title>Error Page</title>
</head>
<style>
  body {
    font-family: 'Playfair Display', serif;
  }
</style>
<body>
  <h1>Error page</h1>
  <h2><%=exception.getMessage()%></h2>
</body>
</html>
