package com.example.demo.repository;

import com.example.demo.model.StaffShift;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface StaffShiftRepository extends JpaRepository<StaffShift, Long> {
    List<StaffShift> findByUser(User user);
    List<StaffShift> findByDayOfWeek(String dayOfWeek);
    
    // Alias for backward compatibility
    default List<StaffShift> findByStaff(User staff) {
        return findByUser(staff);
    }
}
