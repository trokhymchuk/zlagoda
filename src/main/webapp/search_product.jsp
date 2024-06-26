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
  <%--    9th  --%>
  SELECT * FROM Product INNER JOIN Category ON Product.category_number=Category.category_number WHERE product_name LIKE '<%= request.getParameter("name")%>%' ORDER BY product_name;
</sql:query>

<div class="container">
  <form id="searchForm">
    <div class="input-group mb-3">
      <input type="text" class="form-control" placeholder="Enter name" name="name" id="name">
      <button type="button" class="btn btn-outline-secondary" onclick="search()">Search</button>
    </div>
  </form>

  <table class="table">
    <thead>
    <tr>
      <th scope="col">#</th>
      <th scope="col">Name</th>
      <th scope="col">Category</th>
      <th scope="col">Characteristics</th>
      <th scope="col">Edit</th>
      <th scope="col">Delete</th>

    </tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${result.rows}">
      <tr>
        <th scope="row"><c:out value="${row.id_product}"/></th>
        <td><c:out value="${row.product_name}"/></td>
        <td><c:out value="${row.category_name}"/></td>
        <td><c:out value="${row.characteristics}"/></td>
        <td>
          <a class="btn btn-primary" href="edit_product.jsp?id=${row.id_product}">
            <i class="fa-solid fa-pen-to-square"></i>
          </a>
        </td>
        <td>
          <button onclick="remove_product('${row.id_product}')" type="button" class="btn btn-danger">
            <i class="fa-solid fa-trash"></i>
          </button>
        </td>
      </tr>
    </c:forEach>

    </tbody>
  </table>

</div>
<script>
  function remove_product(product_id) {
    $.ajax({
      url: '/product',
      method: 'get',
      dataType: 'html',
      data: {id: product_id, action: "delete"},
      success: function (data) {
        console.log(data);
        alert("The product was deleted successfully!");
        window.location.replace("http://localhost:8080/products.jsp");
      },
      error: function (jqXHR, exception) {
        alert("Could not delete product: " + jqXHR.responseText);
        //console.log(exception);
        //alert(jqXHR.text);
      }
    });

  }

  function search() {
    var name = document.getElementById("name").value;
    window.location.href = 'search_product.jsp?name=' + name;
  }

</script>


<jsp:include page="footer.jsp"/>