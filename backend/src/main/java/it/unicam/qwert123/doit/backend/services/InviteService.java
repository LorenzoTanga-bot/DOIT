package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import com.mongodb.lang.NonNull;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.models.Invite;
import it.unicam.qwert123.doit.backend.models.Project;
import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.models.Invite.StateInvite;
import it.unicam.qwert123.doit.backend.repositories.InviteRepository;

@Service
public class InviteService {
    
    @Autowired
    private InviteRepository repository;

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    private boolean existsById(UUID id) throws ResponseStatusException {
        if (!repository.existsById(id))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "invite not found");
        return true;
    }

    private boolean checkInvite(Invite invite) {
        if(invite.getStateDesigner() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: StateDesigner is null");
        if(invite.getStateProjectProposer() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: StateProject is null");
        if(invite.getSender() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: Sender is null");
        if (invite.getProject() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: Project is null");
        if (invite.getDesigner() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: User is null");
        if (invite.getDateOfInvite() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: Date of invite is null");
      
        User user = userService.findById(invite.getDesigner());
        Project project = projectService.findById(invite.getProject());
        for (UUID tag : project.getTag()) {
            if (user.getTags().contains(tag))
                return true;
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                "Invalid candidacy: The designer don't have right tags");

    }
 public List<Invite> findAll(){
     return  repository.findAll();
 }
    public Invite addInvite(@NonNull Invite invite) throws ResponseStatusException {
        if (checkInvite(invite)) {
            List<Invite> invites = repository.findByProject(invite.getProject());
            for (Invite existingInvite : invites) {
                if (existingInvite.getDesigner().equals(invite.getDesigner()))
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: invite already sent");
            }
            invite.setId(UUID.randomUUID());
            return repository.insert(invite);
        }
        return null;
    }

    public boolean deleteInvite(@NonNull UUID id) throws ResponseStatusException {
        if (!existsById(id))
            return false;
        repository.deleteById(id);
        return true;
    }

    public Invite updateInvite(@NonNull UUID id, @NonNull boolean isTheProjectProposer, @NonNull StateInvite state){
        Invite returnInvite = findById(id);
        if(isTheProjectProposer)
            returnInvite.setStateProjectProposer(state);
        else
            returnInvite.setStateDesigner(state);
           
        return  repository.save(returnInvite);
    }

    public Invite updateInvite(@NonNull Invite invite) throws ResponseStatusException {
        if (existsById(invite.getId()) && checkInvite(invite))
            return repository.save(invite);
        return null;
    }

    public Invite findById(@NonNull UUID id) throws ResponseStatusException {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Invite not found"));
    }

    public List<Invite> findByIds(List<UUID> ids) {
        return StreamSupport.stream(repository.findAllById(ids).spliterator(), false).collect(Collectors.toList());
    }

    public List<Invite> findByDesigner(String user) {
        return repository.findByDesigner(user);
    }

    public List<Invite> findByProjectProposer(String user) {
        return repository.findByProjectProposer(user);
    }

    public List<Invite> findByProject(UUID project) {
        return repository.findByProject(project);
    }

}
