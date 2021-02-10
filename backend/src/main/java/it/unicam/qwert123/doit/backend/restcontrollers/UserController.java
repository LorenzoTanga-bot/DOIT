package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    @GetMapping("/getByMail/{mail}")
    public User getUserById(@PathVariable("mail") String mail) {
            return service.findById(mail);
    }

    @GetMapping("/getByMails")
    public List<User> getUsersByIds(@RequestBody List<String> mails) {
        return service.findByIds(mails);
    }

    @GetMapping("/getByUsername/{role}/{username}")
    public List<User> getUsersByUsername(@PathVariable("username") String username, @PathVariable("role") String role) {
        switch (role) {
            case "DESIGNER":
                return service.findByUsername(username, Role.DESIGNER);
            case "PROJECT_PROPOSER":
                return service.findByUsername(username, Role.PROJECT_PROPOSER);
            case "null":
                return service.findByUsername(username);
            default:
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Path Variables");
        }
    }

    @GetMapping("/getByTag/{tag}")
    public List<User> getUsersByTag(@PathVariable("tag") String tag) {
        try {
            return service.findByTag(UUID.fromString(tag));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @GetMapping("/getByTags/{role}")
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
                return service.findByTags(idTag, Role.DESIGNER);
            case "PROJECT_PROPOSER":
                return service.findByTags(idTag, Role.PROJECT_PROPOSER);
            case "null":
                return service.findByTags(idTag);
            default:
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Path Variables");
        }
    }

    @GetMapping("/get")
    public List<User> getAllUsers() {
        return service.findAll();
    }


}

