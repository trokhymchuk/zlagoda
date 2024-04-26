<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<jsp:include page="header.jsp"/>
<jsp:include page="DB.jsp"/>
<%
    String potsgres_username = (String) request.getAttribute("potsgres_username");
    String postgres_password = (String) request.getAttribute("postgres_password");
    String check_number = (String) request.getParameter("id");

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    SELECT * from checktable INNER JOIN Employee ON checktable.id_employee=Employee.id_employee LEFT JOIN Customer_card ON checktable.card_number=Customer_card.card_number WHERE check_number='<%=check_number%>';
</sql:query>
<sql:query dataSource="${snapshot}" var="products">
    SELECT * FROM Sale INNER JOIN Store_product ON Sale.UPC=Store_product.UPC INNER JOIN Product ON Store_product.id_product=Product.id_product WHERE check_number='<%=check_number%>'</sql:query>

<div class="container">
    <form action="search_reciept.jsp">
    <div class="row mb-3">

        <label for="id" class="col-sm-2 col-form-label">Reciept number:</label>
        <div class="col-sm-4">
            <input type="text" id="id" name="id" class="form-control"> <br>
            <button type="submit" class="btn btn-outline-secondary" >Search</button>

        </div>
        </div>
    </form>
<table class="table">
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
                <details>


                    <summary>Products</summary>

        <c:forEach var="product" items="${products.rows}">
          ${product.product_name}  ${product.selling_price}$ x ${product.product_number} <br>

        </c:forEach>


                </details>

            </td>
            <td>${row.sum_total}</td>
            <td>${row.vat}</td>
        </tr>
    </c:forEach>

    </thead>
    <tbody id="recieptsTbody">
    </tbody>
</table>
</div>



<jsp:include page="footer.jsp"/>