package it.unicam.qwert123.doit.backend.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.User;

import java.util.UUID;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, UUID> {

    Optional<User> findById(UUID id);

    default List<User> findByIds(List<UUID> ids) {
        List<User> users = new ArrayList<User>();
        for (UUID id : ids) {
            users.add(findById(id).get());
        }
        return users;
    }

    Optional<User> findByMail(String mail);

    List<User> findByUsernameContaining(String username);

    List<User> findByTags(UUID tag);

    List<User> findByTagsContaining(List<UUID> idTags);

    boolean existsByUsername(String name);
}
