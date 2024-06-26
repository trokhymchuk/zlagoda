<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page contentType="text/html;charset=utf-8" %>

<c:choose>

    <c:when test="${cookie['role'].getValue().equals('Manager')}">
        <div class="container">
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.jsp">Злагода</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                            aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse .justify-content-center align-items-center"
                         id="navbarSupportedContent">
                        <ul class="navbar-nav m-auto mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Products
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/products.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/add_product.jsp">Add</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Store products
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/store_products.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/add_store_product.jsp">Add</a></li>
                                    <li><a class="dropdown-item" href="/product_stats.jsp">Stats</a></li>
                                        <%--                            <li><a class="dropdown-item" href="/regular_store_products.jsp">Regular</a></li>--%>
                                    <li><a class="dropdown-item" href="/prom_non_prom_products.jsp">Prom-Non-Prom</a></li>
                                    <li><a class="dropdown-item" href="/vantage_products.jsp">Vantage products</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Categories
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/categories.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/add_category.jsp">Add</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Receipts
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/reciepts.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/search_reciept.jsp">Search</a></li>
                                    <li><a class="dropdown-item" href="/add_reciept.jsp">Add</a></li>
                                    <li><a class="dropdown-item" href="/top_sales.jsp">Top Sales</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Employee
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/employee.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/add_employee.jsp">Add</a></li>
                                    <li><a class="dropdown-item" href="/cashier.jsp">Cashiers</a></li>
                                    <li><a class="dropdown-item" href="/avg_age.jsp?role=Cashier">Abg age by name</a></li>
                                    <li><a class="dropdown-item" href="/search_bad_cashier.jsp">Bad Cashiers</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Customer card
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/customer_card.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/golden_customer.jsp">List golden</a></li>
                                    <li><a class="dropdown-item" href="/add_customer_card.jsp">Add</a></li>
                                    <li><a class="dropdown-item" href="/all_category_cards.jsp">All-category purchases</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Reports
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" target=”_blank”
                                           href="/employee_report.jsp">Employees</a></li>
                                    <li><a class="dropdown-item" target=”_blank”
                                           href="/customer_report.jsp">Customers</a></li>
                                    <li><a class="dropdown-item" target=”_blank”
                                           href="/category_report.jsp">Categories</a></li>
                                    <li><a class="dropdown-item" target=”_blank” href="/product_report.jsp">Products</a>
                                    </li>
                                    <li><a class="dropdown-item" target=”_blank” href="/store_product_report.jsp">Store
                                        products</a></li>
                                    <li><a class="dropdown-item" target=”_blank” href="/receipt_report.jsp">Reciepts</a>
                                    </li>

                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link" href="/me.jsp" id="navbarDropdown" aria-expanded="false">
                                    Me
                                </a>
                            </li>

                            <li class="nav-item dropdown">
                                <a class="nav-link" href="/login.jsp" id="navbarDropdown" aria-expanded="false">
                                    Login
                                </a>
                            </li>

                        </ul>
                    </div>
                </div>
            </nav>
        </div>


    </c:when>
    <c:otherwise>
        <div class="container">
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.jsp">Злагода</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                            aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse .justify-content-center align-items-center"
                         id="navbarSupportedContent">
                        <ul class="navbar-nav m-auto mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Products
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/products.jsp">List</a></li>
                                        <%--                            <li><a class="dropdown-item" href="/add_product.jsp">Add</a></li>--%>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Store products
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/store_products.jsp">List</a></li>
                                        <%--                            <li><a class="dropdown-item" href="/add_store_product.jsp">Add</a></li>--%>
<%--                                    <li><a class="dropdown-item" href="/product_stats.jsp">Stats</a></li>--%>
                                        <%--                            <li><a class="dropdown-item" href="/regular_store_products.jsp">Regular</a></li>--%>
                                    <li><a class="dropdown-item" href="/prom_non_prom_products.jsp">Prom-Non-Prom</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Categories
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/categories.jsp">List</a></li>
                                        <%--                            <li><a class="dropdown-item" href="/add_category.jsp">Add</a></li>--%>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Receipts
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/casheir_reciepts.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/search_reciept.jsp">Search</a></li>
                                    <li><a class="dropdown-item" href="/add_reciept.jsp">Add</a></li>
                                    <li><a class="dropdown-item" href="/top_sales.jsp">Top Sales</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    Customer card
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="/customer_card.jsp">List</a></li>
                                    <li><a class="dropdown-item" href="/golden_customer.jsp">List golden</a></li>
                                    <li><a class="dropdown-item" href="/add_customer_card.jsp">Add</a></li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link" href="/me.jsp" id="navbarDropdown" aria-expanded="false">
                                    Me
                                </a>
                            </li>

                            <li class="nav-item dropdown">
                                <a class="nav-link" href="/login.jsp" id="navbarDropdown" aria-expanded="false">
                                    Login
                                </a>
                            </li>

                        </ul>
                    </div>
                </div>
            </nav>
        </div>
    </c:otherwise>
</c:choose>





