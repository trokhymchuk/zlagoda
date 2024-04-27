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
<sql:query dataSource="${snapshot}" var="result">
SELECT empl_name, EXTRACT(YEARS FROM AVG(AGE(NOW(), date_of_birth))) as age
FROM Employee
WHERE id_employee IN (SELECT id_employee
FROM Checktable
WHERE print_date > NOW() - interval '30' day)
AND empl_role='<%=request.getParameter("role")%>'
GROUP BY empl_name;
</sql:query>

<div class="container">
    <form id="searchForm" action="/avg_age.jsp" method="get">
        <div class="input-group mb-3">
            <select name="role" class="form-control">
                <option>Cashier</option>
                <option>Manager</option>
            </select>
            <button type="submit" class="btn btn-outline-secondary">Search</button>
        </div>
    </form>



    <table class="table">
        <thead>
        <tr>
            <th scope="col">Name</th>
            <th scope="col">Average age</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${result.rows}">
            <tr>
                <th scope="row"><c:out value="${row.empl_name}"/></th>
                <td><c:out value="${row.age}"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>

<jsp:include page="footer.jsp" />
