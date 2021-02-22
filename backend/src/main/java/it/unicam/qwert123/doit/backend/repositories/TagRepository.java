package it.unicam.qwert123.doit.backend.repositories;

import java.util.UUID;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Tag;



@Repository
public interface TagRepository extends MongoRepository<Tag, UUID> {
    Optional<Tag> findById(UUID id);
 

    Optional<Tag> findByValue(String value);

    boolean existsByValue(String value);

}
