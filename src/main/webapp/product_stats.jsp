<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<jsp:include page="header.jsp"/>
<jsp:include page="DB.jsp"/>
<%
    String potsgres_username = (String) request.getAttribute("potsgres_username");
    String postgres_password = (String) request.getAttribute("postgres_password");
    String start_date = (String) request.getParameter("start_date");
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    if(start_date == null || start_date.isEmpty()) {
        start_date = df.format(new Date());
    }
    String end_date = (String) request.getParameter("end_date");
    if(end_date == null || end_date.isEmpty()) {
        end_date =  df.format(new Date());
    }

%>
<sql:setDataSource var="snapshot" driver="org.postgresql.Driver"
                   url="jdbc:postgresql://127.0.0.1:5432/ais"
                   user="<%=potsgres_username%>" password="<%=postgres_password%>"/>
<sql:query dataSource="${snapshot}" var="result">

    SELECT product_name, COALESCE((SELECT SUM(product_number) FROM Sale INNER JOIN Store_product ON Sale.UPC=Store_product.UPC INNER JOIN Checktable ON Sale.check_number=Checktable.check_number WHERE Store_product.id_product=Product.id_product AND print_date >= '<%=start_date%>' AND print_date < '<%=end_date%>'), 0) as sell_count FROM Product ORDER BY sell_count DESC;

</sql:query>

<div class="container">
    <form id="searchForm" action="product_stats.jsp" method="get">
        <div class="input-group mb-3">
            <input type="date" value="<%=start_date%>" class="form-control" placeholder="Start date" name="start_date" id="start_date">
        </div>
        <div class="input-group mb-3">
            <input type="date"  value="<%=end_date%>" class="form-control" placeholder="End date" name="end_date" id="end_date">
        </div>
        <button type="submit" class="btn btn-primary">Stats</button>

    </form>

    <table class="table">
        <thead>
        <tr>
            <th scope="col">Product</th>
            <th scope="col">Bought count</th>

        </tr>
        </thead>
        <tbody id="productsTable">
                <c:forEach var="row" items="${result.rows}">
                    <tr>
                        <th scope="row"><c:out value="${row.product_name}"/></th>
                        <td><c:out value="${row.sell_count}"/></td>
                    </tr>
                </c:forEach>
        </tbody>
    </table>

</div>

<jsp:include page="footer.jsp"/>