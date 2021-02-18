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

import it.unicam.qwert123.doit.backend.models.Candidacy;
import it.unicam.qwert123.doit.backend.repositories.CandidacyRepository;

@Service
public class CandidacyService {
    @Autowired
    private CandidacyRepository repository;

    private boolean existsById(UUID id) throws ResponseStatusException {
        if (!repository.existsById(id))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Candidacy not found");
        return true;
    }

    private boolean checkCandidacy(Candidacy candidacy){
        if(candidacy.getProject() == null) 
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid candidacy: Project is null");
        if(candidacy.getDesigner() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid candidacy: User is null");
        if(candidacy.getDateOfCandidacy() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid candidacy: Date of Candidacy is null");
        
        return true;
    }

    public Candidacy addCandidacy(@NonNull Candidacy candidacy) throws ResponseStatusException  {
        if(checkCandidacy(candidacy)){
            candidacy.setId(UUID.randomUUID());
            return repository.insert(candidacy);
        }
        return null;
    }

    public boolean deleteCandidacy(@NonNull UUID id) throws ResponseStatusException {
        if(!existsById(id)) return false;
        repository.deleteById(id);
        return true;
    }

    public Candidacy updateCandidacy(@NonNull Candidacy candidacy) throws ResponseStatusException {
        if(existsById(candidacy.getId()) && checkCandidacy(candidacy)) return repository.save(candidacy);
        return null;
    }

    public Candidacy findById(@NonNull UUID id) throws ResponseStatusException {
        return repository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Candidacy not found"));
    }

    public List<Candidacy> findByIds(List<UUID> ids){
        return StreamSupport.stream(repository.findAllById(ids).spliterator(), false)
        .collect(Collectors.toList()); 
    }

    public List<Candidacy> findByDesigner(String user){
        return repository.findByDesigner(user);
    }

    public List<Candidacy> findByProjectProposer(String user){
        return repository.findByProjectProposer(user);
    }

    public List<Candidacy> findByProject(UUID project){
        return repository.findByProject(project);
    }

}
