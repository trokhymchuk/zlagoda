<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
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
    SELECT * from Store_product WHERE UPC='<%= request.getParameter("UPC")%>';
</sql:query>


<sql:query dataSource="${snapshot}" var="products">
    SELECT id_product,product_name from Product WHERE id_product IN (SELECT id_product FROM Store_product WHERE UPC='<%= request.getParameter("UPC")%>');
</sql:query>

<div class="container">

    <form action="javascript:submit();">
        <div class="row mb-3">
            <label for="inputEmail3" class="col-sm-2 col-form-label">UPC</label>
            <div class="col-sm-10">
                <input type="text" name="UPC" class="form-control" id="inputEmail3"
                       value="${result.rows[0].UPC}" disabled>
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputEmail4" class="col-sm-2 col-form-label">Selling price</label>
            <div class="col-sm-10">
                <input type="number" step="0.0001" min="0" name="selling_price" class="form-control" id="inputEmail4"
                       value="${result.rows[0].selling_price}">
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputEmail5" class="col-sm-2 col-form-label">Products number</label>
            <div class="col-sm-10">
                <input type="number" min="0" name="products_number" class="form-control" id="inputEmail5"
                       value="${result.rows[0].products_number}">
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputPassword3" class="col-sm-2 col-form-label">Product</label>
            <div class="col-sm-10">
                <select id="inputPassword3" name="id_product" class="form-select" disabled>
                    <c:forEach var="row" items="${products.rows}">
                        <option value="${row.id_product}">${row.product_name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Edit store product</button>
    </form>
</div>
<script>
    function submit() {
        $.ajax({
            url: '/store_product',
            method: 'get',
            dataType: 'html',
            data: {
                action: "edit",
                UPC: $('input[name="UPC"]').val().trim(),
                selling_price: $('input[name="selling_price"]').val().trim(),
                products_number: $('input[name="products_number"]').val().trim(),
            },
            success: function (data) {
                console.log(data);
            //    alert("The product was added successfully!");
                window.location.replace("http://localhost:8080/store_products.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not add product: " + jqXHR.responseText);
                console.log(exception);
                console.log(jqXHR);
            }
        });

    }

</script>
<jsp:include page="footer.jsp" />