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
    SELECT * from Category WHERE category_number=<%= request.getParameter("id")%>;
</sql:query>
<div class="container">
    <form action="javascript:submit('<%= request.getParameter("id")%>');">
        <div class="row mb-3">
            <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
            <div class="col-sm-10">
                <input type="text" name="name" class="form-control" id="inputEmail3"
                       value="${result.rows[0].category_name}">
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Edit</button>
    </form>


    <script>
        function submit(id) {
            $.ajax({
                url: '/category',
                method: 'get',
                dataType: 'html',
                data: {
                    action: "edit",
                    category_number:id,
                    category_name: $('input[name="name"]').val().trim(),
                },
                success: function (data) {
                    console.log(data);
                    window.location.replace("http://localhost:8080/categories.jsp");
                },
                error: function (jqXHR, exception) {
                    alert("Could not update product: " + jqXHR.responseText);
                    console.log(exception);
                    console.log(jqXHR);
                }
            });

        }

    </script>
<jsp:include page="footer.jsp"/>