package ais.ais;

import java.io.*;
import java.sql.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet(name = "CustomerCard", value = "/customer")
public class CustomerCard extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/ais";
    static final String USER = DB.username;;
    static final String PASS = DB.password;;
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
            connection = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (SQLException e) {
            System.out.println("Connection Failed");
            e.printStackTrace();
            return;
        }

        if (connection != null) {
            System.out.println("You successfully connected to the database now");
        } else {
            System.out.println("Failed to make a connection to the database");
        }
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

        } catch (Exception e) {
            response.setStatus(504);
        }
    }

    public void destroy() {
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery("SELECT * FROM Customer_Card");
        String resp = "";
        while (rs.next()) {
            String card_number = rs.getString("card_number");
            String cust_surname = rs.getString("cust_surname");
            String cust_name = rs.getString("cust_name");
            String cust_patronymic = rs.getString("cust_patronymic");
            String phone_number = rs.getString("phone_number");
            String city = rs.getString("city");
            String street = rs.getString("street");
            String zip_code = rs.getString("zip_code");
            int percent = rs.getInt("percent");
            resp += card_number + " " + cust_surname + " " + cust_name + " " + cust_patronymic + " " + phone_number +
                    " " + city + " " + street + " " + zip_code + " " + percent + "<br>";
        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println(resp);
        out.println("</body></html>");
    }

    private void get(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        String card_number_param = request.getParameter("card_number");
        ResultSet rs = statement.executeQuery("SELECT * FROM Customer_Card WHERE card_number = '" + card_number_param + "'");
        String resp = "";
        while (rs.next()) {
            String card_number = rs.getString("card_number");
            String cust_surname = rs.getString("cust_surname");
            String cust_name = rs.getString("cust_name");
            String cust_patronymic = rs.getString("cust_patronymic");
            String phone_number = rs.getString("phone_number");
            String city = rs.getString("city");
            String street = rs.getString("street");
            String zip_code = rs.getString("zip_code");
            int percent = rs.getInt("percent");
            resp += card_number + " " + cust_surname + " " + cust_name + " " + cust_patronymic + " " + phone_number +
                    " " + city + " " + street + " " + zip_code + " " + percent + "<br>";
        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<pre>" + resp + "</pre>");
        out.println("</body></html>");
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        int percent = Integer.parseInt(request.getParameter("percent"));
        if (percent < 0 || percent > 100) {
            response.getWriter().print("Percent must be between 0 and 100");
            response.setStatus(400);
            return;
        }
        String custSurname = request.getParameter("cust_surname");
        String custName = request.getParameter("cust_name");
        if (custSurname.length() > 50 || custName.length() > 50) {
            response.getWriter().print("Surname and Name must be 50 characters or less.");
            response.setStatus(400);
            return;
        }
        String zipCode = request.getParameter("zip_code");
        if (zipCode.length() > 9) {
            response.getWriter().print("Zip code must be 9 characters or less.");
            response.setStatus(400);
            return;
        }
        String stat = "UPDATE Customer_Card SET cust_surname = ?, cust_name = ?, cust_patronymic = ?, phone_number = ?, city = ?, street = ?, zip_code = ?, percent = ? WHERE card_number = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("cust_surname"));
        ps.setString(2, request.getParameter("cust_name"));
        ps.setString(3, request.getParameter("cust_patronymic"));
        ps.setString(4, request.getParameter("phone_number"));
        ps.setString(5, request.getParameter("city"));
        ps.setString(6, request.getParameter("street"));
        ps.setString(7, request.getParameter("zip_code"));
        ps.setInt(8, Integer.parseInt(request.getParameter("percent")));
        ps.setString(9, request.getParameter("card_number"));
        try {
            ps.executeUpdate();
            response.setStatus(200);
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print("Cannot update customer card");
            response.setStatus(500);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "DELETE FROM Customer_Card WHERE card_number = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("card_number"));
        try {
            ps.executeUpdate();
            response.setStatus(200);
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print("Cannot delete customer card");
            response.setStatus(500);
        }
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        int percent = Integer.parseInt(request.getParameter("percent"));
        if (percent < 0 || percent > 100) {
            response.getWriter().print("Percent must be between 0 and 100");
            response.setStatus(400);
            return;
        }
        String custSurname = request.getParameter("cust_surname");
        String custName = request.getParameter("cust_name");
        if (custSurname.length() > 50 || custName.length() > 50) {
            response.getWriter().print("Surname and Name must be 50 characters or less.");
            response.setStatus(400);
            return;
        }
        String zipCode = request.getParameter("zip_code");
        if (zipCode.length() > 9) {
            response.getWriter().print("Zip code must be 9 characters or less.");
            response.setStatus(400);
            return;
        }
        String stat = "INSERT INTO Customer_Card (card_number, cust_surname, cust_name, cust_patronymic, phone_number, city, street, zip_code, percent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("card_number"));
        ps.setString(2, request.getParameter("cust_surname"));
        ps.setString(3, request.getParameter("cust_name"));
        ps.setString(4, request.getParameter("cust_patronymic"));
        ps.setString(5, request.getParameter("phone_number"));
        ps.setString(6, request.getParameter("city"));
        ps.setString(7, request.getParameter("street"));
        ps.setString(8, request.getParameter("zip_code"));
        ps.setInt(9, Integer.parseInt(request.getParameter("percent")));
        try {
            ps.executeUpdate();
            response.setStatus(200);
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print("Cannot add customer card");
            response.setStatus(500);
        }
    }
}
