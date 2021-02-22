package it.unicam.qwert123.doit.backend.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.User;

import java.util.UUID;

import java.util.List;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

   

    List<User> findByUsernameContaining(String username);

    List<User> findByTags(UUID tag);

    List<User> findByTagsContaining(List<UUID> idTags);

    boolean existsByUsername(String name);
}
