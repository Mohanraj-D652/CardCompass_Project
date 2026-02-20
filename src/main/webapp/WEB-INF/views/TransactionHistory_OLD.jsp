<%-- 
    Document   : TransactionHistory
    Created on : 28 Dec 2025, 1:01:10 pm
    Author     : arjun
--%>

<%-- TransactionHistory.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>

<%
    // Ensure user is logged in
    Integer userIdObj = (Integer) session.getAttribute("userId");
    if (userIdObj == null) {
        response.sendRedirect("LoginPage.jsp");
        return;
    }
    int userId = userIdObj;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Transaction History</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background: #fafafa;
        }
        h2 {
            margin-bottom: 10px;
        }
        .subtitle {
            font-size: 13px;
            color: #555;
            margin-bottom: 16px;
        }
        table {
            width: 90%;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }
        thead {
            background: #f4f4f4;
        }
        th, td {
            padding: 10px 14px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 14px;
        }
        th {
            text-align: left;
            font-weight: 600;
        }
        tbody tr:nth-child(even) {
            background: #fafafa;
        }
        .amount-col {
            text-align: right;
            width: 120px;
        }
        .id-col {
            width: 80px;
            text-align: center;
        }
        .date-col {
            width: 130px;
        }
        .category-col {
            width: 180px;
        }
        .merchant-col {
            width: 260px;
        }
    </style>
    <link rel="stylesheet" href="css/stylehistory.css">

</head>
<body>

<h2>Transaction History</h2>
<p class="subtitle">
    Showing all transactions for your saved cards, with category, amount, merchant, and date.
</p>

<table>
    <thead>
        <tr>
            <th class="id-col">ID</th>
            <th class="category-col">Category</th>
            <th class="amount-col">Amount</th>
            <th class="merchant-col">Merchant</th>
            <th class="date-col">Date</th>
        </tr>
    </thead>
    <tbody>
<%
    try {
        con = DBConnection.getConnection();

        String sql =
            "SELECT t.transaction_id, " +
            "       cat.category_name, " +
            "       t.amount, " +
            "       t.merchant_name, " +
            "       t.transaction_date " +
            "FROM transactions t " +
            "JOIN categories cat      ON t.category_id = cat.category_id " +
            "JOIN credit_cards cards  ON t.card_id = cards.card_id " +
            "WHERE cards.user_id = ? " +
            "ORDER BY t.transaction_date DESC, t.transaction_id DESC";

        ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        boolean hasRows = false;
        while (rs.next()) {
            hasRows = true;
            int tid          = rs.getInt("transaction_id");
            String cname     = rs.getString("category_name");
            double amount    = rs.getDouble("amount");
            String merchant  = rs.getString("merchant_name");
            java.sql.Date dt = rs.getDate("transaction_date");
%>
        <tr>
            <td class="id-col"><%= tid %></td>
            <td class="category-col"><%= cname %></td>
            <td class="amount-col">₹<%= String.format("%.2f", amount) %></td>
            <td class="merchant-col"><%= merchant != null ? merchant : "-" %></td>
            <td class="date-col"><%= dt %></td>
        </tr>
<%
        }
        if (!hasRows) {
%>
        <tr>
            <td colspan="5">No transactions found.</td>
        </tr>
<%
        }
    } catch (Exception e) {
%>
        <tr>
            <td colspan="5">Error: <%= e.getMessage() %></td>
        </tr>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>
    </tbody>
</table>
    
    
    
  <div class="top-nav">
    <a href="Dashboard.jsp" class="nav-dashboard">Dashboard</a>
    <a href="CatagerywiseSpending.jsp" class="nav-spending">Spending Summary</a>
    <a href="AddTransactions.jsp" class="nav-add-transaction">+ New Transaction</a>
</div>


</body>
</html>
