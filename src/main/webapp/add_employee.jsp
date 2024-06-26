<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>



<c:if test="${cookie['role'] == null || !cookie['role'].getValue().equals('Manager')}">
  <%
    String redirectURLMainPage = "http://localhost:8080/index.jsp";
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


<div class="container">

  <form action="javascript:submit('<%= request.getParameter("id")%>');">

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">ID</label>
    <div class="col-sm-10">
      <input type="text"  name="id_employee" class="form-control"
             value="">
    </div>
  </div>

  <div class="row mb-3">
  <label for="inputEmail3" class="col-sm-2 col-form-label">Surname</label>
    <div class="col-sm-10">
      <input type="text" name="surname" class="form-control"
             value="">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
    <div class="col-sm-10">
      <input type="text" name="name" class="form-control" id="inputEmail3"
             value="">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Patronymic</label>
    <div class="col-sm-10">
      <input type="text" name="patronymic" class="form-control"
             value="">
    </div>
  </div>
    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Password</label>
      <div class="col-sm-10">
        <input type="password" name="password" class="form-control"
               value="">
      </div>
    </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Role</label>
    <div class="col-sm-10">
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="role" id="cashier" value="Cashier">
        <label class="form-check-label" for="cashier">Cashier</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="role" id="manager" value="Manager">
        <label class="form-check-label" for="manager">Manager</label>
      </div>
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Salary</label>
    <div class="col-sm-10">
      <input type="number" name="salary" class="form-control"
             value="" min="0">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Date of birth</label>
    <div class="col-sm-10">
      <input type="date" name="date_of_birth" class="form-control"
             value="">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Date of start</label>
    <div class="col-sm-10">
      <input type="date" name="date_of_start" class="form-control"
             value="">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Phone number</label>
    <div class="col-sm-10">
      <input type="tel" name="phone_number" class="form-control"
             pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
             title="Please enter phone number in the format xxx-xxx-xxxx"
             value="">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">City</label>
    <div class="col-sm-10">
      <input type="text" name="city" class="form-control"
             value="">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Street</label>
    <div class="col-sm-10">
      <input type="text" name="street" class="form-control"
             value="">
    </div>
  </div>

  <div class="row mb-3">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Zip code</label>
    <div class="col-sm-10">
      <input type="text" name="zip_code" class="form-control"
             value="">
    </div>
  </div>

  <button type="submit" class="btn btn-primary">Add</button>
  </form>
</div>

  <script>
    function submit() {
      var id_employee = $('input[name="id_employee"]').val().trim();
      var surname = $('input[name="surname"]').val().trim();
      var name = $('input[name="name"]').val().trim();
      var patronymic = $('input[name="patronymic"]').val().trim();
      var role = $('input[name="role"]:checked').val();
      var password = $('input[name="password"]').val().trim();
      var salary = $('input[name="salary"]').val().trim();
      var date_of_birth = $('input[name="date_of_birth"]').val().trim();
      var date_of_start = $('input[name="date_of_start"]').val().trim();
      var phone_number = $('input[name="phone_number"]').val().trim();
      var city = $('input[name="city"]').val().trim();
      var street = $('input[name="street"]').val().trim();
      var zip_code = $('input[name="zip_code"]').val().trim();
      if (!id_employee || !surname || !name || !role || !password || !salary || !date_of_birth || !date_of_start || !phone_number || !city || !street || !zip_code) {
        alert("Please fill in all required fields.");
        return;
      }
      $.ajax({
        url: '/employee',
        method: 'get',
        dataType: 'html',
        data: {
          action: "add",
          id: id_employee,
          surname: surname,
          name: name,
          patronymic: patronymic,
          role: role,
          password: password,
          salary: salary,
          date_of_birth: date_of_birth,
          date_of_start: date_of_start,
          phone_number: phone_number,
          city: city,
          street: street,
          zip_code: zip_code,
        },
        success: function (data) {
          console.log(data);
          alert("The employee was added successfully!");
          window.location.replace("http://localhost:8080/employee.jsp");
        },
        error: function (jqXHR, exception) {
          alert("Could not add employee: " + jqXHR.responseText);
          console.log(exception);
          console.log(jqXHR);
        }
      });

    }

  </script>
  </body>
  </html>