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
  SELECT * from Employee ORDER BY empl_surname;
</sql:query>

<div class="container">
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
      <th scope="col">Edit</th>
      <th scope="col">Delete</th>

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
        <td>
          <a class="btn btn-primary" href="edit_employee.jsp?id=${row.id_employee}"><i
                  class="fa-solid fa-pen-to-square"></i></a>
        </td>
        <td>
          <button onclick="remove_employee('${row.id_employee}')" type="button" class="btn btn-danger"><i
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
  function remove_employee(employee_id) {
    $.ajax({
      url: '/employee',
      method: 'get',
      dataType: 'html',
      data: {id: employee_id, action: "delete"},
      success: function (data) {
        console.log(data);
        alert("The employee was deleted successfully!");
        window.location.replace("http://localhost:8080/employee.jsp");
      },
      error: function (jqXHR, exception) {
        alert("Could not delete employee: " + jqXHR.responseText);
        //console.log(exception);
        //alert(jqXHR.text);
      }
    });

  }
</script>

<jsp:include page="footer.jsp" />