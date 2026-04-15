package com.gajur.marriagehallbookingsystem.dao;

import com.gajur.marriagehallbookingsystem.model.Booking;
import com.gajur.marriagehallbookingsystem.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (hall_id, customer_id, event_date, event_type, guest_count, total_price, special_requests) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, booking.getHallId());
            ps.setInt(2, booking.getCustomerId());
            ps.setDate(3, booking.getEventDate());
            ps.setString(4, booking.getEventType());
            ps.setInt(5, booking.getGuestCount());
            ps.setBigDecimal(6, booking.getTotalPrice());
            ps.setString(7, booking.getSpecialRequests());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, h.hall_name, h.location AS hall_location, u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone FROM bookings b JOIN halls h ON b.hall_id=h.hall_id JOIN users u ON b.customer_id=u.user_id ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapBooking(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> getBookingsByCustomer(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, h.hall_name, h.location AS hall_location, u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone FROM bookings b JOIN halls h ON b.hall_id=h.hall_id JOIN users u ON b.customer_id=u.user_id WHERE b.customer_id=? ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapBooking(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> getBookingsByOwner(int ownerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, h.hall_name, h.location AS hall_location, u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone FROM bookings b JOIN halls h ON b.hall_id=h.hall_id JOIN users u ON b.customer_id=u.user_id WHERE h.owner_id=? ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapBooking(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> getBookingsByHall(int hallId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, h.hall_name, h.location AS hall_location, u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone FROM bookings b JOIN halls h ON b.hall_id=h.hall_id JOIN users u ON b.customer_id=u.user_id WHERE b.hall_id=? ORDER BY b.event_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapBooking(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT b.*, h.hall_name, h.location AS hall_location, u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone FROM bookings b JOIN halls h ON b.hall_id=h.hall_id JOIN users u ON b.customer_id=u.user_id WHERE b.booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapBooking(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status=? WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean cancelBooking(int bookingId, int customerId) {
        String sql = "UPDATE bookings SET status='CANCELLED' WHERE booking_id=? AND customer_id=? AND status='PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean isDateBooked(int hallId, Date date) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE hall_id=? AND event_date=? AND status IN ('PENDING','APPROVED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hallId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countAllBookings() {
        return countByStatus(null);
    }

    public int countByStatus(String status) {
        String sql = status == null ? "SELECT COUNT(*) FROM bookings" : "SELECT COUNT(*) FROM bookings WHERE status=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (status != null) ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT SUM(total_price) FROM bookings WHERE status IN ('APPROVED','COMPLETED')";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                BigDecimal v = rs.getBigDecimal(1);
                return v != null ? v : BigDecimal.ZERO;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setHallId(rs.getInt("hall_id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setHallName(rs.getString("hall_name"));
        b.setHallLocation(rs.getString("hall_location"));
        b.setCustomerName(rs.getString("customer_name"));
        b.setCustomerEmail(rs.getString("customer_email"));
        b.setCustomerPhone(rs.getString("customer_phone"));
        b.setEventDate(rs.getDate("event_date"));
        b.setEventType(rs.getString("event_type"));
        b.setGuestCount(rs.getInt("guest_count"));
        b.setTotalPrice(rs.getBigDecimal("total_price"));
        b.setSpecialRequests(rs.getString("special_requests"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));
        return b;
    }
}
