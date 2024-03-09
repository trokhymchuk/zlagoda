<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>

<html>
<head>
    <title>SELECT Operation</title>
</head>

<body>
<sql:setDataSource var = "snapshot" driver = "org.postgresql.Driver"
                   url = "jdbc:postgresql://127.0.0.1:5432/ais"
                   user = "postgres"  password = "admin"/>

<sql:query dataSource = "${snapshot}" var = "result">
    SELECT * from Product;
</sql:query>

<table border = "1" width = "100%">
    <tr>
        <th>ID product</th>
        <th>Name</th>
        <th>Characteristics</th>
        <th>Edit</th>
        <th>Delete</th>

    </tr>

    <c:forEach var = "row" items = "${result.rows}">
        <tr>
            <td><c:out value = "${row.id_product}"/></td>
            <td><c:out value = "${row.product_name}"/></td>
            <td><c:out value = "${row.characteristics}"/></td>
            <td><a href="edit_product.jsp?id=${row.id_product}">edit</a></td>
            <td><a href="/product?id=${row.id_product}&action=delete">delete</a></td>
        </tr>
    </c:forEach>
</table>

</body>
</html>