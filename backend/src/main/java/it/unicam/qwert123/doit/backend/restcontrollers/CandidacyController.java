package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.models.Candidacy;
import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.services.CandidacyService;
import it.unicam.qwert123.doit.backend.services.ProjectService;
import it.unicam.qwert123.doit.backend.services.UserService;
import it.unicam.qwert123.doit.backend.utility.AccessCheckerComponent;

@RestController
@RequestMapping("doit/api/candidacy")
public class CandidacyController {

    @Autowired
    private CandidacyService candidacyService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    // NON ELIMINARE
    @Autowired
    private AccessCheckerComponent accessCheckerComponent;

    @PostMapping("/new")
    @PreAuthorize("hasAuthority('DESIGNER') and @accessCheckerComponent.sameUser(principal, #candidacy.getDesigner())")
    public Candidacy addCandidacy(@RequestBody @Param("candidacy") Candidacy candidacy) {
        Candidacy returnCandidacy = candidacyService.addCandidacy(candidacy);
        User designer = userService.findById(returnCandidacy.getDesigner());
        designer.addCandidacy(returnCandidacy.getId());
        userService.updateUser(designer);
        Project project = projectService.findById(returnCandidacy.getProject());
        project.addCandidacy(returnCandidacy.getId());
        projectService.updateProject(project);
        return returnCandidacy;
    }

    @PutMapping("/update/candidacy")
    @PreAuthorize("(hasAuthority('DESIGNER') and @accessCheckerComponent.sameUser(principal, #candidacy.getDesigner())) or (hasAuthority('PROJECT_PROPOSER') and @accessCheckerComponent.sameUser(principal, #candidacy.getProjectProposer()))")
    public Candidacy updateCandidacy(@RequestBody @Param("candidacy") Candidacy candidacy) {
        return candidacyService.updateCandidacy(candidacy);
    }

    @GetMapping("/getById/{id}")
    public Candidacy getCandidacyById(@PathVariable("id") String id) {
        try {
            return candidacyService.findById(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @PutMapping("/getByIds")
    public List<Project> getCandidacyByIds(@RequestBody List<String> ids) {
        List<UUID> candidacyUuids = new ArrayList<>();
        for (String id : ids) 
            try {
                candidacyUuids.add(UUID.fromString(id));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        return projectService.findByIds(candidacyUuids);
    }

    @GetMapping("/getByDesigner/{user}")
    public List<Candidacy> getByDesigner(@PathVariable("user") String user){
        return candidacyService.findByDesigner(user);
    }

    @GetMapping("/getByProjectProposer/{user}")
    public List<Candidacy> getByProjectProposer(@PathVariable("user") String user){
        return candidacyService.findByProjectProposer(user);
    }

    @GetMapping("/getByProject/{id}")
    public List<Candidacy> getByProject(@PathVariable("id") UUID project){
        return candidacyService.findByProject(project);
    }

}
