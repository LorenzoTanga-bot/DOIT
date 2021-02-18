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
import it.unicam.qwert123.doit.backend.repositories.InviteRepository;

@Service
public class InviteService {
    @Autowired
    private InviteRepository repository;

    private boolean existsById(UUID id) throws ResponseStatusException {
        if (!repository.existsById(id))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "invite not found");
        return true;
    }

    private boolean checkInvite(Invite invite){
        if(invite.getProject() == null) 
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: Project is null");
        if(invite.getDesigner() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: User is null");
        if(invite.getDateOfInvite() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid invite: Date of invite is null");
        
        return true;
    }

    public Invite addInvite(@NonNull Invite invite) throws ResponseStatusException  {
        if(checkInvite(invite)){
            invite.setId(UUID.randomUUID());
            return repository.insert(invite);
        }
        return null;
    }

    public boolean deleteInvite(@NonNull UUID id) throws ResponseStatusException {
        if(!existsById(id)) return false;
        repository.deleteById(id);
        return true;
    }

    public Invite updateInvite(@NonNull Invite invite) throws ResponseStatusException {
        if(existsById(invite.getId()) && checkInvite(invite)) return repository.save(invite);
        return null;
    }

    public Invite findById(@NonNull UUID id) throws ResponseStatusException {
        return repository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Invite not found"));
    } 

    public List<Invite> findByIds(List<UUID> ids){
        return StreamSupport.stream(repository.findAllById(ids).spliterator(), false)
        .collect(Collectors.toList()); 
    }

    public List<Invite> findByDesigner(String user){
        return repository.findByDesigner(user);
    }

    public List<Invite> findByProjectProposer(String user){
        return repository.findByProjectProposer(user);
    }

    public List<Invite> findByProject(UUID project){
        return repository.findByProject(project);
    }

}
