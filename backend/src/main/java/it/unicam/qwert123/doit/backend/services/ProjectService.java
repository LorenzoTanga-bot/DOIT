package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.Tag;
import it.unicam.qwert123.doit.backend.repositories.ProjectRepository;
import lombok.NonNull;

@Service
public class ProjectService {
    @Autowired
    private ProjectRepository repository;

    public Project addProject(@NonNull Project newProject) {
        newProject.setId(UUID.randomUUID());
        return repository.insert(newProject);
    }

    public boolean deleteProject(@NonNull UUID id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        } else {
            return false;
        }
    }

    public Project updateProject(@NonNull Project newPorject) {
        if (repository.existsById(newPorject.getId())) {
            return repository.save(newPorject);
        } else {
            return null;
        }
    }

    public List<Project> getAllProject() {
        return repository.findAll();
    }

    public Optional<Project> findById(@NonNull UUID id) {
        return repository.findById(id);
    }

    public List<Project> findByName(@NonNull String name) {
        return repository.findByName(name);
    }

    public List<Project> findByTag(@NonNull Tag... tags) {
        return repository.findByTag(tags);
    }

    public List<Project> findByProjectProposer(@NonNull UUID id) {
        return repository.findByProjectProposer(id);
    }

}
