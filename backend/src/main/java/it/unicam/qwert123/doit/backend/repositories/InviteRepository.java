package it.unicam.qwert123.doit.backend.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Invite;

@Repository
public interface InviteRepository extends MongoRepository<Invite, UUID>{
    List<Invite> findBySender(String user);
    List<Invite> findByDesigner(String user);
    List<Invite> findByProjectProposer(String user);
    List<Invite> findByProject(UUID project);
}