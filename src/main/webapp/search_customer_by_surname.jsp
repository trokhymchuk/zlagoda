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
  SELECT * from Customer_Card WHERE cust_surname LIKE '<%= request.getParameter("surname")%>%' ORDER BY cust_surname;
</sql:query>

<div class="container">
  <form id="searchForm">
    <div class="input-group mb-3">
      <input type="text" class="form-control" placeholder="Enter surname of the customer" name="surname" id="surname" value="">
      <button type="button" class="btn btn-outline-secondary" onclick="search()">Search</button>
    </div>
  </form>
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
      <th scope="col">Edit</th>
      <th scope="col">Delete</th>

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
        <td>
          <a class="btn btn-primary" href="edit_customer_card.jsp?card_number=${row.card_number}"><i
                  class="fa-solid fa-pen-to-square"></i></a>
        </td>
        <td>
          <button onclick="remove_customer_card('${row.card_number}')" type="button" class="btn btn-danger"><i
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
  function remove_customer_card(card_number) {
    $.ajax({
      url: '/customer',
      method: 'get',
      dataType: 'html',
      data: {card_number: card_number, action: "delete"},
      success: function (data) {
        console.log(data);
        alert("The customer card was deleted successfully!");
        window.location.replace("http://localhost:8080/customer_card.jsp");
      },
      error: function (jqXHR, exception) {
        alert("Could not delete customer card: " + jqXHR.responseText);
        //console.log(exception);
        //alert(jqXHR.text);
      }
    });

  }

  function search() {
    var surname = document.getElementById("surname").value;
    window.location.href = 'search_customer_by_surname.jsp?surname=' + surname;
  }
</script>

<jsp:include page="footer.jsp" />
