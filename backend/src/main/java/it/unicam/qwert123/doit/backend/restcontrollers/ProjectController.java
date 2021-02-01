package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
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

    //@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('PROJECT_PROPOSER')")
    @PostMapping("/new")
    public Project addProject(@RequestBody Project newProject) {
        return service.addProject(newProject);
    }

    //@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('PROJECT_PROPOSER')")
    @PutMapping("/update")
    public Project updateProject(@RequestBody Project modifiedProject) {
        return service.updateProject(modifiedProject);
    }

    //@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('PROJECT_PROPOSER')")
    @DeleteMapping("/delete/{id}")
    public boolean deleteProject(@PathVariable("id") String id) {
        return service.deleteProject(UUID.fromString(id));
    }

    @GetMapping("/get")
    public List<Project> getAllProjects() {
        return service.findAll();
    }

    @GetMapping("/getById/{id}")
    public Project getProjectById(@PathVariable("id") String id){
        return service.findById(UUID.fromString(id));
    }

    @GetMapping("/getByName/{name}")
    public List<Project> getProjectsByName(@PathVariable("name") String name){
        return service.findByName(name);
    }

    @GetMapping("/getByUser/{userId}")
    public List<Project> getProjectsByUser(@PathVariable("userId") String userId){
        return service.findByProjectProposer(UUID.fromString(userId));
    }
    @GetMapping("/getByTags")
    public List<Project> getProjectsByTags(@RequestBody List<String> tagsId){
        List<UUID> tagsUuid = new ArrayList<>();
        for(String tagId :tagsId){
            tagsUuid.add(UUID.fromString(tagId));
        }
        return service.findByTags(tagsUuid);
    }

}
