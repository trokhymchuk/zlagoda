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
    SELECT * from Store_product ORDER BY products_number, promotional_product ASC;
</sql:query>

<html>
<head>
    <title>Store product report</title>
    <style>
        td, th {
            border: 1px solid black;

        }
    </style>

</head>
<body>
<h1>STORE PRODUCT report of ZLAGODA</h1>
<hr>
<table style="width: 100%; text-align: center; border-collapse: collapse;">
    <tr>
        <th scope="col">#</th>
        <th scope="col">Product Name</th>
        <th scope="col">Price</th>
        <th scope="col">Products number</th>
        <th scope="col">Type</th>
    </tr>
    <c:forEach var="row" items="${result.rows}">
        <sql:query dataSource="${snapshot}" var="productName">
            SELECT product_name from Product WHERE id_product='${row.id_product}';
        </sql:query>

        <tr>
            <th scope="row"><c:out value="${row.UPC}"/></th>
            <td><c:out value="${productName.rows[0].product_name}"/></td>
            <td><c:out value="${row.selling_price}"/></td>
            <td><c:out value="${row.products_number}"/></td>

            <td>
                <c:choose>
                    <c:when test="${row.promotional_product}">
                        Promotional
                    </c:when>
                    <c:otherwise>
                        Regular
                    </c:otherwise>
                </c:choose>

            </td>
        </tr>
    </c:forEach>

</table>
<hr>
<h1>STORE PRODUCT report of ZLAGODA</h1>

<script>
    alert("Press CTRL+P to print!");
</script>
</body>
</html>
