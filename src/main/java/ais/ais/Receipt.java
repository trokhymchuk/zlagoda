package ais.ais;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Random;

@WebServlet(name = "Receipt", value = "/receipt")
public class Receipt extends HttpServlet {
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/ais";
    static final String USER = DB.username;//"postgres";
    static final String PASS = DB.password;//"admin";
    Connection connection;
    private String message;

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
            if (action == null) action = "list";
            if (action.equals("list")) list(request, response);
            if (action.equals("add")) add(request, response);
            if (action.equals("delete")) delete(request, response);
            if (action.equals("getTotalSum")) getTotalSum(request, response);
            if (action.equals("getMostProfitableProducts")) getMostProfitableProducts(request, response);
        } catch (Exception e) {
            System.out.println("===========================" + e);
            response.setStatus(504);
        }

    }

    public void destroy() {
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        try {
            String form = """
                     <tr>
                                    <th scope="row">%s</th>
                                    <td>%s %c. %s</td>
                                    <td>%s %s %s</td>
                                    <td>%s</td>
                                    <td style="width: 300px;">
                                    <details>
                                    
                                    
                                     <summary>Products</summary>
                                    
                                    
                                     %s
                                    
                                    
                                    </details>
                                    
                                    </td>
                                    <td>%s</td>
                                    <td>%s</td>
                                    <td>
                                        <button onclick="remove('%s')" type="button" class="btn btn-danger"><i
                                                class="fa-solid fa-trash"
                                        ></i>
                                        </button>
                                    
                                    </td>
                                </tr>
                    """;
            String getChecks = "SELECT * FROM checktable INNER JOIN Employee ON checktable.id_employee=Employee.id_employee LEFT JOIN customer_card ON checktable.card_number = customer_card.card_number  ";
            if (!request.getParameter("cashier").equals("*")) {
                getChecks += " WHERE checktable.id_employee='" + request.getParameter("cashier") + "' ";

            }
            if (!request.getParameter("startDate").isEmpty()) {
                if (!request.getParameter("cashier").equals("*")) getChecks += " AND ";
                else getChecks += " WHERE ";

                getChecks += " print_date>='" + request.getParameter("startDate") + "' ";
            }
            if (!request.getParameter("endDate").isEmpty()) {
                if (request.getParameter("cashier").equals("*") && request.getParameter("startDate").isEmpty()) {
                    getChecks += " WHERE ";
                } else getChecks += " AND ";

                getChecks += " print_date< '" + request.getParameter("endDate") + "' ";
            }
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(getChecks);
            String res = "";
            PrintWriter out = response.getWriter();
            while (rs.next()) {
                String check_n = rs.getString("check_number");
                String product_list = "SELECT * FROM Sale INNER JOIN Store_product ON Sale.UPC=Store_product.UPC INNER JOIN Product ON Store_product.id_product=Product.id_product WHERE check_number=?";
                PreparedStatement products = connection.prepareStatement(product_list);
                products.setString(1, check_n);
                ResultSet products_get = products.executeQuery();
                String products_str = "";
                while (products_get.next()) {
                    products_str += products_get.getString("product_name") + ": " + products_get.getString("selling_price") + "$ x " + products_get.getString("product_number") + "<br>";
                }
                out.println(String.format(form, rs.getString("check_number"), rs.getString("empl_name"), rs.getString("empl_patronymic").charAt(0), rs.getString("empl_surname"), (rs.getString("cust_name") != null) ? rs.getString("cust_name") : "", (rs.getString("cust_patronymic") != null) ? rs.getString("cust_patronymic") : "", (rs.getString("cust_surname") != null) ? rs.getString("cust_surname") : "", rs.getString("print_date"), products_str, rs.getString("sum_total"), rs.getString("vat"), rs.getString("check_number")));
            }
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("=================" + e);
            response.setStatus(500);
        }

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
        String check_n = getRandimCheckNumber();
        ps.setString(1, check_n);
        ps.setString(2, request.getParameter("id_employee"));
        if (request.getParameter("card_number").equals("0")) ps.setString(3, null);
        else ps.setString(3, request.getParameter("card_number"));
        ps.setDouble(4, Double.parseDouble(request.getParameter("sum_total")));
        ps.setDouble(5, Double.parseDouble(request.getParameter("sum_total")) * 0.2);
        try {
            ps.execute();
            for (String key : jo.keySet()) {
                PreparedStatement sale_statement = connection.prepareStatement("INSERT INTO Sale (UPC, check_number, product_number, selling_price) VALUES(?, ?, ?, ?)");
                PreparedStatement decrement = connection.prepareStatement("UPDATE Store_product SET products_number=((SELECT products_number FROM Store_product WHERE UPC=?) - ?) WHERE UPC=?");
                decrement.setString(1, key);
                decrement.setInt(2, jo.getJSONObject(key).getInt("product_number"));
                decrement.setString(3, key);
                sale_statement.setString(1, key);
                sale_statement.setString(2, check_n);
                sale_statement.setInt(3, jo.getJSONObject(key).getInt("product_number"));
                sale_statement.setDouble(4, jo.getJSONObject(key).getDouble("selling_price"));
                sale_statement.execute();
                decrement.execute();

            }
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot add category");
            response.setStatus(500);
        }

    }

    private void getTotalSum(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        double totalSum = 0;

        try {
            String sql = "SELECT SUM(sum_total) FROM checktable WHERE print_date BETWEEN ? AND ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setDate(1, Date.valueOf(request.getParameter("startDate")));
            statement.setDate(2, Date.valueOf(request.getParameter("endDate")));
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                totalSum = resultSet.getDouble(1);
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"totalSum\": " + totalSum + "}");
            out.flush();
            response.setStatus(200);
        } catch (SQLException e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot get SUM");
            response.setStatus(500);
        }
    }


    private void getMostProfitableProducts(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        java.sql.Date startDate = request.getParameter("startDate").isEmpty() ? null : java.sql.Date.valueOf(request.getParameter("startDate"));
        java.sql.Date endDate = request.getParameter("endDate").isEmpty() ? null : java.sql.Date.valueOf(request.getParameter("endDate"));

        String query = """
        SELECT 
            P.id_product,
            P.product_name,
            SUM(S.selling_price * S.product_number) AS total_revenue
        FROM 
            Product P
        INNER JOIN 
            Store_Product SP ON P.id_product = SP.id_product
        INNER JOIN 
            Sale S ON SP.UPC = S.UPC
        INNER JOIN 
            CheckTable C ON S.check_number = C.check_number
        %s
        GROUP BY 
            P.id_product, P.product_name
        ORDER BY 
            total_revenue DESC;
        """;

        String dateFilter = "";
        if (startDate != null && endDate != null) {
            dateFilter = "WHERE C.print_date BETWEEN ? AND ?";
        } else if (startDate != null) {
            dateFilter = "WHERE C.print_date >= ?";
        } else if (endDate != null) {
            dateFilter = "WHERE C.print_date <= ?";
        }

        query = String.format(query, dateFilter);

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;
            if (startDate != null) ps.setDate(paramIndex++, startDate);
            if (endDate != null) ps.setDate(paramIndex++, endDate);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id_product");
                String name = rs.getString("product_name");
                double revenue = rs.getDouble("total_revenue");
                out.println(String.format("<tr><td>%d</td><td>%s</td><td>%.2f</td></tr>", id, name, revenue));
            }
            response.setStatus(200);
        } catch (SQLException e) {
            out.println("Error fetching data: " + e.getMessage());
            response.setStatus(500);
        }
    }

}