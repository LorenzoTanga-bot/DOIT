package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    public Project updateProject(@RequestBody Project newProject) {
        return service.updateProject(newProject);
    }

    @DeleteMapping("/delete/{id}")
    public boolean deleteProject(@PathVariable("id") String id) {
        return service.deleteProject(UUID.fromString(id));
    }

    @GetMapping("/get")
    public List<Project> getAllProject() {
        return service.getAllProject();
    }

    @GetMapping("/getById/{id}")
    public Optional<Project> getProjectById(@PathVariable("id") String id){
        return service.findById(UUID.fromString(id));
    }

    @GetMapping("/getByName/{name}")
    public List<Project> getProjectByName(@PathVariable("name") String name){
        return service.findByName(name);
    }

    @GetMapping("/getByUser/{userId}")
    public List<Project> getProjectByUser(@PathVariable("userId") String userId){
        return service.findByProjectProposer(UUID.fromString(userId));
    }
}
