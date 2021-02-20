package it.unicam.qwert123.doit.backend.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Candidacy;

@Repository
public interface CandidacyRepository extends MongoRepository<Candidacy, UUID>{

    List<Candidacy> findByDesigner(String user);
    List<Candidacy> findByProject(UUID project);
    List<Candidacy> findByProjectProposer(String user);
}
