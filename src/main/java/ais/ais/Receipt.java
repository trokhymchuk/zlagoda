package ais.ais;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Random;

import org.json.*;

@WebServlet(name = "Receipt", value = "/receipt")
public class Receipt extends HttpServlet {
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
       System.out.println(action);
        try {
            if (action == null)
                action = "list";
            if (action.equals("list"))
                list(request, response);
            if (action.equals("add"))
                add(request, response);
            if (action.equals("delete"))
                delete(request, response);
        } catch (Exception e) {
            response.setStatus(504);
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


    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "DELETE FROM checktable WHERE check_number = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("check_number"));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println(e);
            PrintWriter out = response.getWriter();
            out.print("Cannot delete check!");
            response.setStatus(500);
        }

    }
    String getRandimCheckNumber() {
        String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < 10) { // length of the random string.
            int index = (int) (rnd.nextFloat() * SALTCHARS.length());
            salt.append(SALTCHARS.charAt(index));
        }
        String saltStr = salt.toString();
        return saltStr;

    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        JSONObject jo = new JSONObject(request.getParameter("sale_data"));
        Random r = new Random();
        String insert_check_stat = "INSERT INTO checktable (check_number, id_employee, card_number, print_date, sum_total, vat) VALUES(?, ?, ?, NOW(), ?, ?)";
        PreparedStatement ps = connection.prepareStatement(insert_check_stat);
        String check_n  = getRandimCheckNumber();
        ps.setString(1, check_n);
        ps.setString(2, request.getParameter("id_employee"));
        ps.setString(3, request.getParameter("card_number"));
        ps.setDouble(4, Double.parseDouble(request.getParameter("sum_total")));
        ps.setDouble(5, Double.parseDouble(request.getParameter("sum_total")) * 0.2);
        try {
            ps.execute();
            for(String key : jo.keySet()) {
                PreparedStatement sale_statement = connection.prepareStatement("INSERT INTO Sale (UPC, check_number, product_number, selling_price) VALUES(?, ?, ?, ?)");
                sale_statement.setString(1, key);
                sale_statement.setString(2, check_n);
                sale_statement.setInt(3, jo.getJSONObject(key).getInt("product_number"));
                sale_statement.setDouble(4, jo.getJSONObject(key).getDouble("selling_price"));
                sale_statement.execute();
            }
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot add category");
            response.setStatus(500);
        }

    }
}