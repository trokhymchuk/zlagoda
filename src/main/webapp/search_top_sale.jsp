<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<jsp:include page="header.jsp" />
<jsp:include page="DB.jsp" />
<%
    String potsgres_username = (String) request.getAttribute("potsgres_username");
    String postgres_password = (String) request.getAttribute("postgres_password");

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    SELECT Store_product.upc, product_name, SUM(product_number) as number_sold
    FROM sale inner join Store_product ON sale.upc = Store_product.upc inner join product ON Store_product.id_product =product.id_product
    WHERE product.category_number = '<%= request.getParameter("category")%>'
    GROUP BY Store_product.upc, product.product_name, product.category_number
    ORDER BY -SUM(product_number), product_name;
</sql:query>

<sql:query dataSource="${snapshot}" var="categories">
    SELECT * from Category;
</sql:query>

<sql:query dataSource="${snapshot}" var="category">
    SELECT * from Category WHERE category_number = '<%= request.getParameter("category")%>';
</sql:query>

<div class="container">
    <h1>TOP SALES</h1>
    <form id="searchForm">
        <div class="input-group mb-3">
            <select id="category" placeholder="Enter category" name="category" class="form-select">
                <option value="*"></option>
                <c:forEach var="row" items="${categories.rows}">
                    <option value="${row.category_number}">${row.category_name}</option>
                </c:forEach>
            </select>

            <button type="button" class="btn btn-outline-secondary" onclick="search()">Search</button>
        </div>
    </form>
    <h2></h2>
    <c:forEach var="row" items="${category.rows}">
        <h2><c:out value="${row.category_name}"/></h2>
    </c:forEach>
    <table class="table">
        <thead>
        <tr>
            <th scope="col">#UPC</th>
            <th scope="col">Product Name</th>
            <th scope="col">Number sold</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${result.rows}">
            <tr>
                <th scope="row"><c:out value="${row.upc}"/></th>
                <td><c:out value="${row.product_name}"/></td>
                <td><c:out value="${row.number_sold}"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    function search() {
        var category = document.getElementById("category").value;
        window.location.href = 'search_top_sale.jsp?category=' + category;
    }
</script>

<jsp:include page="footer.jsp" />
