package com.cardcompass.cardcompass.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection – returns a raw JDBC Connection.
 * Credentials match application.properties exactly.
 *
 * Database : credit_card_spending_db
 * Username : root
 * Password : mysql
 * Port     : 3306
 * App Port : 9090  →  http://localhost:9090
 */
public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/credit_card_spending_db"
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static final String USERNAME = "root";
    private static final String PASSWORD = "mysql";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    /**
     * Returns a new Connection. Caller is responsible for closing it.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}