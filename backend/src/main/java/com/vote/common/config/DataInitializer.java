package com.vote.common.config;

import com.vote.entity.AdminUser;
import com.vote.repository.AdminUserRepository;
import javax.sql.DataSource;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

  private final AdminUserRepository adminUserRepository;
  private final PasswordEncoder passwordEncoder;
  private final JdbcTemplate jdbcTemplate;

  public DataInitializer(AdminUserRepository adminUserRepository,
                         PasswordEncoder passwordEncoder,
                         DataSource dataSource) {
    this.adminUserRepository = adminUserRepository;
    this.passwordEncoder = passwordEncoder;
    this.jdbcTemplate = new JdbcTemplate(dataSource);
  }

  @Override
  public void run(String... args) {
    AdminUser existing = adminUserRepository.findByUsername("admin");
    if (existing == null) {
      String hash = passwordEncoder.encode("admin123");
      jdbcTemplate.update("INSERT INTO users (username, password_hash) VALUES (?, ?)",
          "admin", hash);
      System.out.println("[DataInitializer] Default admin user created (admin / admin123)");
    }
  }
}
