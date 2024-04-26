<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>



<c:if test="${cookie['role'] == null}">
    <%
        String redirectURLMainPage = "http://localhost:8080/index.jsp";
        response.sendRedirect(redirectURLMainPage);
    %>
</c:if>

<head>

    <style>
        <c:choose>

        <c:when test = "${!cookie['role'].getValue().equals('Manager')}">

        .manager{
            display: none;
        }

        </c:when>
        </c:choose>

    </style>
</head>


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
    SELECT * from Category ORDER BY category_name;
</sql:query>

<div class="container">
    <table class="table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Name</th>
            <th scope="col" class="manager">Edit</th>
            <th scope="col" class="manager">Delete</th>

        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${result.rows}">
            <tr>
                <th scope="row"><c:out value="${row.category_number}"/></th>
                <td><c:out value="${row.category_name}"/></td>
                <td class="manager">
                    <a class="btn btn-primary" href="edit_category.jsp?id=${row.category_number}"><i
                            class="fa-solid fa-pen-to-square"></i></a>
                </td>
                <td class="manager">
                    <button onclick="remove_category('${row.category_number}')" type="button" class="btn btn-danger"><i
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
    function remove_category(id) {
        $.ajax({
            url: '/category',
            method: 'get',
            dataType: 'html',
            data: {category_number: id, action: "delete"},
            success: function (data) {
                console.log(data);
             //   alert("The product was deleted successfully!");
                window.location.replace("http://localhost:8080/categories.jsp");
            },
            error: function (jqXHR, exception) {
                alert("Could not delete category: " + jqXHR.responseText);
                //console.log(exception);
                //alert(jqXHR.text);
            }
        });

    }
</script>

<jsp:include page="footer.jsp" />