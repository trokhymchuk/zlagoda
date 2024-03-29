<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<jsp:include page="header.jsp" />
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="Kate" password=""/>
<%--user="postgres" password="admin"/>--%>



<sql:query dataSource="${snapshot}" var="categories">
SELECT * from Category;
</sql:query>


<div class="container">

    <form action="javascript:submit();">
    <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
    <div class="col-sm-10">
    <input type="text" name="name" class="form-control" id="inputEmail3"
        value="">
</div>
</div>
<div class="row mb-3">
<label for="inputPassword3" class="col-sm-2 col-form-label">Category</label>
<div class="col-sm-10">
<select id="inputPassword3" name="category" class="form-select">
 <c:forEach var="row" items="${categories.rows}">
     <option value="${row.category_number}">${row.category_name}</option>
 </c:forEach>
</select>
</div>
</div>
<div class="mb-3">
<label for="exampleFormControlTextarea1" class="form-label">Characteristics</label>
<textarea name="characteristics" class="form-control" id="exampleFormControlTextarea1"
   rows="3"></textarea>
</div>

<button type="submit" class="btn btn-primary">Edit</button>
</form>

<%--    <table class="table">--%>
    <%--        <thead>--%>
    <%--        <tr>--%>
    <%--            <th scope="col">#</th>--%>
    <%--            <th scope="col">Name</th>--%>
    <%--            <th scope="col">Characteristics</th>--%>
    <%--            <th scope="col">Edit</th>--%>
    <%--            <th scope="col">Delete</th>--%>
    <%--        </tr>--%>
    <%--        </thead>--%>
    <%--        <tbody>--%>
    <%--        <c:forEach var="row" items="${result.rows}">--%>
    <%--            <tr>--%>
    <%--                <th scope="row"><c:out value="${row.id_product}"/></th>--%>
    <%--                <td><c:out value="${row.product_name}"/></td>--%>
    <%--                <td><c:out value="${row.characteristics}"/></td>--%>
    <%--                <td><a href="edit_product.jsp?id=${row.id_product}"><i class="fa-solid fa-pen-to-square"></i></a></td>--%>
    <%--                <td><i class="fa-solid fa-trash" onclick="remove_product('${row.id_product}')"></i></td>--%>
    <%--            </tr>--%>
    <%--        </c:forEach>--%>
    <%--        </tbody>--%>
    <%--    </table>--%>

    <%--</div>--%>

    <%--<sql:query dataSource = "${snapshot}" var = "product_category">--%>
    <%--    SELECT * from Category WHERE category_number=${result.};--%>
    <%--</sql:query>--%>

    <%--<table>--%>
    <%--    <tr>--%>
    <%--        <td>--%>
    <%--            Name:--%>
    <%--        </td>--%>
    <%--        <td>--%>
    <%--            <input name="name" type="text" value="${result.rows[0].product_name}">--%>
    <%--        </td>--%>
    <%--    </tr>--%>
    <%--    <tr>--%>
    <%--        <td>--%>
    <%--            Characteristics:--%>
    <%--        </td>--%>
    <%--        <td>--%>
    <%--            <textarea name="characteristics" rows="5" cols="20">--%>
    <%--                ${result.rows[0].characteristics}--%>
    <%--            </textarea>--%>
    <%--        </td>--%>
    <%--    </tr>--%>
    <%--    <tr>--%>
    <%--        <td>--%>
    <%--            Category:--%>
    <%--        </td>--%>
    <%--        <td>--%>
    <%--            <select name="category">--%>
    <%--                <c:forEach var="row" items="${categories.rows}">--%>
    <%--                    <option value="${row.category_number}"  ${(result.rows[0].category_number == row.category_number) ? "selected" : ""}>${row.category_name}</option>--%>
    <%--                </c:forEach>--%>
    <%--            </select>--%>
    <%--        </td>--%>
    <%--    </tr>--%>
    <%--<tr>--%>
    <%--    <td colspan="2">--%>
    <%--        <button onclick="submit('<%= request.getParameter("id")%>')">Submit</button>--%>
    <%--    </td>--%>
    <%--</tr>--%>
    <%--</table>--%>


    <script>
        function submit() {
            $.ajax({
                url: '/product',
                method: 'get',
                dataType: 'html',
                data: {
                    action: "add",
                    name: $('input[name="name"]').val().trim(),
                    characteristics: $('textarea[name="characteristics"]').val().trim(),
                    category: $('select[name="category"]').val().trim(),
                },
                success: function (data) {
                    console.log(data);
                    alert("The product was added successfully!");
                    window.location.replace("http://localhost:8080/products.jsp");
                },
                error: function (jqXHR, exception) {
                    alert("Could not add product: " + jqXHR.responseText);
                    console.log(exception);
                    console.log(jqXHR);
                }
            });

        }

    </script>
</body>
</html>