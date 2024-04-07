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


<div class="container">

    <form action="javascript:submit();">
        <div class="row mb-3">
            <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
            <div class="col-sm-10">
                <input type="text" name="name" class="form-control" id="inputEmail3"
                       value="">
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Add</button>
    </form>

</div>

<script>
    function submit() {
        $.ajax({
            url: '/category',
            method: 'get',
            dataType: 'html',
            data: {
                action: "add",
                category_name: $('input[name="name"]').val().trim(),
            },
            success: function (data) {
                console.log(data);
                //   alert("The product was added successfully!");
                window.location.replace("http://localhost:8080/categories.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not add category: " + jqXHR.responseText);
                console.log(exception);
                console.log(jqXHR);
            }
        });

    }

</script>
</body>
</html>