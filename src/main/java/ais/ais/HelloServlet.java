package ais.ais;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.sql.*;


@WebServlet(name = "helloServlet", value = "/product")
public class HelloServlet extends HttpServlet {
    private String message;
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/ais";
    static final String USER = "postgres";
    static final String PASS = "admin";
    Connection connection;

    public void init() {

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("PostgreSQL JDBC Driver is not found. Include it in your library path ");
            e.printStackTrace();
            return;
        }

        System.out.println("PostgreSQL JDBC Driver successfully connected");
        connection = null;

        try {
            connection = DriverManager
                    .getConnection(DB_URL, USER, PASS);

        } catch (SQLException e) {
            System.out.println("Connection Failed");
            e.printStackTrace();
            return;
        }

        if (connection != null) {
            System.out.println("You successfully connected to database now");
        } else {
            System.out.println("Failed to make connection to database");
        }


        message = "";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        response.setContentType("text/html");

        try {
            if(action == null)
                action = "list";
            if(action.equals("list"))
                list(request, response);
            if(action.equals("get"))
                get(request, response);
            if(action.equals("edit"))
                edit(request, response);
            if(action.equals("delete"))
                delete(request, response);
            if(action.equals("add"))
                add(request, response);


        } catch (Exception e) {
            response.setStatus(504);
        }

   }

    public void destroy() {
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery("SELECT * from Product");
        String resp = "";
        while (rs.next()) {
            int id = rs.getInt("id_product");
            String product_name = rs.getString("product_name");
            String characteristics = rs.getString("characteristics");
            resp += id + " " + product_name + " " + characteristics + "<a href='http://localhost:8080/ais_war_exploded/product?action=get&id=" + id + "'>view</a> <br>";
        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println(resp);
//        String form = "<form method=\"GET\" action=\"product\">";
//        form += "<input name='id'> <br> ";
//        form += "<input name='action' value ='get'> <br><input type='submit'>";
//        out.println(form);
        out.println("</body></html>");


    }
    private void get(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        String id_param = request.getParameter("id");
        ResultSet rs = statement.executeQuery("SELECT * from Product WHERE id_product=" + id_param);
        String resp = "";
        while (rs.next()) {
            int id = rs.getInt("id_product");
            String product_name = rs.getString("product_name");
            String characteristics = rs.getString("characteristics");
            resp += id + " " + product_name + " " + characteristics + "<br>";
        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<pre>" + resp + "</pre>");
        out.println("</body></html>");

    }
    private void edit(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "UPDATE Product SET category_number = ?, product_name = ?, characteristics = ? WHERE id_product = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setInt(1, Integer.parseInt(request.getParameter("category")));
        ps.setString(2, request.getParameter("name"));
        ps.setString(3, request.getParameter("characteristics"));
        ps.setInt(4, Integer.parseInt(request.getParameter("id")));
        try {
            ps.execute();
            response.sendRedirect("/products.jsp");
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println(e);
            out.println("</body></html>");

        }

    }
    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "DELETE FROM Product WHERE id_product = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        try {
            ps.execute();
            response.sendRedirect("/products.jsp");
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println(e);
            out.println("</body></html>");

        }

    }
    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "INSERT INTO Product (category_number, product_name, characteristics) VALUES(?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setInt(1, Integer.parseInt(request.getParameter("category")));
        ps.setString(2, request.getParameter("name"));
        ps.setString(3, request.getParameter("characteristics"));
        try {
            ps.execute();
            response.sendRedirect("/products.jsp");
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println(e);
            out.println("</body></html>");

        }

    }

}
