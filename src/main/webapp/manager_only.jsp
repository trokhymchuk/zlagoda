<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<c:if test="${cookie['role'] == null || !cookie['role'].getValue().equals('Manager')}">
    <%
        String redirectURLMainPage = "http://localhost:8080/index.jsp";
        response.sendRedirect(redirectURLMainPage);
    %>
</c:if>
