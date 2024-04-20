<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<jsp:include page="header.jsp"/>
<jsp:include page="DB.jsp" />
<%
    String potsgres_username = (String) request.getAttribute("potsgres_username");
    String postgres_password = (String) request.getAttribute("postgres_password");

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    SELECT * FROM Store_Product INNER JOIN Product ON Store_Product.id_product=Product.id_product WHERE UPC LIKE '<%= request.getParameter("upc")%>%'ORDER BY product_name;
</sql:query>
<div class="container">
    <form id="searchForm">
        <div class="input-group mb-3">
            <input type="text" class="form-control" placeholder="Enter UPC" name="upc" id="upc">
            <button type="button" class="btn btn-outline-secondary" onclick="search()">Search</button>
        </div>
    </form>

    <div id="result">
    </div>
    <table class="table">
        <thead>
        <tr>
            <th scope="col">#UPC</th>
            <th scope="col">Product Name</th>
            <th scope="col">Price</th>
            <th scope="col">Products number</th>
            <th scope="col">Characteristics</th>
            <th scope="col">Promotional</th>
            <th scope="col">Edit</th>
            <th scope="col">Delete</th>

        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${result.rows}">
            <sql:query dataSource="${snapshot}" var="productName">
                SELECT product_name from Product WHERE id_product='${row.id_product}';
            </sql:query>

            <tr>
                <th scope="row"><c:out value="${row.UPC}"/></th>
                <td><c:out value="${productName.rows[0].product_name}"/></td>
                <td><c:out value="${row.selling_price}"/></td>
                <td><c:out value="${row.products_number}"/></td>
                <td><c:out value="${row.characteristics}"/></td>
                <td>
                    <c:choose>
                        <c:when test="${row.promotional_product}">
                            <button type="button" class="btn btn-outline-secondary" disabled>Promotional</button>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${row.UPC_prom == null}">
                                    <button type="button" onclick="add_promotional('${row.UPC}')"
                                            class="btn btn-success">Add promotional
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" onclick="del_promotional('${row.UPC}')"
                                            class="btn btn-danger">Del promotional
                                    </button>
                                </c:otherwise>
                            </c:choose>

                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${row.promotional_product}">
                            <a class="btn btn-primary disabled" href="#"><i
                                    class="fa-solid fa-pen-to-square"></i></a>
                        </c:when>
                        <c:otherwise>
                            <a class="btn btn-primary" href="edit_store_product.jsp?UPC=${row.UPC}"><i
                                    class="fa-solid fa-pen-to-square"></i></a>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <button onclick="remove_store_product('${row.UPC}')" type="button" class="btn btn-danger"><i
                            class="fa-solid fa-trash"
                    ></i>
                    </button>

                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>
<script>
    function remove_store_product(UPC) {
        $.ajax({
            url: '/store_product',
            method: 'get',
            dataType: 'html',
            data: {UPC: UPC, action: "delete"},
            success: function (data) {
                console.log(data);
                //      alert("The product was deleted successfully!");
                window.location.replace("http://localhost:8080/store_products.jsp");

            },
            error: function (jqXHR, exception) {
                alert("Could not delete product: " + jqXHR.responseText);
                console.log(jqXHR);
                console.log(exception);
            }
        });

    }

    function add_promotional(UPC) {
        $.ajax({
            url: '/store_product',
            method: 'get',
            dataType: 'html',
            data: {UPC: UPC, action: "add_promotional"},
            success: function (data) {
                console.log(data);
                //       alert("The product was deleted successfully!");
                window.location.replace("http://localhost:8080/store_products.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not delete product: " + jqXHR.responseText);
                console.log(jqXHR);
                console.log(exception);
            }
        });

    }

    function del_promotional(UPC) {
        $.ajax({
            url: '/store_product',
            method: 'get',
            dataType: 'html',
            data: {UPC: UPC, action: "del_promotional"},
            success: function (data) {
                console.log(data);
                //         alert("The product was deleted successfully!");
                window.location.replace("http://localhost:8080/store_products.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not delete product: " + jqXHR.responseText);
                console.log(jqXHR);
                console.log(exception);
            }
        });

    }

    function search() {
        var upc = document.getElementById("upc").value;
        window.location.href = 'search_store_product.jsp?upc=' + upc;
    }

</script>


<jsp:include page="footer.jsp"/>
