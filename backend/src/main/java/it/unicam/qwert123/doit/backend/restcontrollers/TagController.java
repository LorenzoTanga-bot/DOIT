package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import it.unicam.qwert123.doit.backend.models.Tag;
import it.unicam.qwert123.doit.backend.services.TagService;

@RestController
@RequestMapping("doit/api/tag")
public class TagController {
    @Autowired
    private TagService service;

    @GetMapping("/get")
    public List<Tag> getAllTag() {
        return service.getAllTag();
    }

    @PostMapping("/new")
    public Tag addTag(@RequestBody Tag newTag) {
        return service.addTag(newTag);
    }
}
