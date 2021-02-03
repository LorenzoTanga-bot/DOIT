package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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
import it.unicam.qwert123.doit.backend.models.Project;

@RestController
@RequestMapping("doit/api/project")
public class ProjectController {
    @Autowired
    private ProjectService service;

    @PostMapping("/new")
    public Project addProject(@RequestBody Project newProject) {
        return service.addProject(newProject);
    }

    @PutMapping("/update")
    public Project updateProject(@RequestBody Project modifiedProject) {
        return service.updateProject(modifiedProject);
    }

    @DeleteMapping("/delete/{id}")
    public boolean deleteProject(@PathVariable("id") String id) {
        try {
            return service.deleteProject(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
        
    }

    @GetMapping("/get")
    public List<Project> getAllProjects() {
        return service.findAll();
    }

    @GetMapping("/getById/{id}")
    public Project getProjectById(@PathVariable("id") String id) {
        try {
            return service.findById(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
        
    }

    @GetMapping("/getByIds")
    public List<Project> getProjectsByIds(@RequestBody List<String> ids) {
        List<UUID> projectsUuid = new ArrayList<>();
        for (String id : ids) {
            try {
                projectsUuid.add(UUID.fromString(id));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        }
        return service.findByIds(projectsUuid);
    }

    @GetMapping("/getByName/{name}")
    public List<Project> getProjectsByName(@PathVariable("name") String name) {
        return service.findByName(name);
    }

    @GetMapping("/getByTags")
    public List<Project> getProjectsByTags(@RequestBody List<String> tagsId) {
        List<UUID> tagsUuid = new ArrayList<>();
        for (String tagId : tagsId) {
            try {
                tagsUuid.add(UUID.fromString(tagId));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        }
        return service.findByTags(tagsUuid);
    }

}
