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
    Optional<User> findByMail(String mail);

    Optional<User> findByUsername(String username);

    List<User> findByTagsContaining(UUID tag);

    default List<User> findByTags(List<UUID> idTags){
        Set<User> projectsSet = new HashSet<User>();
        for (UUID idTag : idTags) 
            projectsSet.addAll(findByTagsContaining(idTag));
        List<User> projectList = new ArrayList<User>();
        for(User project : projectsSet)
            projectList.add(project);
        return projectList;
    }
}
