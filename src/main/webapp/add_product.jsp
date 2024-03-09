<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<html>
<head>
    <title>SELECT Operation</title>
</head>

<body>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="postgres" password="admin"/>

<sql:query dataSource="${snapshot}" var="categories">
    SELECT * from Category;
</sql:query>

<%--<sql:query dataSource = "${snapshot}" var = "product_category">--%>
<%--    SELECT * from Category WHERE category_number=${result.};--%>
<%--</sql:query>--%>

<form method="GET" action="/product">
    <span> Name: </span>
    <input name="name" type="text">
    <br>
    <span> Characteristics: </span>
    <input name="characteristics" type="text">
    <br>
    <span>Category: </span>
    <select name="category">
        <c:forEach var="row" items="${categories.rows}">
            <option value="${row.category_number}">${row.category_name}</option>
        </c:forEach>
    </select>
    <input type="hidden" name="action" value="add">
    <button type="submit">Submit</button>
</form>

</body>
</html>