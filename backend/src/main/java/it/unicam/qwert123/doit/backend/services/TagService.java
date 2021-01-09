package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import it.unicam.qwert123.doit.backend.models.Tag;
import it.unicam.qwert123.doit.backend.repositories.TagRepository;
import lombok.NonNull;

@Service
public class TagService {
    @Autowired
    private TagRepository repository;

    public Tag addTag(@NonNull Tag newTag){
        newTag.setId(UUID.randomUUID());
        return repository.insert(newTag);
    }

    public List<Tag> getAllTag(){
        return repository.findAll();
    }

    public boolean deleteTag(@NonNull UUID id){
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        } else {
            return false;
        }
    }
}
