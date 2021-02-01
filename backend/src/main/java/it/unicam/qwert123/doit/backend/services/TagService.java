package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.UUID;

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
        if(repository.existsByValue(newTag.getValue()))
            return repository.findByValue(newTag.getValue()).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "item not found"));
        
        newTag.setId(UUID.randomUUID());
        return repository.insert(newTag);
    }

    public List<Tag> findAll() {
        return repository.findAll();
    }

    public Tag findById(@NonNull UUID id) throws ResponseStatusException{
        return repository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag not found"));
    }
}
