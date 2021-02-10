package it.unicam.qwert123.doit.backend.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.User;

import java.util.UUID;
import java.util.ArrayList;
import java.util.List;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

    default List<User> findByIds(List<String> mails) {
        List<User> users = new ArrayList<User>();
        for (String mail : mails) {
            users.add(findById(mail).get());
        }
        return users;
    }

    List<User> findByUsernameContaining(String username);

    List<User> findByTags(UUID tag);

    List<User> findByTagsContaining(List<UUID> idTags);

    boolean existsByUsername(String name);
}
