<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<jsp:include page="header.jsp" />

<jsp:include page="footer.jsp" />

<c:if test="${!(cookie['role'].getValue().equals('Manager') || cookie['role'].getValue().equals('Cashier'))}">
    <%
            String redirectURL = "http://localhost:8080/login.jsp";
            response.sendRedirect(redirectURL);
    %>
</c:if>
