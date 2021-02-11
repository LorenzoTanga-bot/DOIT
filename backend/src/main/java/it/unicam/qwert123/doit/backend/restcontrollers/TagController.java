package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.models.Tag;
import it.unicam.qwert123.doit.backend.services.TagService;

@RestController
@RequestMapping("doit/api/tag")
public class TagController {
    @Autowired
    private TagService service;

    @GetMapping("/get")
    public List<Tag> getAllTags() {
        return service.findAll();
    }

    @PostMapping("/new")
    public Tag addTag(@RequestBody Tag newTag) {
        return service.addTag(newTag);
    }

    @GetMapping("/getById/{id}")
    public Tag getTagById(@PathVariable("id") String id) {
        try {
            return service.findById(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @PutMapping("/getByIds")
    public List<Tag> getTagsByIds(@RequestBody List<String> ids) {
        List<UUID> uuidTag = new ArrayList<UUID>();
        for (String id : ids) {
            try {
                uuidTag.add(UUID.fromString(id));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        }
        return service.findByIds(uuidTag);
    }

}
