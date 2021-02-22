package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.models.Evaluation;
import it.unicam.qwert123.doit.backend.repositories.EvaluationRepository;
import lombok.NonNull;

@Service
public class EvaluationService {
    
    @Autowired
    private EvaluationRepository repository;
     
    public Evaluation addEvaluations(@NonNull Evaluation evaluation){
        return repository.insert(evaluation);
    }

    public boolean deleteEvaluations(@NonNull UUID id){
        repository.deleteById(id);
        return true;
    }

    public Evaluation updateEvaluation(@NonNull Evaluation evaluation){
        return repository.save(evaluation);
    }

    public Evaluation findById(@NonNull UUID id) throws ResponseStatusException {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Project not found"));
    }
    
    public List<Evaluation> findByIds(List<UUID> ids) {
        return StreamSupport.stream(repository.findAllById(ids).spliterator(), false).collect(Collectors.toList());
    }

    public List<Evaluation> findBySender(@NonNull String idSender) {
        return repository.findBySender(idSender);
    }

    public List<Evaluation> findByProject(@NonNull UUID idProject) {
        return repository.findByProject(idProject);
    }


	}
