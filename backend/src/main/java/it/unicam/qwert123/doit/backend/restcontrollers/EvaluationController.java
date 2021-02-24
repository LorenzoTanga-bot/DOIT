package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
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

import it.unicam.qwert123.doit.backend.models.Evaluation;
import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.models.Evaluation.EvaluationMode;
import it.unicam.qwert123.doit.backend.services.EvaluationService;
import it.unicam.qwert123.doit.backend.services.ProjectService;
import it.unicam.qwert123.doit.backend.services.UserService;
import it.unicam.qwert123.doit.backend.utility.AccessCheckerComponent;

@RestController
@RequestMapping("doit/api/evaluation")
public class EvaluationController {

    @Autowired
    private EvaluationService evaluationService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private AccessCheckerComponent accessCheckerComponent;

    @PostMapping("/new")
    @PreAuthorize("hasAuthority('EXPERT') and @accessCheckerComponent.sameUser(principal, #evaluation.getSender())")
    public Evaluation addEvaluation(@RequestBody @Param("evaluation") Evaluation evaluation) {
        Evaluation rEvaluation = evaluationService.addEvaluations(evaluation);
        // update expert
        User user = userService.findById(rEvaluation.getSender());
        user.addEvaluationsSend(rEvaluation.getId());
        userService.updateUser(user);
        //update project
        Project project = projectService.findById(rEvaluation.getProject());
        if(evaluation.getEvaluationMode()==EvaluationMode.TEAM)
        project.addTeamEvaluations(rEvaluation.getId());
        else 
        project.addProjectEvaluations(rEvaluation.getId());
        projectService.updateProject(project);
        // update designers
        if (rEvaluation.getEvaluationMode().equals(EvaluationMode.TEAM)) {
            List<User> desiners = userService.findByIds(project.getDesigners());
            for (User desiner : desiners) {
                desiner.addEvaluationsReceived(rEvaluation.getId());
                userService.updateUser(user);
            }
        }
        return rEvaluation;
    }

    @PutMapping("/update")
    @PreAuthorize("hasAuthority('EXPERT') and @accessCheckerComponent.sameUser(principal, #evaluation.getSender())")
    public Evaluation updateEvaluation(@RequestBody @Param("evaluation") Evaluation evaluation){
        return evaluationService.updateEvaluation(evaluation);
    }

    @DeleteMapping("/delete")
    public boolean deleteEvaluation(@PathVariable("id") String id){
        try {
            //da controllare
            return evaluationService.deleteEvaluations(UUID.fromString(id));

        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @GetMapping("/getById/{id}")
    public Evaluation getEvaluationById(@PathVariable("id") String id) throws ResponseStatusException {
        try {
            return evaluationService.findById(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }
    
    @PutMapping("/getByIds")
    public List<Evaluation> getEvaluationsByIds(@RequestBody List<String> ids) {
        List<UUID> evaluationUuids = new ArrayList<>();
        for (String id : ids) 
            try {
                evaluationUuids.add(UUID.fromString(id));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        return evaluationService.findByIds(evaluationUuids);
    }

    @GetMapping("/getBySender/{id}")
    public List<Evaluation> getEvaluationsBySender(@PathVariable("id") String idSender) {
        return evaluationService.findBySender(idSender);
    }

    @GetMapping("/getByProject/{id}")
    public List<Evaluation> getEvaluationsByProject(@PathVariable("id") String idProject) {
        try {
        return evaluationService.findByProject(UUID.fromString(idProject));
    } catch (IllegalArgumentException e) {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
    } 
    }

    
}
