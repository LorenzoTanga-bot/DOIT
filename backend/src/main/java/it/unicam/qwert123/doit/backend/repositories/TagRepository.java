package it.unicam.qwert123.doit.backend.repositories;

import java.util.UUID;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import it.unicam.qwert123.doit.backend.models.Tag;

@Repository
public interface TagRepository extends MongoRepository<Tag, UUID> {
    Optional<Tag> findById(UUID id);

    default List<Tag> findByIds(List<UUID> ids) {
        List<Tag> listTag = new ArrayList<Tag>();
        Tag tag;
        for (UUID id : ids) {
            tag = findById(id).orElse(null);
            if (tag != null)
                listTag.add(tag);
        }
        return listTag;
    }

    Optional<Tag> findByValue(String value);

    boolean existsByValue(String value);

}
