package it.unicam.qwert123.doit.backend.repositories;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.Tag;

@Repository
public interface ProjectRepository extends MongoRepository<Project, UUID> {

    Optional<Project> findById(UUID id);

    List<Project> findByName(String name);

    List<Project> findByTag(Tag...tag);

    List<Project> findByProjectProposer(UUID id);
}
