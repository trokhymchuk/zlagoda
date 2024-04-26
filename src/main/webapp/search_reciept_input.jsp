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

<sql:query dataSource="${snapshot}" var="casheirs">
    SELECT * from Employee WHERE empl_role='Cashier';
</sql:query>

<div class="container">
    <form action="search_reciept.jsp" method="GET">
    <div class="row mb-3">

        <label for="id" class="col-sm-2 col-form-label">Reciept number:</label>
        <div class="col-sm-4">
            <input type="text" id="id" name="id" class="form-control">    <br>        <button type="submit" class="btn btn-outline-secondary" >Search</button>


        </div>
        </div>
    </form>
    </div>

</div>


<jsp:include page="footer.jsp"/>