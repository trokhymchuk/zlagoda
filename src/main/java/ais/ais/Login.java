package ais.ais;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Random;


@WebServlet(name = "Login", value = "/login")
public class Login extends HttpServlet {
    private String message;
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/ais";
    static final String USER = DB.username;//"postgres";
    static final String PASS = DB.password;//"admin";
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
            String stat = "SELECT * FROM employee WHERE id_employee=? ";
            PreparedStatement ps = connection.prepareStatement(stat);
            ps.setString(1, request.getParameter("id"));
            ResultSet rs = ps.executeQuery();

            PreparedStatement passwordHash = connection.prepareStatement("SELECT sha256('" + request.getParameter("password") + "')");
            ResultSet hash = passwordHash.executeQuery();
            hash.next();
            System.out.println(hash.getString(1));
            while(rs.next()) {
                System.out.println("Pass: " + rs.getString("password").trim() + "|");
                if(hash.getString(1).trim().equals(rs.getString("password").trim())) {
                    response.addCookie(new Cookie("role", rs.getString("empl_role")));
                    response.addCookie(new Cookie("empl_id", request.getParameter("id")));
                    response.setStatus(200);
                    return;
                }
                }
            response.setStatus(500);

        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            response.setStatus(500);
        }

    }

    public void destroy() {
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery("SELECT * from Category");
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


    private void edit(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "UPDATE Category SET category_name = ? WHERE category_number = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("category_name"));
        ps.setInt(2, Integer.parseInt(request.getParameter("category_number")));
        try {
            ps.execute();
        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot update category, please, enter valid information!");
            response.setStatus(500);
        }

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "DELETE FROM Category WHERE category_number = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setInt(1, Integer.parseInt(request.getParameter("category_number")));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println(e);
            PrintWriter out = response.getWriter();
            out.print("Cannot delete category, connected to the product");
            response.setStatus(500);
        }

    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Random r = new Random();
        String stat = "INSERT INTO category (category_number, category_name) VALUES(?, ?)";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setInt(1, Math.abs(r.nextInt()));
        ps.setString(2, request.getParameter("category_name"));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot add category");
            response.setStatus(500);
        }

    }
}