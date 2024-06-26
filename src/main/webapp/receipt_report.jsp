<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>




<c:if test="${cookie['role'] == null || !cookie['role'].getValue().equals('Manager')}">
    <%
        String redirectURLMainPage = "http://localhost:8080/index.jsp";
        response.sendRedirect(redirectURLMainPage);
    %>
</c:if>





<jsp:include page="DB.jsp"/>
<%
    String potsgres_username = (String) request.getAttribute("potsgres_username");
    String postgres_password = (String) request.getAttribute("postgres_password");

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    SELECT * from checktable INNER JOIN Employee ON checktable.id_employee=Employee.id_employee LEFT JOIN Customer_card ON checktable.card_number=Customer_card.card_number;
</sql:query>


<html>
<head>
    <title>Receipt report</title>
    <style>
        td, th {
            border: 1px solid black;

        }
    </style>

</head>
<body>
<h1>RECEIPT report of ZLAGODA</h1>
<hr>
<table style="width: 100%; text-align: center; border-collapse: collapse;">
    <thead>
    <tr>
        <th scope="col">#</th>
        <th scope="col">Employee</th>
        <th scope="col">Customer</th>
        <th scope="col">Date</th>
        <th scope="col" style="width: 300px;"> Products</th>
        <th scope="col">Sum</th>
        <th scope="col">VAT</th>
    </tr>
    <c:forEach var="row" items="${result.rows}">
        <tr>
            <th scope="row">${row.check_number}</th>
            <td>${row.empl_name} ${row.empl_surname}</td>
            <td>${(row.cust_name != null) ? row.cust_name : ""} ${(row.cust_surname != null) ? row.cust_surname : ""}</td>
            <td>${row.print_date}</td>
            <td style="width: 300px;">
                <sql:query dataSource="${snapshot}" var="products">
                    SELECT * FROM Sale INNER JOIN Store_product ON Sale.UPC=Store_product.UPC INNER JOIN Product ON Store_product.id_product=Product.id_product WHERE check_number='${row.check_number}';
                </sql:query>

                    <c:forEach var="product" items="${products.rows}">
                        ${product.product_name}  ${product.selling_price}$ x ${product.product_number} <br>

                    </c:forEach>



            </td>
            <td>${row.sum_total}</td>
            <td>${row.vat}</td>
        </tr>
    </c:forEach>

    </thead>
    <tbody id="recieptsTbody">
    </tbody>

</table>
<hr>
<h1>RECEIPT report of ZLAGODA</h1>

<script>
    alert("Press CTRL+P to print!");
    </script>
</body>
</html>
