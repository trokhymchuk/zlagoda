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
    SELECT * from checktable INNER JOIN Employee ON checktable.id_employee=Employee.id_employee INNER JOIN Customer_card ON checktable.card_number=Customer_card.card_number;
</sql:query>
<sql:query dataSource="${snapshot}" var="casheirs">
    SELECT * from Employee WHERE empl_role='Cashier';
</sql:query>
<div class="container">
    <div class="row mb-3">

        <label for="startDate" class="col-sm-2 col-form-label">Start Date</label>
        <div class="col-sm-4">
            <input type="date" id="startDate" name="startDate" class="form-control">
        </div>
        <label for="endDate" class="col-sm-2 col-form-label">End Date (exclusive)</label>
        <div class="col-sm-4">
            <input type="date" id="endDate" name="endDate" class="form-control">
        </div>
        <label for="inputPassword3" class="col-sm-2 col-form-label">Cashier</label>
        <div class="col-sm-10">
            <div class="row mb-3">

                <div class="input-group mb-3">
                    <select id="inputPassword3" placeholder="Enter category" name="cashier" class="form-select">
                        <option value="*"></option>
                        <c:forEach var="row" items="${casheirs.rows}">
                            <option value="${row.id_employee}">${row.empl_name} ${((row.empl_patronymic == null || row.empl_patronymic.length() == 0) ? ""  : row.empl_patronymic.charAt(0))}. ${row.empl_surname} </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <button type="button" class="btn btn-outline-secondary" onclick="update()">Search</button>
        </div>

    </div>
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
            <th scope="col">Delete</th>


        </tr>
        </thead>
        <tbody id="recieptsTbody">
        </tbody>
    </table>


    <div class="row mb-3">
        <div class="col-sm-12">
            <p>Total Sum: <span id="totalSum"></span></p>
        </div>
    </div>

</div>
<script>
    function remove(check_number) {
        $.ajax({
            url: '/receipt',
            method: 'get',
            dataType: 'html',
            data: {check_number: check_number, action: "delete"},
            success: function (data) {
                console.log(data);
                window.location.replace("http://localhost:8080/reciepts.jsp");
            },
            error: function (jqXHR, exception) {
                alert(jqXHR.responseText);
                //console.log(exception);
                //alert(jqXHR.text);
            }
        });

    }
</script>

<script>
    function getTotalSum() {
        let total_sum = 0;
        $('tbody').children().each(function () {
            total_sum += +($(this).children(":nth-child(6)").text())
        });
        $("#totalSum").text(total_sum.toFixed(2))

    }

    function update() {
        $.ajax({
            url: '/receipt',
            method: 'get',
            dataType: 'html',
            data: {
                cashier: $('select[name="cashier"]').val().trim(),
                startDate: $('input[name="startDate"]').val().trim(),
                endDate: $('input[name="endDate"]').val().trim(),
                action: "list"
            },
            success: function (data) {
                $("#recieptsTbody").html(data);
                getTotalSum();
            },
            error: function (jqXHR, exception) {
                console.log(jqXHR);
                console.log(exception);

                //   alert("Please, reload page!");
            }
        });
    }

    update();
</script>

<jsp:include page="footer.jsp"/>