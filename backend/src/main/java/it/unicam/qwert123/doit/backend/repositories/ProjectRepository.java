package it.unicam.qwert123.doit.backend.repositories;

import java.util.Set;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Project;

@Repository
public interface ProjectRepository extends MongoRepository<Project, UUID> {

    Optional<Project> findById(UUID id);

    List<Project> findByName(String name);

    List<Project> findByTagsContaining(UUID tag);

    default List<Project> findByTags(List<UUID> idTags) {
        Set<Project> projectsSet = new HashSet<Project>();
        for (UUID idTag : idTags) 
            projectsSet.addAll(findByTagsContaining(idTag));
        List<Project> projectList = new ArrayList<Project>();
        for(Project project : projectsSet){
            projectList.add(project);
        }
        return projectList;
    }

    List<Project> findByProjectProposer(UUID id);
}
