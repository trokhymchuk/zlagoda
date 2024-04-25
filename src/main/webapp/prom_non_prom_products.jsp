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
  SELECT * from Store_product ORDER BY products_number, promotional_product ASC;
</sql:query>
<div class="container">


  <div id="result">
  </div>


  <div class="header">
    <h4 style="text-align:center;">Find information about prom/non-prom products</h4>
  </div>

  <div class="input-group mb-3">
    <select id="promotionStatus" name="promotionStatus" class="form-select">
      <option value="true">Promotional products</option>
      <option value="false">Non-promotional products</option>
    </select>
    <select id="sortCriteria" name="sortCriteria" class="form-select">
      <option value="productName">Sort by name</option>
      <option value="productsNumber">Sort by number of units</option>
    </select>
    <button type="button" class="btn btn-outline-secondary" onclick="update()">Search</button>
  </div>

  <div id="searchResults"></div>
</div>
<script>

  function update() {
    const promoStatus = document.getElementById('promotionStatus').value;
    const sortCriteria = document.getElementById('sortCriteria').value;

    $.ajax({
      url: '/product',
      method: 'get',
      dataType: 'html',
      data: {promotionStatus: promoStatus, sortCriteria: sortCriteria, action: "listPromotional"},
      success: function (data) {
        $("#searchResults").html(data);
      },
      error: function (jqXHR, exception) {
        alert("Error fetching products: " + jqXHR.responseText);
      }
    });
  }

</script>


<jsp:include page="footer.jsp"/>
