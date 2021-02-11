package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.services.ProjectService;
import it.unicam.qwert123.doit.backend.services.UserService;
import it.unicam.qwert123.doit.backend.utility.AccessCheckerComponent;
import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.User;

@RestController
@RequestMapping("doit/api/project")
public class ProjectController {
    @Autowired
    private ProjectService projectService;

    @Autowired
    private UserService userService;

    // NON ELIMINARE
    @Autowired
    private AccessCheckerComponent accessCheckerComponent;

    @PostMapping("/new")
    @PreAuthorize("hasAuthority('PROJECT_PROPOSER') and @accessCheckerComponent.sameUser(principal, #project.getProjectProposer())")
    public Project addProject(@RequestBody @Param("project") Project newProject) {
        Project returnProject = projectService.addProject(newProject);
        User user = userService.findByMail(returnProject.getProjectProposer());
        user.addPProposedProject(returnProject.getId());
        userService.updateUser(user);
        return returnProject;
    }

    @PutMapping("/update")
    @PreAuthorize("hasAuthority('PROJECT_PROPOSER') and @accessCheckerComponent.sameUser(principal, #project.getProjectProposer())")
    public Project updateProject(@RequestBody @Param("project") Project modifiedProject) {
        return projectService.updateProject(modifiedProject);
    }

    @DeleteMapping("/delete/{id}")
    public boolean deleteProject(@PathVariable("id") String id) {
        try {
            // aggiungere che cancella il progetto dalla lista dei progetti del
            // projectProposer
            return projectService.deleteProject(UUID.fromString(id));

        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }

    }

    @GetMapping("/getPage/{index}/{size}")
    public Page<Project> getProjectsPage(@PathVariable("index") int index, @PathVariable("size") int size) {
        return projectService.getProjectsPage(index, size);
    }

    @GetMapping("/get")
    public List<Project> getAllProjects() {
        return projectService.findAll();
    }

    @GetMapping("/getById/{id}")
    public Project getProjectById(@PathVariable("id") String id) {
        try {
            return projectService.findById(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }

    }

    @PutMapping("/getByIds")
    public List<Project> getProjectsByIds(@RequestBody List<String> ids) {
        List<UUID> projectsUuid = new ArrayList<>();
        for (String id : ids) {
            try {
                projectsUuid.add(UUID.fromString(id));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        }
        return projectService.findByIds(projectsUuid);
    }

    @GetMapping("/getByName/{name}")
    public List<Project> getProjectsByName(@PathVariable("name") String name) {
        return projectService.findByName(name);
    }

    @PutMapping("/getByTags")
    public List<Project> getProjectsByTags(@RequestBody List<String> tagsId) {
        List<UUID> tagsUuid = new ArrayList<>();
        for (String tagId : tagsId) {
            try {
                tagsUuid.add(UUID.fromString(tagId));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        }
        return projectService.findByTags(tagsUuid);
    }

}
