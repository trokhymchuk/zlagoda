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
    SELECT UPC, product_name, selling_price, products_number from Product INNER JOIN Store_Product ON Product.id_product=Store_product.id_product WHERE products_number>1 AND UPC_prom IS NULL AND UPC IN (SELECT UPC FROM Product WHERE promotional_product=false OR UPC IN (SELECT UPC_prom FROM Store_product));
</sql:query>
<sql:query dataSource="${snapshot}" var="customers">
    SELECT * from Customer_card;
</sql:query>
<div class="container">

    <form action="javascript:submit();">
        <div class="input-group mb-3">
            <select id="inputPassword3" placeholder="Customer " name="customer_id" class="form-select">
                <option value="0"> - </option>
                <c:forEach var="row" items="${customers.rows}">
                    <option value="${row.card_number}"><c:out value="${row.cust_name}"/> ${((row.cust_patronymic == null || row.cust_patronymic.length() == 0) ? ""  : row.cust_patronymic.charAt(0))} <c:out value="${row.cust_surname}"/> </option>
                </c:forEach>
            </select>

            <button type="button" class="btn btn-outline-secondary" onclick="update()">Search</button>
        </div>
        <input type="hidden" name="empl_id" class="form-control" id="inputEmail3"
               value="${cookie["empl_id"].getValue()}">

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
    let sum_total = 0;
    function submit() {
        let products_map = new Map();
        sum_total = 0;
        $('tbody').children().each(function () {
            if(!$(this).children(":first").children(":first").prop("checked"))
                return;
            sum_total += parseInt($(this).children(":nth-child(5)").children(":first").val()) * parseFloat($(this).children(":nth-child(4)").text().trim());

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
                card_number: $('select[name="customer_id"]').val().trim(),
                sale_data: JSON.stringify(mapToObj(products_map)),
                sum_total: sum_total
            },
            success: function (data) {
                console.log(data);
                //   alert("The product was added successfully!");
                window.location.replace("http://localhost:8080/reciepts.jsp");
            },
            error: function (jqXHR, exception) {
                 alert("Your session is expired! Please log in again!");
                window.location.replace("http://localhost:8080/login.jsp");
                console.log(exception);
                console.log(jqXHR);
            }
        });

    }

</script>
</body>
</html>