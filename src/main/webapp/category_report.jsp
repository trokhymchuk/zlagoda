<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>
<jsp:include page="DB.jsp"/>
<%
    String potsgres_username = (String) request.getAttribute("potsgres_username");
    String postgres_password = (String) request.getAttribute("postgres_password");

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    SELECT * from Category ORDER BY category_name;
</sql:query>

<html>
<head>
    <title>Category report</title>
    <style>
        td, th {
            border: 1px solid black;

        }
    </style>

</head>
<body>
<h1>CATEGORY report of ZLAGODA</h1>
<hr>
<table style="width: 100%; text-align: center; border-collapse: collapse;">
    <tr>
        <th scope="col">#</th>
        <th scope="col">Category name</th>
    </tr>
    <c:forEach var="row" items="${result.rows}">
        <tr>
            <th scope="row"><c:out value="${row.category_number}"/></th>
            <td><c:out value="${row.category_name}"/></td>
        </tr>
    </c:forEach>

</table>
<hr>
<h1>CATEGORY report of ZLAGODA</h1>

<script>
    alert("Press CTRL+P to print!");
    </script>
</body>
</html>
