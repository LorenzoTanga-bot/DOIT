package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.Date;
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

import it.unicam.qwert123.doit.backend.models.Invite;
import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.models.Invite.StateInvite;
import it.unicam.qwert123.doit.backend.services.InviteService;
import it.unicam.qwert123.doit.backend.services.ProjectService;
import it.unicam.qwert123.doit.backend.services.UserService;
import it.unicam.qwert123.doit.backend.utility.AccessCheckerComponent;

@RestController
@RequestMapping("doit/api/invite")
public class InviteController {

    @Autowired
    private InviteService inviteService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    // NON ELIMINARE
    @Autowired
    private AccessCheckerComponent accessCheckerComponent;

    private void updateUserProject(Invite invite){
        if(invite.getStateDesigner() == StateInvite.POSITIVE && invite.getStateProjectProposer() == StateInvite.POSITIVE && invite.getDateOfExpire().before(new Date())){
            User user = userService.findById(invite.getDesigner());
            user.addPartecipateInProject(invite.getProject());
            userService.updateUser(user);
            Project project = projectService.findById(invite.getProject());
            project.addDesigner(invite.getDesigner());
            projectService.updateProject(project);
        }
    }

    @PostMapping("/new")
    @PreAuthorize("(hasAuthority('DESIGNER_ENTITY') or hasAuthority('PROJECT_PROPOSER')) and @accessCheckerComponent.sameUser(principal, #invite.getSender())")
    public Invite addiInvite(@RequestBody @Param("invite") Invite invite) {
        Invite returnInvite = inviteService.addInvite(invite);
        //update desiner
        User user = userService.findById(returnInvite.getDesigner());
        user.addInvite(returnInvite.getId());
        userService.updateUser(user);
        //update projectproposer
        user = userService.findById(returnInvite.getProjectProposer());
        user.addInvite(returnInvite.getId());
        userService.updateUser(user);
        if(returnInvite.getSender() != returnInvite.getProjectProposer()){
            //update sender
            user = userService.findById(returnInvite.getSender());
            user.addInvite(returnInvite.getId());
            userService.updateUser(user);
        }
        //update project
        Project project = projectService.findById(invite.getProject());
        project.addInvite(returnInvite.getId());
        projectService.updateProject(project);
        return returnInvite;
    }

    @PutMapping("/updateStateDesigner/")
    @PreAuthorize("(hasAuthority('DESIGNER_ENTITY') or hasAuthority('DESIGNER_PERSON')) and @accessCheckerComponent.sameUser(principal, #invite.getDesigner())")
    public Invite updateStateDesigner(@RequestBody @Param("invite") Invite invite) {
    Invite returnInvite;
        try {
            returnInvite = inviteService.updateInvite(invite.getId(), false, invite.getStateDesigner());
            updateUserProject(returnInvite);
            return returnInvite; 
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @PutMapping("/updateStateProjectProposer/")
    @PreAuthorize("hasAuthority('PROJECT_PROPOSER') and @accessCheckerComponent.sameUser(principal, #invite.getProjectProposer())")
    public Invite updateStateProjectProposer(@RequestBody @Param("invite") Invite invite) {
    Invite returnInvite;
        try {
            returnInvite = inviteService.updateInvite(invite.getId(), true, invite.getStateProjectProposer());
            updateUserProject(returnInvite);
            return returnInvite; 
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @GetMapping("/getById/{id}")
    public Invite getInviteyById(@PathVariable("id") String id) {
        try {
            return inviteService.findById(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @PutMapping("/getByIds")
    public List<Invite> getInvitesByIds(@RequestBody List<String> ids) {
        List<UUID> inviteUuids = new ArrayList<>();
        for (String id : ids)
            try {
                inviteUuids.add(UUID.fromString(id));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        return inviteService.findByIds(inviteUuids);
    }

    @GetMapping("/getByDesigner/{user}")
    public List<Invite> getInvitesByDesigner(@PathVariable("user") String user) {
        return inviteService.findByDesigner(user);
    }

    @GetMapping("/getByProjectProposer/{user}")
    public List<Invite> getInvitesByProjectProposer(@PathVariable("user") String user) {
        return inviteService.findByProjectProposer(user);
    }

    @GetMapping("/getByProject/{id}")
    public List<Invite> getInvitesByProject(@PathVariable("id") String project) {
        UUID projectId;
        try {
            projectId = UUID.fromString(project);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
        return inviteService.findByProject(projectId);
    }

}
