package ais.ais;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.sql.*;
import java.util.Random;


@WebServlet(name = "StoreProducts", value = "/store_product")
public class StoreProducts extends HttpServlet {
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
            if (action == null)
                action = "list";
            if (action.equals("list"))
                list(request, response);
            if (action.equals("get"))
                get(request, response);
            if (action.equals("edit"))
                edit(request, response);
            if (action.equals("delete"))
                delete(request, response);
            if (action.equals("add"))
                add(request, response);
            if (action.equals("add_promotional"))
                add_promotional(request, response);
            if (action.equals("del_promotional"))
                del_promotional(request, response);

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
        String stat = "UPDATE Store_product SET products_number = ?, selling_price = ? WHERE UPC = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setInt(1, Integer.parseInt(request.getParameter("products_number")));
        ps.setDouble(2, Double.parseDouble(request.getParameter("selling_price")));
        ps.setString(3, request.getParameter("UPC"));
        PreparedStatement get_upc_prom = connection.prepareStatement("SELECT UPC_prom FROM store_product WHERE UPC = ?");
        get_upc_prom.setString(1, request.getParameter("UPC"));
        try {
            ResultSet prom = get_upc_prom.executeQuery();
            prom.next();
            String promotionalUPC = prom.getString("UPC_prom");

            ps.execute();
            String stat_prom = "UPDATE Store_product SET products_number = ?, selling_price = ? WHERE UPC = ?";
            PreparedStatement ps_prom = connection.prepareStatement(stat_prom);
            ps_prom.setInt(1, Integer.parseInt(request.getParameter("products_number")));
            ps_prom.setDouble(2, Double.parseDouble(request.getParameter("selling_price")) * 0.8);
            ps_prom.setString(3, promotionalUPC);
            try {

                ps_prom.execute();
                response.setStatus(200);
            } catch (Exception e) {
                System.out.println("====================" + e);
                PrintWriter out = response.getWriter();
                out.print("Cannot update promotional Store product, please, enter valid information!");
                response.setStatus(500);
            }

        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot update Store product, please, enter valid information!");
            response.setStatus(500);
        }

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "DELETE FROM Store_product WHERE UPC = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("UPC"));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println(e);
            PrintWriter out = response.getWriter();
            out.print("Cannot delete store product, connected to the group");
            response.setStatus(500);
        }

    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "INSERT INTO Store_product (UPC, id_product, selling_price, products_number, promotional_product) VALUES(?, ?, ?, ?, false)";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("UPC"));
        ps.setInt(2, Integer.parseInt(request.getParameter("id_product")));
        ps.setDouble(3, Double.parseDouble(request.getParameter("selling_price")));
        ps.setInt(4, Integer.parseInt(request.getParameter("products_number")));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print("Cannot add store product");
            response.setStatus(500);
        }

    }
    private void add_promotional(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        PreparedStatement ps = connection.prepareStatement("SELECT * FROM Store_product WHERE UPC=?");
        ps.setString(1,request.getParameter("UPC"));
        try {
            ResultSet rs = ps.executeQuery();
            rs.next();
            String stat = "INSERT INTO Store_product (UPC, id_product, selling_price, products_number, promotional_product) VALUES(?, ?, ?, ?, true)";
            String random_upc = getRandomUPC();
            PreparedStatement insert_s = connection.prepareStatement(stat);
            insert_s.setString(1, random_upc);
            insert_s.setInt(2, rs.getInt("id_product"));
            insert_s.setDouble(3, rs.getDouble("selling_price") * 0.8);
            insert_s.setInt(4, rs.getInt("products_number"));
            insert_s.execute();
            PreparedStatement update_s = connection.prepareStatement("UPDATE Store_product SET UPC_prom=? WHERE UPC=?");
            update_s.setString(1, random_upc);
            update_s.setString(2, request.getParameter("UPC"));
            update_s.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println(e);
            PrintWriter out = response.getWriter();
            out.print("Cannot add store product");
            response.setStatus(500);
        }

    }
    String getRandomUPC() {
        String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < 12) { // length of the random string.
            int index = (int) (rnd.nextFloat() * SALTCHARS.length());
            salt.append(SALTCHARS.charAt(index));
        }
        String saltStr = salt.toString();
        return saltStr;

    }
    private void del_promotional(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        PreparedStatement ps = connection.prepareStatement("UPDATE Store_product SET upc_prom=NULL WHERE UPC=?");
        ps.setString(1,request.getParameter("UPC"));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println(e);
            PrintWriter out = response.getWriter();
            out.print("Cannot add store product");
            response.setStatus(500);
        }

    }

}