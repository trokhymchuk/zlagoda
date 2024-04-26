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
    Cookie cookie = null;
    Cookie[] cookies = request.getCookies();
    String empl_id = "";

    for (int i = 0; i < cookies.length; i++) {
        cookie = cookies[i];
        if(cookie.getName( ).equals("empl_id"))
            empl_id=cookie.getValue();
    }

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
    SELECT * FROM Employee WHERE id_employee='<%=empl_id%>';
</sql:query>
<div class="container">
    <c:forEach var="row" items="${result.rows}">

        <form action="javascript:submit();">

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">ID</label>
                <div class="col-sm-10">
                    <input type="text" name="id_employee" class="form-control"
                           value="${row.id_employee}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Surname</label>
                <div class="col-sm-10">
                    <input type="text" name="surname" class="form-control"
                           value="${row.empl_surname}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
                <div class="col-sm-10">
                    <input type="text" name="name" class="form-control" id="inputEmail3"
                          value="${row.empl_name}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Patronymic</label>
                <div class="col-sm-10">
                    <input type="text" name="patronymic" class="form-control"
                           value="${row.empl_patronymic}" disabled>
                </div>
            </div>
            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Password</label>
                <div class="col-sm-10">
                    <input type="password" name="password" class="form-control"
                           value="" minlength="6">
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Role</label>
                <div class="col-sm-10">
                    <input type="text" name="patronymic" class="form-control"
                           value="${row.empl_role}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Salary</label>
                <div class="col-sm-10">
                    <input type="number" name="salary" class="form-control"
                           value="${row.salary}" disabled min="0">
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Date of birth</label>
                <div class="col-sm-10">
                    <input type="date" name="date_of_birth" class="form-control"
                           value="${row.date_of_birth}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Date of start</label>
                <div class="col-sm-10">
                    <input type="date" name="date_of_start" class="form-control"
                           value="${row.date_of_start}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Phone number</label>
                <div class="col-sm-10">
                    <input type="tel" name="phone_number" class="form-control"
                           pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
                           title="Please enter phone number in the format xxx-xxx-xxxx"
                           value="${row.phone_number}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">City</label>
                <div class="col-sm-10">
                    <input type="text" name="city" class="form-control"
                           value="${row.city}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Street</label>
                <div class="col-sm-10">
                    <input type="text" name="street" class="form-control"
                           value="${row.street}" disabled>
                </div>
            </div>

            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">Zip code</label>
                <div class="col-sm-10">
                    <input type="text" name="zip_code" class="form-control"
                           value="${row.zip_code}" disabled>
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Update password</button>
        </form>
    </c:forEach>



</div>

<script>
    function submit() {
        $.ajax({
            url: '/employee',
            method: 'get',
            dataType: 'html',
            data: {
                action: "passreset",
                password: $('input[name="password"]').val().trim(),
                id: $('input[name="id_employee"]').val().trim(),

            },
            success: function (data) {
                console.log(data);
                window.location.replace("http://localhost:8080/me.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not update password: " + jqXHR.responseText);
                console.log(exception);
                console.log(jqXHR);
            }
        });

    }

</script>
</body>
</html>