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

import it.unicam.qwert123.doit.backend.models.Invite;
import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.services.InviteService;
import it.unicam.qwert123.doit.backend.services.UserService;
import it.unicam.qwert123.doit.backend.utility.AccessCheckerComponent;

@RestController
@RequestMapping("doit/api/invite")
public class InviteController {

    @Autowired
    private InviteService inviteService;

    @Autowired
    private UserService userService;

    // NON ELIMINARE
    @Autowired
    private AccessCheckerComponent accessCheckerComponent;

    @PostMapping("/new")
    // TODO mettere apposto con autorita: sia projectP. che designer(in questo caso
    // deve essere un azienda)
 //@PreAuthorize("(hasAuthority('PROJECT_PROPOSER') and @accessCheckerComponent.sameUser(principal, #candidacy.getProjectProposer())) or hasAuthority('DESIGNER'))")
    public Invite addiInvite(@RequestBody @Param("invite") Invite invite) {
        Invite returnInvite = inviteService.addInvite(invite);
        User designer = userService.findById(returnInvite.getDesigner());
        designer.addInvite(returnInvite.getId());
        userService.updateUser(designer);
        User projectProposer = userService.findById(returnInvite.getProjectProposer());
        projectProposer.addInvite(returnInvite.getId());
        userService.updateUser(projectProposer);
        return returnInvite;
    }

    @PutMapping("/update")
    @PreAuthorize("(hasAuthority('DESIGNER') and @accessCheckerComponent.sameUser(principal, #invite.getDesigner())) or (hasAuthority('PROJECT_PROPOSER') and @accessCheckerComponent.sameUser(principal, #candidacy.getProjectProposer()))")
    public Invite updateInvite(@RequestBody @Param("invite") Invite invite) {
        return inviteService.updateInvite(invite);
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
