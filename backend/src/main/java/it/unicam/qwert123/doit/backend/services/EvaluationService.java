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
    private EvaluationRepository evaluationRepository;

    private boolean checkEvaluation(Evaluation evaluation) {
        if (evaluation.getSender().isEmpty())
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid evaluation: Sender is null");
        if (evaluation.getProject() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid evaluation: Project is null");
        if (evaluation.getMessage().isEmpty())
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid evaluation: Message is null");
        if (evaluation.getEvaluationMode() == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid evaluation: Evaluation mode is null");

        return true;

    }

    public Evaluation addEvaluations(@NonNull Evaluation evaluation) {
        evaluation.setId(UUID.randomUUID());
        if (checkEvaluation(evaluation))
            return evaluationRepository.insert(evaluation);
        return null;
    }

    public boolean deleteEvaluations(@NonNull UUID id) {
        evaluationRepository.deleteById(id);
        return true;
    }

    public Evaluation updateEvaluation(@NonNull Evaluation evaluation) {
        if (checkEvaluation(evaluation))
            return evaluationRepository.save(evaluation);
        return null;
    }

    public Evaluation findById(@NonNull UUID id) throws ResponseStatusException {
        return evaluationRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Project not found"));
    }

    public List<Evaluation> findByIds(List<UUID> ids) {
        return StreamSupport.stream(evaluationRepository.findAllById(ids).spliterator(), false)
                .collect(Collectors.toList());
    }

    public List<Evaluation> findBySender(@NonNull String idSender) {
        return evaluationRepository.findBySender(idSender);
    }

    public List<Evaluation> findByProject(@NonNull UUID idProject) {
        return evaluationRepository.findByProject(idProject);
    }

}
