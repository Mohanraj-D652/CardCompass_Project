<%-- 
    Document   : AddTransactions
    Created on : 27 Dec 2025, 10:09:53 pm
    Author     : arjun
--%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>


<%
    Integer userId = (Integer) session.getAttribute("userId");
    if(userId == null){
        response.sendRedirect("LoginPage.jsp");
        return;
    }

    Connection con = DBConnection.getConnection();
%>

<html>
<head>
    <title>Add Transaction</title>
    <link rel="stylesheet" href="css/styletransaction.css">
</head>
<body>

<h2>Add Manual Transaction</h2>

<form action="AddTransactions" method="post">

    Select Card:
    <select name="card_id" required>
        <option value="">--Select Card--</option>
        <%
            String cardSql = "SELECT card_id, card_name, card_last4 FROM credit_cards WHERE user_id=?";
            PreparedStatement ps = con.prepareStatement(cardSql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
        %>
        <option value="<%=rs.getInt("card_id")%>">
            <%=rs.getString("card_name")%> (XXXX-XXXX-XXXX-<%=rs.getString("card_last4")%>)
        </option>
        <% } %>
    </select>
    <br><br>

    Select Category:
    <select name="category_id" required>
        <option value="">--Select Category--</option>
        <%
            Statement st = con.createStatement();
            ResultSet crs = st.executeQuery("SELECT * FROM categories");
            while(crs.next()){
        %>
        <option value="<%=crs.getInt("category_id")%>">
            <%=crs.getString("category_name")%>
        </option>
        <% } %>
    </select>
    <br><br>

    Amount:
    <input type="number" name="amount" step="0.01" required><br><br>

    Merchant Name:
    <input type="text" name="merchant"><br><br>

    Date:
    <input type="date" name="tdate" required><br><br>

    <input type="submit" value="Save Transaction">

</form>
    
    <a href="Dashboard.jsp" class="btn-secondary nav-dashboard">Back</a>
    <a href="Mycards.jsp" class="btn-secondary nav-cards">View Card</a>


    

</body>
</html>

