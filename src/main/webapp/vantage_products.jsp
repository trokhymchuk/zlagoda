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
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">
  SELECT P.id_product, P.product_name, SUM(S.selling_price * S.product_number) AS total_revenue
  FROM Product P
  INNER JOIN Store_Product SP ON P.id_product = SP.id_product
  INNER JOIN Sale S ON SP.UPC = S.UPC
  GROUP BY P.id_product, P.product_name
  ORDER BY total_revenue DESC;

</sql:query>

<div class="container">
  <div class="row mb-3">

    <label for="startDate" class="col-sm-2 col-form-label">Start Date</label>
    <div class="col-sm-4">
      <input type="date" id="startDate" name="startDate" class="form-control">
    </div>
    <label for="endDate" class="col-sm-2 col-form-label">End Date (exclusive)</label>
    <div class="col-sm-4">
      <input type="date" id="endDate" name="endDate" class="form-control">
    </div>

    <div class="col-sm-10">
      <button type="button" class="btn btn-outline-secondary" onclick="update()">Search</button>
    </div>


  </div>

  <table class="table">
    <thead>
    <tr>
      <th scope="col">Product id</th>
      <th scope="col">Product name</th>
      <th scope="col">Total revenue</th>


    </tr>
    </thead>
    <tbody id="recieptsTbody">
    </tbody>
  </table>

</div>



<script>


  function update() {
    $.ajax({
      url: '/receipt',
      method: 'get',
      dataType: 'html',
      data: {
        startDate: $('input[name="startDate"]').val().trim(),
        endDate: $('input[name="endDate"]').val().trim(),
        action: "getMostProfitableProducts"
      },
      success: function (data) {
        $("#recieptsTbody").html(data);
        getTotalSum();
      },
      error: function (jqXHR, exception) {
        console.log(jqXHR);
        console.log(exception);

        //   alert("Please, reload page!");
      }
    });
  }

  update();
</script>

<jsp:include page="footer.jsp"/>