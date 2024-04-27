<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>



<c:if test="${cookie['role'] == null}">
    <%
        String redirectURLMainPage = "http://localhost:8080/login.jsp";
        response.sendRedirect(redirectURLMainPage);
    %>
</c:if>




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
SELECT * FROM Customer_card
WHERE card_number IN (SELECT card_number
                     FROM Checktable
                     WHERE NOT EXISTS (SELECT * FROM SALE
                                      WHERE UPC NOT IN (SELECT UPC
                                                        FROM Store_product
                                                        WHERE promotional_product=false)));
</sql:query>

<div class="container">


    <table class="table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Surname</th>
            <th scope="col">Name</th>
            <th scope="col">Patronymic</th>
            <th scope="col">Phone number</th>
            <th scope="col">City</th>
            <th scope="col">Street</th>
            <th scope="col">Zip code</th>
            <th scope="col">Percent</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${result.rows}">
            <tr>
                <th scope="row"><c:out value="${row.card_number}"/></th>
                <td><c:out value="${row.cust_surname}"/></td>
                <td><c:out value="${row.cust_name}"/></td>
                <td><c:out value="${row.cust_patronymic}"/></td>
                <td><c:out value="${row.phone_number}"/></td>
                <td><c:out value="${row.city}"/></td>
                <td><c:out value="${row.street}"/></td>
                <td><c:out value="${row.zip_code}"/></td>
                <td><c:out value="${row.percent}"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>

<jsp:include page="footer.jsp" />
