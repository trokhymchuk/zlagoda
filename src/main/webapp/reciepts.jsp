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
    SELECT * from checktable INNER JOIN Employee ON checktable.id_employee=Employee.id_employee INNER JOIN Customer_card ON checktable.card_number=Customer_card.card_number;
</sql:query>

<div class="container">
    <table class="table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Employee</th>
            <th scope="col">Customer</th>
            <th scope="col">Date</th>
            <th scope="col">Amount</th>
            <th scope="col">VAT</th>
            <th scope="col">Delete</th>


        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${result.rows}">
            <tr>
                <th scope="row"><c:out value="${row.check_number}"/></th>
                <td><c:out value="${row.empl_name}"/> <c:out value="${row.empl_patronymic.charAt(0)}"/>. <c:out value="${row.empl_surname}"/></td>
                <td><c:out value="${row.cust_name}"/> <c:out value="${row.cust_patronymic.charAt(0)}"/>. <c:out value="${row.cust_surname}"/></td>
                <td><c:out value="${row.print_date}"/></td>
                <td><c:out value="${row.sum_total}"/></td>
                <td><c:out value="${row.vat}"/></td>
                <td>
                    <button onclick="remove('${row.check_number}')" type="button" class="btn btn-danger"><i
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

<jsp:include page="footer.jsp" />