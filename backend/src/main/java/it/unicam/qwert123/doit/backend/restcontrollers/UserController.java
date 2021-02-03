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

import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.models.AuthCredential.Role;
import it.unicam.qwert123.doit.backend.services.UserService;

@RestController
@RequestMapping("doit/api/user")
public class UserController {

    @Autowired
    private UserService service;

    @PostMapping("/new")
    public User addUser(@RequestBody User newUser) {
        return service.addUser(newUser);
    }

    @PutMapping("/update")
    public User updateUser(@RequestBody User newUser) {
        return service.updateUser(newUser);
    }

    @GetMapping("/id/{id}")
    public User getUserById(@PathVariable("id") String id) {
        try {
            return service.findById(UUID.fromString(id));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @GetMapping("/ids")
    public List<User> getUsersByIds(@RequestBody List<String> ids) {
        List<UUID> uuidIds = new ArrayList<UUID>();
        for (String id : ids) {
            try {
                uuidIds.add(UUID.fromString(id));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        }
        return service.findByIds(uuidIds);
    }

    @GetMapping("/mail/{mail}")
    public User getUserByMail(@PathVariable("mail") String mail) {
        return service.findByMail(mail);
    }

    @GetMapping("/username/{role}/{username}")
    public List<User> getUsersByUsername(@PathVariable("username") String username, @PathVariable("role") String role) {
        switch (role) {
            case "DESIGNER":
                return service.findByUsername(username, Role.PROJECT_PROPOSER);
            case "EXPERT":
                return service.findByUsername(username, Role.PROJECT_PROPOSER);
            case "PROJECT_PROPOSER":
                return service.findByUsername(username, Role.PROJECT_PROPOSER);
            case "null":
                return service.findByUsername(username);
            default:
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Path Variables");
        }
    }

    @GetMapping("/tag/{tag}")
    public List<User> getUsersByTag(@PathVariable("tag") String tag) {
        try {
            return service.findByTag(UUID.fromString(tag));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @GetMapping("/tags/{role}")
    public List<User> getUsersByTags(@RequestBody List<String> tags, @PathVariable("role") String role) {
        List<UUID> idTag = new ArrayList<UUID>();
        for (String tag : tags) {
            try {
                idTag.add(UUID.fromString(tag));
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
            }
        }
        switch (role) {
            case "DESIGNER":
                return service.findByTags(idTag, Role.PROJECT_PROPOSER);
            case "EXPERT":
                return service.findByTags(idTag, Role.PROJECT_PROPOSER);
            case "PROJECT_PROPOSER":
                return service.findByTags(idTag, Role.PROJECT_PROPOSER);
            case "null":
                return service.findByTags(idTag);
            default:
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Path Variables");
        }
    }

    @GetMapping("/exists/{mail}")
    public boolean userExistsByMail(@PathVariable("mail") String mail) {
        return service.existsByMail(mail);
    }
}
