package com.gajur.marriagehallbookingsystem.dao;

import com.gajur.marriagehallbookingsystem.model.Hall;
import com.gajur.marriagehallbookingsystem.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HallDAO {

    public List<Hall> getAllHalls() {
        List<Hall> list = new ArrayList<>();
        String sql = "SELECT h.*, u.full_name AS owner_name FROM halls h JOIN users u ON h.owner_id = u.user_id ORDER BY h.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapHall(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Hall> getAvailableHalls() {
        List<Hall> list = new ArrayList<>();
        String sql = "SELECT h.*, u.full_name AS owner_name FROM halls h JOIN users u ON h.owner_id = u.user_id WHERE h.status = 'AVAILABLE' ORDER BY h.hall_name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapHall(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Hall> searchHalls(String city, int capacity, BigDecimal maxPrice) {
        List<Hall> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT h.*, u.full_name AS owner_name FROM halls h JOIN users u ON h.owner_id = u.user_id WHERE h.status='AVAILABLE'");
        List<Object> params = new ArrayList<>();
        if (city != null && !city.isEmpty()) {
            sql.append(" AND h.city LIKE ?");
            params.add("%" + city + "%");
        }
        if (capacity > 0) {
            sql.append(" AND h.seating_capacity >= ?");
            params.add(capacity);
        }
        if (maxPrice != null && maxPrice.compareTo(BigDecimal.ZERO) > 0) {
            sql.append(" AND h.price_per_day <= ?");
            params.add(maxPrice);
        }
        sql.append(" ORDER BY h.price_per_day");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapHall(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Hall> getHallsByOwner(int ownerId) {
        List<Hall> list = new ArrayList<>();
        String sql = "SELECT h.*, u.full_name AS owner_name FROM halls h JOIN users u ON h.owner_id = u.user_id WHERE h.owner_id = ? ORDER BY h.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapHall(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Hall getHallById(int hallId) {
        String sql = "SELECT h.*, u.full_name AS owner_name FROM halls h JOIN users u ON h.owner_id = u.user_id WHERE h.hall_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapHall(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addHall(Hall hall) {
        String sql = "INSERT INTO halls (owner_id, hall_name, location, city, seating_capacity, price_per_day, description, facilities, contact_number, image_url, status) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hall.getOwnerId());
            ps.setString(2, hall.getHallName());
            ps.setString(3, hall.getLocation());
            ps.setString(4, hall.getCity());
            ps.setInt(5, hall.getSeatingCapacity());
            ps.setBigDecimal(6, hall.getPricePerDay());
            ps.setString(7, hall.getDescription());
            ps.setString(8, hall.getFacilities());
            ps.setString(9, hall.getContactNumber());
            ps.setString(10, hall.getImageUrl());
            ps.setString(11, hall.getStatus() != null ? hall.getStatus() : "AVAILABLE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateHall(Hall hall) {
        String sql = "UPDATE halls SET hall_name=?, location=?, city=?, seating_capacity=?, price_per_day=?, description=?, facilities=?, contact_number=?, status=? WHERE hall_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hall.getHallName());
            ps.setString(2, hall.getLocation());
            ps.setString(3, hall.getCity());
            ps.setInt(4, hall.getSeatingCapacity());
            ps.setBigDecimal(5, hall.getPricePerDay());
            ps.setString(6, hall.getDescription());
            ps.setString(7, hall.getFacilities());
            ps.setString(8, hall.getContactNumber());
            ps.setString(9, hall.getStatus());
            ps.setInt(10, hall.getHallId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteHall(int hallId) {
        String sql = "DELETE FROM halls WHERE hall_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateHallStatus(int hallId, String status) {
        String sql = "UPDATE halls SET status=? WHERE hall_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, hallId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean isDateBlocked(int hallId, Date date) {
        String sql = "SELECT COUNT(*) FROM hall_availability WHERE hall_id=? AND blocked_date=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean blockDate(int hallId, Date date, String reason) {
        String sql = "INSERT IGNORE INTO hall_availability (hall_id, blocked_date, reason) VALUES (?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            ps.setDate(2, date);
            ps.setString(3, reason);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean unblockDate(int hallId, Date date) {
        String sql = "DELETE FROM hall_availability WHERE hall_id=? AND blocked_date=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            ps.setDate(2, date);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Date> getBlockedDates(int hallId) {
        List<Date> dates = new ArrayList<>();
        String sql = "SELECT blocked_date FROM hall_availability WHERE hall_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) dates.add(rs.getDate("blocked_date"));
        } catch (SQLException e) { e.printStackTrace(); }
        return dates;
    }

    public int countHalls() {
        String sql = "SELECT COUNT(*) FROM halls";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Hall mapHall(ResultSet rs) throws SQLException {
        Hall h = new Hall();
        h.setHallId(rs.getInt("hall_id"));
        h.setOwnerId(rs.getInt("owner_id"));
        h.setOwnerName(rs.getString("owner_name"));
        h.setHallName(rs.getString("hall_name"));
        h.setLocation(rs.getString("location"));
        h.setCity(rs.getString("city"));
        h.setSeatingCapacity(rs.getInt("seating_capacity"));
        h.setPricePerDay(rs.getBigDecimal("price_per_day"));
        h.setDescription(rs.getString("description"));
        h.setFacilities(rs.getString("facilities"));
        h.setContactNumber(rs.getString("contact_number"));
        h.setImageUrl(rs.getString("image_url"));
        h.setStatus(rs.getString("status"));
        h.setCreatedAt(rs.getTimestamp("created_at"));
        return h;
    }
}
