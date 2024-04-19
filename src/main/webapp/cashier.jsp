<%@ page import="java.sql.*,java.util.*,jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="header.jsp" />
<jsp:include page="DB.jsp" />

<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="${potsgres_username}" password="${postgres_password}"/>

<sql:query dataSource="${snapshot}" var="cashierList">
  SELECT * FROM Employee WHERE empl_role = 'Cashier' ORDER BY empl_surname ASC
</sql:query>

<div class="container">
  <h2>Info about cashiers</h2>
  <table class="table">
    <thead>
    <tr>
      <th>ID</th>
      <th>Surname</th>
      <th>Name</th>
      <th>Patronymic</th>
      <th>Salary</th>
      <th>Date of Birth</th>
      <th>Date of Start</th>
      <th>Phone Number</th>
      <th>City</th>
      <th>Street</th>
      <th>Zip Code</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="cashier" items="${cashierList.rows}">
      <tr>
        <td><c:out value="${cashier.id_employee}"/></td>
        <td><c:out value="${cashier.empl_surname}"/></td>
        <td><c:out value="${cashier.empl_name}"/></td>
        <td><c:out value="${cashier.empl_patronymic}"/></td>
        <td><c:out value="${cashier.salary}"/></td>
        <td><c:out value="${cashier.date_of_birth}"/></td>
        <td><c:out value="${cashier.date_of_start}"/></td>
        <td><c:out value="${cashier.phone_number}"/></td>
        <td><c:out value="${cashier.city}"/></td>
        <td><c:out value="${cashier.street}"/></td>
        <td><c:out value="${cashier.zip_code}"/></td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

<jsp:include page="footer.jsp" />
