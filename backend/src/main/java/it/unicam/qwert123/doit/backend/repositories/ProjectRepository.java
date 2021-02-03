package it.unicam.qwert123.doit.backend.repositories;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Project;

@Repository
public interface ProjectRepository extends MongoRepository<Project, UUID> {

    Optional<Project> findById(UUID id);

    default List<Project> findByIds(List<UUID> ids) {
        List<Project> projects = new ArrayList<Project>();
        for (UUID id : ids) {
            projects.add(findById(id).get());
        }
        return projects;
    }

    List<Project> findByNameContaining(String name);

    List<Project> findByTag(UUID tag);

    List<Project> findByTagContaining(List<UUID> idtag);

}
