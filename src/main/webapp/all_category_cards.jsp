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
    SELECT *
    FROM Customer_Card
    WHERE NOT EXISTS (
                        SELECT *
                        FROM Category
                        WHERE category_number NOT IN (
                                                        SELECT category_number
                                                        FROM Sale
                                                        INNER JOIN Store_Product ON Sale.UPC = Store_Product.UPC
                                                        INNER JOIN Product ON Store_Product.id_product = Product.id_product
                                                        INNER JOIN CheckTable ON Sale.check_number = CheckTable.check_number
                                                        WHERE Customer_Card.card_number = CheckTable.card_number
                                                     )
                     );


</sql:query>

<div class="container">
    <h2>Customers that bought products from all categories</h2>
  <table class="table">
    <thead>
    <tr>
      <th scope="col">Card number</th>
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
<script>

</script>

<jsp:include page="footer.jsp" />
