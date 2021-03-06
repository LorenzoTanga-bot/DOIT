package it.unicam.qwert123.doit.backend.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;

import it.unicam.qwert123.doit.backend.models.Evaluation;

public interface EvaluationRepository extends MongoRepository<Evaluation, UUID> {
    List<Evaluation> findBySender(String sender);

    List<Evaluation> findByProject(UUID projet);
}
