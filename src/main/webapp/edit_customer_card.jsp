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
  SELECT * from Customer_Card WHERE card_number='<%= request.getParameter("card_number")%>';
</sql:query>

<div class="container">

  <form action="javascript:submit('<%= request.getParameter("card_number")%>');">

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Surname</label>
      <div class="col-sm-10">
        <input type="text" minlength="3" required name="cust_surname" class="form-control"
               value="${result.rows[0].cust_surname}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
      <div class="col-sm-10">
        <input type="text" minlength="3" required name="cust_name" class="form-control"
               value="${result.rows[0].cust_name}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Patronymic</label>
      <div class="col-sm-10">
        <input type="text"  name="cust_patronymic" class="form-control"
               value="${result.rows[0].cust_patronymic}">
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
               pattern="^.{1,9}$"
               title="Zip code must be up to 9 characters."
               value="${result.rows[0].zip_code}">
      </div>
    </div>

    <div class="row mb-3">
      <label for="inputEmail3" class="col-sm-2 col-form-label">Percent</label>
      <div class="col-sm-10">
        <input type="number" name="percent" class="form-control"
               min="0" max="100"
               title="Please enter a percent value between 0 and 100."
               value="${result.rows[0].percent}">
      </div>
    </div>

    <button type="submit" class="btn btn-primary">Edit</button>
  </form>

  <script>
    function submit(card_number) {
      $.ajax({
        url: '/customer',
        method: 'get',
        dataType: 'html',
        data: {
          card_number: card_number,
          action: "edit",
          cust_surname: $('input[name="cust_surname"]').val().trim(),
          cust_name: $('input[name="cust_name"]').val().trim(),
          cust_patronymic: $('input[name="cust_patronymic"]').val().trim(),
          phone_number: $('input[name="phone_number"]').val().trim(),
          city: $('input[name="city"]').val().trim(),
          street: $('input[name="street"]').val().trim(),
          zip_code: $('input[name="zip_code"]').val().trim(),
          percent: $('input[name="percent"]').val().trim(),
        },
        success: function (data) {
          console.log(data);
          alert("The customer card was updated successfully!");
          window.location.replace("http://localhost:8080/customer_card.jsp");
        },
        error: function (jqXHR, exception) {
          alert("Could not update customer card: " + jqXHR.responseText);
          console.log(exception);
          console.log(jqXHR);
        }
      });

    }
  </script>
</div>
<jsp:include page="footer.jsp" />
