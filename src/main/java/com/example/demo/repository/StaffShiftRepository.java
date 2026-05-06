package com.example.demo.repository;

import com.example.demo.model.StaffShift;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
<<<<<<< HEAD

=======
>>>>>>> d7246d0f86fe3cab85b747e2b1a49007a9f41789
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
