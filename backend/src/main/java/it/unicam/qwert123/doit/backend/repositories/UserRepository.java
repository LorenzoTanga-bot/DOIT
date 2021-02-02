package it.unicam.qwert123.doit.backend.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.User;

import java.util.UUID;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

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

    List<User> findByTag(UUID tag);

    default List<User> findByTags(List<UUID> idTags) {
        Set<User> usersSet = new HashSet<User>();
        for (UUID idTag : idTags)
            usersSet.addAll(findByTag(idTag));
        List<User> usersList = new ArrayList<User>();
        for (User user : usersSet)
            usersList.add(user);
        return usersList;
    }

    boolean existsByUsername(String name);
}
