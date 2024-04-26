package ais.ais;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.sql.*;


@WebServlet(name = "helloServlet", value = "/product")
public class HelloServlet extends HttpServlet {
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
            if (action.equals("listPromotional"))
                listPromotional(request, response);


        } catch (Exception e) {
            response.setStatus(504);
        }

    }

    public void destroy() {
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        try {

            String stat = "SELECT * FROM Product INNER JOIN Category ON Product.category_number=Category.category_number";
        PreparedStatement ps;
        if(!request.getParameter("category").equals("*")) {
            stat += " WHERE Product.category_number=? ORDER BY product_name";

            ps = connection.prepareStatement(stat);
            ps.setInt(1, Integer.parseInt(request.getParameter("category")));
        } else {
            stat += " ORDER BY product_name";
            ps = connection.prepareStatement(stat);
        }
        ResultSet rs = ps.executeQuery();
        String format = """
            <tr>
                <th scope="row">%s</th>
                <td>%s</td>
                <td>%s</td>
                                <td>%s</td>
                <td class="manager">
                    <a class="btn btn-primary" href="edit_product.jsp?id=%s"><i
                            class="fa-solid fa-pen-to-square"></i></a>
                </td>
                <td class="manager">
                    <button onclick="remove_product('%s')" type="button" class="btn btn-danger"><i
                            class="fa-solid fa-trash"
                    ></i>
                    </button>

                </td>
            </tr>


        """;
        String resp = "";
        while (rs.next()) {
            resp += String.format(format,rs.getString("id_product"), rs.getString("product_name"), rs.getString("category_name"),  rs.getString("characteristics"), rs.getString("id_product"), rs.getString("id_product"));
        }
        PrintWriter out = response.getWriter();
        out.println(resp);
        response.setStatus(200);
        }  catch(Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot update product, connected to the group");
            response.setStatus(500);
        }
    }

    private void get(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        try {
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

        }  catch(Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot update product, connected to the group");
            response.setStatus(500);

        }
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
            //response.sendRedirect("/products.jsp");
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println("====================" + e);
            PrintWriter out = response.getWriter();
            out.print("Cannot update product, connected to the group");
            response.setStatus(500);
        }

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String stat = "DELETE FROM Product WHERE id_product = ?";
        PreparedStatement ps = connection.prepareStatement(stat);
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        try {
            ps.execute();
            response.setStatus(200);
        } catch (Exception e) {
            System.out.println(e);
            PrintWriter out = response.getWriter();
            out.print("Cannot delete product, connected to the group");
            response.setStatus(500);
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
            response.setStatus(200);
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print("Cannot add product, connected to the group");
            response.setStatus(500);

        }

    }

    private void listPromotional(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String promotionStatus = request.getParameter("promotionStatus");
        String sortCriteria = request.getParameter("sortCriteria");

        // Determine the sorting column based on the sortCriteria parameter
        String orderBy = "productName".equals(sortCriteria) ? "Product.product_name" : "Store_product.products_number";


        String query = "SELECT Product.product_name, Store_product.products_number, Store_product.selling_price, Product.characteristics, Category.category_name " +
                "FROM Store_product " +
                "INNER JOIN Product ON Store_product.id_product = Product.id_product " +
                "INNER JOIN Category ON Product.category_number = Category.category_number " +
                "WHERE promotional_product = " + promotionStatus + " " +
                "ORDER BY " + orderBy;

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            StringBuilder resp = new StringBuilder("<table id='resultsTable'>");
            // Create headers to match the sorting criteria
            resp.append("<tr><th>Product name</th><th>Number of units</th><th>Selling price</th><th>Characteristics</th><th>Category</th></tr>");
            while (rs.next()) {
                resp.append(String.format("<tr><td>%s</td><td>%d</td><td>%.2f</td><td>%s</td><td>%s</td></tr>",
                        rs.getString("product_name"), rs.getInt("products_number"), rs.getDouble("selling_price"),
                        rs.getString("characteristics"), rs.getString("category_name")));
            }
            resp.append("</table>");
            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println(resp.toString());
            out.println("</body></html>");
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            response.setStatus(500);
            PrintWriter out = response.getWriter();
            out.println("<html><body>Error retrieving data: " + e.getMessage() + "</body></html>");
        }
    }
}
