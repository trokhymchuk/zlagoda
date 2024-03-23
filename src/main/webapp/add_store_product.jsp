<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<jsp:include page="header.jsp" />
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="postgres" password="admin"/>


<sql:query dataSource="${snapshot}" var="products">
    SELECT id_product, product_name from Product;
</sql:query>

<div class="container">
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Злагода</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Link</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            Продукти
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="/products.jsp">Cписок</a></li>
                            <li><a class="dropdown-item" href="/add_product.jsp">Додати</a></li>

                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="#">Something else here</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
                    </li>
                </ul>
                <form class="d-flex">
                    <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                    <button class="btn btn-outline-success" type="submit">Search</button>
                </form>
            </div>
        </div>
    </nav>
</div>


<div class="container">

    <form action="javascript:submit();">
        <div class="row mb-3">
            <label for="inputEmail3" class="col-sm-2 col-form-label">UPC</label>
            <div class="col-sm-10">
                <input type="text" name="UPC" class="form-control" id="inputEmail3"
                       value="">
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputEmail4" class="col-sm-2 col-form-label">Selling price</label>
            <div class="col-sm-10">
                <input type="number" step="0.0001" min="0" name="selling_price" class="form-control" id="inputEmail4"
                       value="">
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputEmail5" class="col-sm-2 col-form-label">Products number</label>
            <div class="col-sm-10">
                <input type="number" min="0" name="products_number" class="form-control" id="inputEmail5"
                       value="">
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputPassword3" class="col-sm-2 col-form-label">Product</label>
            <div class="col-sm-10">
                <select id="inputPassword3" name="id_product" class="form-select">
                    <c:forEach var="row" items="${products.rows}">
                        <option value="${row.id_product}">${row.product_name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Add store product</button>
    </form>
</div>

<script>
    function submit() {
        $.ajax({
            url: '/store_product',
            method: 'get',
            dataType: 'html',
            data: {
                action: "add",
                UPC: $('input[name="UPC"]').val().trim(),
                id_product: $('select[name="id_product"]').val().trim(),
                selling_price: $('input[name="selling_price"]').val().trim(),
                products_number: $('input[name="products_number"]').val().trim(),
            },
            success: function (data) {
                console.log(data);
                alert("The product was added successfully!");
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