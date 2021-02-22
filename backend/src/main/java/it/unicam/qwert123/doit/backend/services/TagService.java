package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.models.Tag;
import it.unicam.qwert123.doit.backend.repositories.TagRepository;
import lombok.NonNull;

@Service
public class TagService {
    @Autowired
    private TagRepository repository;

    public Tag addTag(@NonNull Tag newTag) {
        newTag.setValue(newTag.getValue().toUpperCase().trim());
        if (newTag.getValue().matches("[a-zA-Z- ]+")) {
            if (repository.existsByValue(newTag.getValue()))
                return repository.findByValue(newTag.getValue()).get();
            newTag.setId(UUID.randomUUID());
            newTag.setValue(newTag.getValue());
            return repository.insert(newTag);
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tag value must have only alphabetic symbols");
    }

    public Tag findById(@NonNull UUID id) throws ResponseStatusException {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag not found"));
    }

    public List<Tag> findByIds(@NonNull List<UUID> ids) {
        return StreamSupport.stream(repository.findAllById(ids).spliterator(), false).collect(Collectors.toList());
    }

    public Tag findByValue(@NonNull String value) {
        value = value.toUpperCase().trim();
        return repository.findByValue(value)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag not found"));
    }

    public List<Tag> findAll() {
        return repository.findAll();
    }
}
