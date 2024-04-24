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
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/><sql:query dataSource="${snapshot}" var="result">
    SELECT *
    FROM Employee
    WHERE id_employee NOT IN(SELECT id_employee
    FROM checktable
    WHERE Employee.id_employee = id_employee AND EXISTS(SELECT *
                                                        FROM sale
                                                        WHERE upc = '<%= request.getParameter("upc")%>' AND checktable.check_number = check_number))
    AND empl_role NOT IN( 'Manager');
</sql:query>

<div class="container">

    <form id="searchForm">
        <div class="input-group mb-3">
            <input type="text" class="form-control" placeholder="Enter upc" name="upc" id="upc">
            <button type="button" class="btn btn-outline-secondary" onclick="search()">Search</button>
        </div>
    </form>
    <table class="table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Surname</th>
            <th scope="col">Name</th>
            <th scope="col">Patronymic</th>
            <th scope="col">Role</th>
            <th scope="col">Salary</th>
            <th scope="col">Date of birth</th>
            <th scope="col">Date of start</th>
            <th scope="col">Phone number</th>
            <th scope="col">City</th>
            <th scope="col">Street</th>
            <th scope="col">Zip code</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${result.rows}">
            <tr>
                <th scope="row"><c:out value="${row.id_employee}"/></th>
                <td><c:out value="${row.empl_surname}"/></td>
                <td><c:out value="${row.empl_name}"/></td>
                <td><c:out value="${row.empl_patronymic}"/></td>
                <td><c:out value="${row.empl_role}"/></td>
                <td><c:out value="${row.salary}"/></td>
                <td><c:out value="${row.date_of_birth}"/></td>
                <td><c:out value="${row.date_of_start}"/></td>
                <td><c:out value="${row.phone_number}"/></td>
                <td><c:out value="${row.city}"/></td>
                <td><c:out value="${row.street}"/></td>
                <td><c:out value="${row.zip_code}"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>
<script>
    function search() {
        var upc = document.getElementById("upc").value;
        window.location.href = 'search_bad_cashier.jsp?upc=' + upc;
    }
</script>

<jsp:include page="footer.jsp"/>