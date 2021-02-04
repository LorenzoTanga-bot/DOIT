package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.AuthCredential.Role;
import it.unicam.qwert123.doit.backend.repositories.ProjectRepository;
import lombok.NonNull;

@Service
public class ProjectService {
    @Autowired
    private ProjectRepository repository;

    private boolean existsById(UUID id) throws ResponseStatusException {
        if (!repository.existsById(id))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Project not found");
        return true;
    }

    private boolean checkProject(Project newProject) throws ResponseStatusException {
        if (newProject.getTag().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid project: it must have at least one tag");
        }
        return checkDate(newProject);
    }

    private boolean checkDate(Project project) {
        if (!project.getDateOfCreation().after(project.getStartCandidacy())) {
            if (project.getDateOfStart().before(project.getDateOfEnd())) {
                if (project.getStartCandidacy().before(project.getEndCandidacy())) {
                    if (project.getDateOfStart().after(project.getEndCandidacy())) {
                        return true;
                    } else
                        throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                                "Error Date: the start date of the project is before or equal to the end date of the candidacies");
                } else
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "Error Date: the end date of the candidacies is before or equal to the start date of the candidacies");
            } else
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Error Date:  the end date of project is before or equal to the start date of the project");
        } else
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Error Date: the start date of the candidacies is befor to the project creation date");
    }

    public Project addProject(@NonNull Project newProject) throws ResponseStatusException {
        if (checkProject(newProject)) {
            newProject.setId(UUID.randomUUID());
            /*
             * if (user.getRole().first() == Role.PROJECT_PROPOSER) {
             * user.addProjectToFistRole(newProject.getId()); } else
             * user.addProjectToSecondRole(newProject.getId());
             */
            return repository.insert(newProject);
        } else
            return null;
    }

    public boolean deleteProject(@NonNull UUID id) throws ResponseStatusException {
        if (existsById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }

    public Project updateProject(@NonNull Project modifiedProject) throws ResponseStatusException {
        if (existsById(modifiedProject.getId())) {
            if (modifiedProject.getProjectProposer() == findById(modifiedProject.getId()).getProjectProposer()) {
                if (checkProject(modifiedProject)) {
                    return repository.save(modifiedProject);
                }
            }
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "The projectProposer must be immutable");
        }
        return null;
    }

    public List<Project> findAll() {
        return repository.findAll();
    }

    public Project findById(@NonNull UUID id) throws ResponseStatusException {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Project not found"));
    }

    public List<Project> findByName(@NonNull String name) {
        return repository.findByNameContaining(name);
    }

    public List<Project> findByTags(@NonNull List<UUID> tags) {
        return repository.findByTagContaining(tags);
    }

    public List<Project> findByIds(@NonNull List<UUID> ids) {
        return repository.findByIds(ids);
    }

}
