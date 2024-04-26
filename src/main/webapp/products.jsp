<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>



<c:if test="${cookie['role'] == null}">
    <%
        String redirectURLMainPage = "http://localhost:8080/login.jsp";
        response.sendRedirect(redirectURLMainPage);
    %>
</c:if>



<head>

    <style>
<c:choose>

    <c:when test = "${!cookie['role'].getValue().equals('Manager')}">

.manager{
    display: none;
}

</c:when>
</c:choose>

    </style>
</head>

<jsp:include page="header.jsp"/>
<jsp:include page="DB.jsp"/>
<%
    String potsgres_username = (String) request.getAttribute("potsgres_username");
    String postgres_password = (String) request.getAttribute("postgres_password");

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    <%--    9th  --%>
    SELECT * from Product ORDER BY product_name;
</sql:query>
<sql:query dataSource="${snapshot}" var="categories">
    SELECT * from Category;
</sql:query>

<div class="container">
    <form id="searchForm">
        <div class="input-group mb-3">
            <select id="inputPassword3" placeholder="Enter category" name="category" class="form-select">
                <option value="*"></option>
                <c:forEach var="row" items="${categories.rows}">
                    <option value="${row.category_number}">${row.category_name}</option>
                </c:forEach>
            </select>

            <button type="button" class="btn btn-outline-secondary" onclick="update()">Search</button>
        </div>

        <div class="input-group mb-3">
            <input type="text" class="form-control" placeholder="Enter name" name="name" id="name">
            <button type="button" class="btn btn-outline-secondary" onclick="search()">Search</button>
        </div>
    </form>

    <table class="table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Name</th>
            <th scope="col">Category</th>
            <th scope="col">Characteristics</th>

            <th scope="col" class="manager">Edit</th>
            <th scope="col" class="manager">Delete</th>

        </tr>
        </thead>
        <tbody id="productsTable">
<%--        <c:forEach var="row" items="${result.rows}">--%>
<%--            <tr>--%>
<%--                <th scope="row"><c:out value="${row.id_product}"/></th>--%>
<%--                <td><c:out value="${row.product_name}"/></td>--%>
<%--                <td><c:out value="${row.characteristics}"/></td>--%>
<%--                <td>--%>
<%--                    <a class="btn btn-primary" href="edit_product.jsp?id=${row.id_product}"><i--%>
<%--                            class="fa-solid fa-pen-to-square"></i></a>--%>
<%--                </td>--%>
<%--                <td>--%>
<%--                    <button onclick="remove_product('${row.id_product}')" type="button" class="btn btn-danger"><i--%>
<%--                            class="fa-solid fa-trash"--%>
<%--                    ></i>--%>
<%--                    </button>--%>

<%--                </td>--%>
<%--            </tr>--%>
<%--        </c:forEach>--%>
        </tbody>
    </table>

</div>
<script>
    function remove_product(product_id) {
        $.ajax({
            url: '/product',
            method: 'get',
            dataType: 'html',
            data: {id: product_id, action: "delete"},
            success: function (data) {
                console.log(data);
                alert("The product was deleted successfully!");
                window.location.replace("http://localhost:8080/products.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not delete product: " + jqXHR.responseText);
                //console.log(exception);
                //alert(jqXHR.text);
            }
        });

    }

    function update() {
        $.ajax({
            url: '/product',
            method: 'get',
            dataType: 'html',
            data: {category: $('select[name="category"]').val().trim(), action: "list"},
            success: function (data) {
                $("#productsTable").html(data);
            },
            error: function (jqXHR, exception) {
                console.log(jqXHR);
                console.log(exception);

                //   alert("Please, reload page!");
            }
        });

    }

    function search() {
        var name = document.getElementById("name").value;
        window.location.href = 'search_product.jsp?name=' + name;
    }

    update();
</script>


<jsp:include page="footer.jsp"/>