package ais.ais;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.time.LocalDate;
import java.time.Period;

@WebServlet(name = "Employee", value = "/employee")
public class Employee extends HttpServlet {
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
            if (action.equals("listCashiersSortedBySurname"))
                listCashiersSortedBySurname(request, response);
            if (action.equals("passreset"))
                passreset(request, response);

        } catch (Exception e) {
            response.setStatus(504);
        }

    }
    private void passreset(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        System.out.println("Pass: " + request.getParameter("password"));
        String stat = "UPDATE Employee SET  password=sha256('" + request.getParameter("password") + "') WHERE id_employee = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("id"));
        System.out.println("Stat: " + ps.toString());
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot update password");
            response.setStatus(500);
        }

    }

    public void destroy() {
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery("SELECT * from Employee");
        String resp = "";
        while (rs.next()) {
            String id = rs.getString("id_employee");
            String employee_surname = rs.getString("employee_surname");
            String employee_name = rs.getString("employee_name");
            String patronymic = rs.getString("patronymic");
            String role = rs.getString("role");
            Double salary = rs.getDouble("salary");
            Date dateOfBirth = rs.getDate("characteristics");
            Date dateOfStart = rs.getDate("employee_surname");
            String phoneNumber = rs.getString("phoneNumber");
            String city = rs.getString("city");
            String street = rs.getString("street");
            String zipCode = rs.getString("zipCode");
            resp += id + " " + employee_surname + " " + employee_name + " " + patronymic + " " + role +
                    " " + salary + " " + dateOfBirth + " " + dateOfStart + " " + phoneNumber +
                    " " + city + " " + street + " " + zipCode + "<a href='http://localhost:8080/ais_war_exploded/product?action=get&id=" + id + "'>view</a> <br>";
        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println(resp);
        out.println("</body></html>");
    }

    private void get(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        String id_param = request.getParameter("id");
        ResultSet rs = statement.executeQuery("SELECT * from Employee WHERE id_product=" + id_param);
        String resp = "";
        while (rs.next()) {
            String id = rs.getString("id_employee");
            String employee_surname = rs.getString("employee_surname");
            String employee_name = rs.getString("employee_name");
            String patronymic = rs.getString("patronymic");
            String role = rs.getString("role");
            Double salary = rs.getDouble("salary");
            Date dateOfBirth = rs.getDate("characteristics");
            Date dateOfStart = rs.getDate("employee_surname");
            String phoneNumber = rs.getString("phoneNumber");
            String city = rs.getString("city");
            String street = rs.getString("street");
            String zipCode = rs.getString("zipCode");
            resp += id + " " + employee_surname + " " + employee_name + " " + patronymic + " " + role +
                    " " + salary + " " + dateOfBirth + " " + dateOfStart + " " + phoneNumber +
                    " " + city + " " + street + " " + zipCode + "<br>";

        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<pre>" + resp + "</pre>");
        out.println("</body></html>");

    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "UPDATE Employee SET empl_surname = ?, empl_name = ?, empl_patronymic = ?, empl_role = ?, salary = ?, date_of_birth = ?, date_of_start = ?, phone_number = ?, city = ?, street = ?, zip_code = ?  WHERE id_employee = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("surname"));
        ps.setString(2, request.getParameter("name"));
        ps.setString(3, request.getParameter("patronymic"));
        ps.setString(4, request.getParameter("role"));
        ps.setDouble(5, Double.valueOf(request.getParameter("salary")));
        ps.setDate(6, Date.valueOf(request.getParameter("date_of_birth")));
        ps.setDate(7, Date.valueOf(request.getParameter("date_of_start")));
        LocalDate dateOfBirth = LocalDate.parse(request.getParameter("date_of_birth"));
        LocalDate dateOfStart = LocalDate.parse(request.getParameter("date_of_start"));
        LocalDate currentDate = LocalDate.now();
        Period ageDifference = Period.between(dateOfBirth, currentDate);
        Period dateDifference = Period.between(dateOfBirth, dateOfStart);
        if (ageDifference.getYears()< 18) {
            PrintWriter out = response.getWriter();
            out.print("person is too young");
            response.setStatus(500);
            return;
        }
        if (dateDifference.getYears()< 18) {
            PrintWriter out = response.getWriter();
            out.print("person is not of legal age on the date of starting work");
            response.setStatus(500);
            return;
        }
        ps.setString(8, request.getParameter("phone_number"));
        ps.setString(9, request.getParameter("city"));
        ps.setString(10, request.getParameter("street"));
        ps.setString(11, request.getParameter("zip_code"));
        ps.setString(12, request.getParameter("id"));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot update product, connected to the group");
            response.setStatus(500);
        }

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "DELETE FROM Employee WHERE id_employee = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("id"));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println(e);
            PrintWriter out = response.getWriter();
            out.print("Cannot delete employee");
            response.setStatus(500);
        }

    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "INSERT INTO Employee (id_employee, empl_surname, empl_name, empl_patronymic, empl_role, salary, date_of_birth, date_of_start, phone_number, city, street, zip_code, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, sha256('" + request.getParameter("password") +"'))";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setString(1, request.getParameter("id"));
        ps.setString(2, request.getParameter("surname"));
        ps.setString(3, request.getParameter("name"));
        ps.setString(4, request.getParameter("patronymic"));
        ps.setString(5, request.getParameter("role"));
        ps.setDouble(6, Double.valueOf(request.getParameter("salary")));
        ps.setDate(7, Date.valueOf(request.getParameter("date_of_birth")));
        LocalDate dateOfBirth = LocalDate.parse(request.getParameter("date_of_birth"));
        LocalDate dateOfStart = LocalDate.parse(request.getParameter("date_of_start"));
        LocalDate currentDate = LocalDate.now();
        Period ageDifference = Period.between(dateOfBirth, currentDate);
        Period dateDifference = Period.between(dateOfBirth, dateOfStart);
        if (ageDifference.getYears()< 18) {
            PrintWriter out = response.getWriter();
            out.print("person is too young");
            response.setStatus(500);
            return;
        }
        if (dateDifference.getYears()< 18) {
            PrintWriter out = response.getWriter();
            out.print("person is not of legal age on the date of starting work");
            response.setStatus(500);
            return;
        }
        ps.setDate(8, Date.valueOf(request.getParameter("date_of_start")));
        ps.setString(9, request.getParameter("phone_number"));
        ps.setString(10, request.getParameter("city"));
        ps.setString(11, request.getParameter("street"));
        ps.setString(12, request.getParameter("zip_code"));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("============" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot add employee");
            response.setStatus(500);
        }
    }

    //6
    private void listCashiersSortedBySurname(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery("SELECT * FROM Employee WHERE empl_role = 'Cashier' ORDER BY empl_surname ASC");
        StringBuilder resp = new StringBuilder();
        while (rs.next()) {
            String id = rs.getString("id_employee");
            String employee_surname = rs.getString("employee_surname");
            String employee_name = rs.getString("employee_name");
            String patronymic = rs.getString("patronymic");
            String role = rs.getString("role");
            Double salary = rs.getDouble("salary");
            Date dateOfBirth = rs.getDate("date_of_birth");
            Date dateOfStart = rs.getDate("date_of_start");
            String phoneNumber = rs.getString("phoneNumber");
            String city = rs.getString("city");
            String street = rs.getString("street");
            String zipCode = rs.getString("zipCode");
            resp.append(id).append(" ").append(employee_surname).append(" ").append(employee_name).append(" ")
                    .append(patronymic).append(" ").append(role).append(" ").append(salary).append(" ")
                    .append(dateOfBirth).append(" ").append(dateOfStart).append(" ").append(phoneNumber).append(" ")
                    .append(city).append(" ").append(street).append(" ").append(zipCode).append("<br>");
        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>Cashiers</h1>");
        out.println("<div>" + resp.toString() + "</div>");
        out.println("</body></html>");
    }

}
