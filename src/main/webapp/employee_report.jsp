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
    SELECT * from Employee ORDER BY empl_surname;
</sql:query>

<html>
<head>
    <title>Employee report</title>
    <style>
        td, th {
            border: 1px solid black;

        }
    </style>

</head>
<body>
<h1>EMPLOYEE report of ZLAGODA</h1>
<hr>
<table style="width: 100%; text-align: center; border-collapse: collapse;">
    <tr>
        <th scope="col">#</th>
        <th scope="col">Surname</th>
        <th scope="col">Name</th>
        <th scope="col">Patronymic</th>
        <th scope="col">Role</th>
        <th scope="col">Salary</th>
        <th scope="col">Date of birth</th>
        <th scope="col">Date of start</th>
        <th scope="col">Phone number</th>
        <th scope="col">City</th>
        <th scope="col">Street</th>
        <th scope="col">Zip code</th>
    </tr>
    <c:forEach var="row" items="${result.rows}">
        <tr>
            <th scope="row"><c:out value="${row.id_employee}"/></th>
            <td><c:out value="${row.empl_surname}"/></td>
            <td><c:out value="${row.empl_name}"/></td>
            <td><c:out value="${row.empl_patronymic}"/></td>
            <td><c:out value="${row.empl_role}"/></td>
            <td><c:out value="${row.salary}"/></td>
            <td><c:out value="${row.date_of_birth}"/></td>
            <td><c:out value="${row.date_of_start}"/></td>
            <td><c:out value="${row.phone_number}"/></td>
            <td><c:out value="${row.city}"/></td>
            <td><c:out value="${row.street}"/></td>
            <td><c:out value="${row.zip_code}"/></td>
        </tr>
    </c:forEach>

</table>
<hr>
<h1>EMPLOYEE report of ZLAGODA</h1>

<script>
    alert("Press CTRL+P to print!");
    </script>
</body>
</html>
