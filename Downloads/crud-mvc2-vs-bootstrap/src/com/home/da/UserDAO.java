package com.home.da;

import com.home.entity.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/t1808a1?serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    private static final String INSERT_USERS_SQL =
            "INSERT INTO users (name, email, country) VALUES" + " (?, ?, ?)";
    private static final String SELECT_USER_BY_ID =
            "SELECT id, name, email, country FROM users WHERE id = ?";
    private static final String SELECT_ALL_USERS =
            "SELECT id, name, email, country FROM users";
    private static final String DELETE_USERS_SQL =
            "DELETE FROM users WHERE id = ?";
    private static final String UPDATE_USERS_SQL =
            "UPDATE users SET name = ?, email = ?, country = ? WHERE id = ?";

    public UserDAO() {}

    protected Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection connection = null;
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        return connection;
    }

    public void insertUser(User user) throws SQLException, ClassNotFoundException {
        Connection connection = getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USERS_SQL);
        preparedStatement.setString(1, user.getName());
        preparedStatement.setString(2, user.getEmail());
        preparedStatement.setString(3, user.getCountry());
        preparedStatement.executeUpdate();
    }

    public User selectUserById(int id) throws SQLException, ClassNotFoundException {
        User user = null;
        Connection connection = getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_ID);
        preparedStatement.setInt(1, id);
        ResultSet result = preparedStatement.executeQuery();
        while (result.next()) {
            String name = result.getString("name");
            String email = result.getString("email");
            String country = result.getString("country");
            user = new User(id, name, email, country);
        }
        return user;
    }

    public List<User> selectAllUsers() throws SQLException, ClassNotFoundException {
        List<User> users = new ArrayList<>();
        Connection connection = getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_USERS);
        ResultSet result = preparedStatement.executeQuery();
        while (result.next()) {
            int id = result.getInt("id");
            String name = result.getString("name");
            String email = result.getString("email");
            String country = result.getString("country");
            users.add(new User(id, name, email, country));
        }
        return users;
    }

    public boolean updateUser(User user) throws SQLException, ClassNotFoundException {
        boolean rowUpdated;
        Connection connection = getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_USERS_SQL);
        preparedStatement.setString(1, user.getName());
        preparedStatement.setString(2, user.getEmail());
        preparedStatement.setString(3, user.getCountry());
        preparedStatement.setInt(4, user.getId());
        rowUpdated = preparedStatement.executeUpdate() > 0;
        return rowUpdated;
    }

    public boolean deleteUser(int id) throws SQLException, ClassNotFoundException {
        boolean rowDeleted;
        Connection connection = getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(DELETE_USERS_SQL);
        preparedStatement.setInt(1, id);
        rowDeleted = preparedStatement.executeUpdate() > 0;
        return rowDeleted;
    }
}
