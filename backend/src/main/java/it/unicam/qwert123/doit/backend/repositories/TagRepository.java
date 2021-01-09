package it.unicam.qwert123.doit.backend.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Tag;

@Repository
public interface TagRepository extends MongoRepository<Tag, UUID> {
    List<Tag> findByValue(String value);
}
