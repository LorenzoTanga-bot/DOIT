package it.unicam.qwert123.doit.backend.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.User;

import java.util.List;
import java.util.UUID;

@Repository
public interface UserRepository extends MongoRepository<User, UUID> {
    User findByMail(String mail);

    User findByUsername(String username);

    List<User> findBySkills(UUID... skills);
}
