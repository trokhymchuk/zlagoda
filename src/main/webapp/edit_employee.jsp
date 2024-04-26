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
  SELECT * from Employee WHERE id_employee='<%= request.getParameter("id")%>';
</sql:query>



<div class="container">

  <form action="javascript:submit('<%= request.getParameter("id")%>');">
    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Surname</label>
      <div class="col-sm-10">
        <input type="text" name="surname" class="form-control"
               value="${result.rows[0].empl_surname}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
      <div class="col-sm-10">
        <input type="text" name="name" class="form-control" id="inputEmail3"
               value="${result.rows[0].empl_name}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Patronymic</label>
      <div class="col-sm-10">
        <input type="text" name="patronymic" class="form-control"
               value="${result.rows[0].empl_patronymic}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Role</label>
      <div class="col-sm-10">
        <div class="form-check">
          <input class="form-check-input" type="radio" name="role" id="cashier" value="Cashier" ${result.rows[0].empl_role == 'Cashier' ? 'checked' : ''}>
          <label class="form-check-label" for="cashier">Cashier</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="role" id="manager" value="Manager" ${result.rows[0].empl_role == 'Manager' ? 'checked' : ''}>
          <label class="form-check-label" for="manager">Manager</label>
        </div>
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Salary</label>
      <div class="col-sm-10">
        <input type="number" name="salary" class="form-control"
               value="${result.rows[0].salary}" min="0">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Date of birth</label>
      <div class="col-sm-10">
        <input type="date" name="date_of_birth" class="form-control"
               value="${result.rows[0].date_of_birth}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Date of start</label>
      <div class="col-sm-10">
        <input type="date" name="date_of_start" class="form-control"
               value="${result.rows[0].date_of_start}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Phone number</label>
      <div class="col-sm-10">
        <input type="tel" name="phone_number" class="form-control"
               pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
               title="Please enter phone number in the format xxx-xxx-xxxx"
               value="${result.rows[0].phone_number}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">City</label>
      <div class="col-sm-10">
        <input type="text" name="city" class="form-control"
               value="${result.rows[0].city}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Street</label>
      <div class="col-sm-10">
        <input type="text" name="street" class="form-control"
               value="${result.rows[0].street}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Zip code</label>
      <div class="col-sm-10">
        <input type="text" name="zip_code" class="form-control"
               value="${result.rows[0].zip_code}">
      </div>
    </div>

    <button type="submit" class="btn btn-primary">Edit</button>
  </form>

  <script>
    function submit(employee_id) {
      if(!$('input[name="surname"]').val().trim()||!$('input[name="name"]').val().trim()||!$('input[name="role"]:checked').val()||!$('input[name="salary"]').val().trim()||!$('input[name="date_of_birth"]').val().trim()||!$('input[name="date_of_start"]').val().trim()||!$('input[name="city"]').val().trim()||!$('input[name="street"]').val().trim()||!$('input[name="zip_code"]').val().trim()||!$('input[name="phone_number"]').val().trim()){
        alert("Please fill in all required fields.");
        return;
      }
      $.ajax({
        url: '/employee',
        method: 'get',
        dataType: 'html',
        data: {
          id: employee_id,
          action: "edit",
          surname: $('input[name="surname"]').val().trim(),
          name: $('input[name="name"]').val().trim(),
          patronymic: $('input[name="patronymic"]').val().trim(),
          role:$('input[name="role"]:checked').val(),
          salary: $('input[name="salary"]').val().trim(),
          date_of_birth: $('input[name="date_of_birth"]').val().trim(),
          date_of_start: $('input[name="date_of_start"]').val().trim(),
          phone_number: $('input[name="phone_number"]').val().trim(),
          city: $('input[name="city"]').val().trim(),
          street: $('input[name="street"]').val().trim(),
          zip_code: $('input[name="zip_code"]').val().trim(),
        },
        success: function (data) {
          console.log(data);
          alert("The employee was updated successfully!");
          window.location.replace("http://localhost:8080/employee.jsp");
        },
        error: function (jqXHR, exception) {
          alert("Could not update employee: " + jqXHR.responseText);
          console.log(exception);
          console.log(jqXHR);
        }
      });

    }

  </script>
<jsp:include page="footer.jsp" />