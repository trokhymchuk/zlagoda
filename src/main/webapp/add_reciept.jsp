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

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    SELECT UPC, product_name, selling_price, products_number from Product INNER JOIN Store_Product ON Product.id_product=Store_product.id_product;
</sql:query>

<div class="container">

    <form action="javascript:submit();">
        <div class="row mb-3">
            <label for="inputEmail3" class="col-sm-2 col-form-label">Employee ID:</label>
            <div class="col-sm-10">
                <input type="text" name="empl_id" class="form-control" id="inputEmail3"
                       value="">
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputEmail4" class="col-sm-2 col-form-label">Customer ID:</label>
            <div class="col-sm-10">
                <input type="text" name="customer_id" class="form-control" id="inputEmail4"
                       value="">
            </div>
        </div>
        <table class="table">
            <thead>
            <tr>
                <th scope="col" style="text-align: center;"> Select </th>
                <th scope="col">#</th>
                <th scope="col">Name</th>
                <th scope="col">Price per unit</th>
                <th scope="col">Count</th>

            </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${result.rows}">
                <tr>
                    <td style="text-align: center;"> <input type="checkbox"></td>
                    <th scope="row"><c:out value="${row.UPC}"/></th>
                    <td><c:out value="${row.product_name}"/></td>
                    <td>
                            ${row.selling_price}
                    </td>
                    <td>
                        <input style="width:80px"  type="number" min="1" max="${row.products_number}" value="1">
                    </td>
                    <input type="hidden" value="${row.UPC}">
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <button type="submit" class="btn btn-primary">Add</button>
    </form>

</div>

<script>
    function mapToObj (map) {
        return [...map].reduce((acc, val) => {
            acc[val[0]] = val[1];
            return acc;
        }, {});
    }

    function submit() {
        let products_map = new Map();
        $('tbody').children().each(function () {
            if(!$(this).children(":first").children(":first").prop("checked"))
                return;
            products_map.set($(this).children(":last").val(), {
                'product_number' :  parseInt($(this).children(":nth-child(5)").children(":first").val()),
                'selling_price' :  parseFloat($(this).children(":nth-child(4)").text().trim()),
            })
        });
      console.log(JSON.stringify(mapToObj(products_map)));
        $.ajax({
            url: '/receipt',
            method: 'get',
            dataType: 'html',
            data: {
                action: "add",
                id_employee: $('input[name="empl_id"]').val().trim(),
                card_number: $('input[name="customer_id"]').val().trim(),
                sale_data: JSON.stringify(mapToObj(products_map)),
                sum_total: 0
            },
            success: function (data) {
                console.log(data);
                //   alert("The product was added successfully!");
                window.location.replace("http://localhost:8080/categories.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not add receipt: " + jqXHR.responseText);
                console.log(exception);
                console.log(jqXHR);
            }
        });

    }

</script>
</body>
</html>