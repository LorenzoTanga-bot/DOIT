package it.unicam.qwert123.doit.backend.services;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.stereotype.Service;

import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.models.AuthCredential.Role;
import it.unicam.qwert123.doit.backend.repositories.UserRepository;
import lombok.NonNull;

@Service
public class UserService {

    @Autowired
    private UserRepository repository;

    private boolean checkUser(User user) {
        if (user.getTags().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid user: it must have at least one tag");
        }
        if (user.getRoles().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid user: it must have at least one role");
        }
        if (user.getRoles().contains(Role.DESIGNER_PERSON)
                && (user.getRoles().contains(Role.DESIGNER_ENTITY) || user.getRoles().contains(Role.PROJECT_PROPOSER)))
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid user: invalid roles");

        if (user.getRoles().contains(Role.DESIGNER_ENTITY)
                && (user.getRoles().contains(Role.DESIGNER_PERSON) || user.getRoles().contains(Role.EXPERT)))
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid user: invalid roles");

        return true;
    }

    private boolean existById(String id) throws ResponseStatusException {
        if (repository.existsById(id))
            return true;
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
    }

    public User addUser(@NonNull User newUser) throws ResponseStatusException {
        return repository.insert(newUser);
    }

    public User addFirstAccess(@NonNull User newUser) throws ResponseStatusException {
        newUser.setUsername(newUser.getUsernameToShow().toUpperCase().trim());
        if (existById(newUser.getMail()) && checkUser(newUser))
            return repository.save(newUser);
        return null;
    }

    public User updateUser(User modifiedUser) throws ResponseStatusException {
        modifiedUser.setUsername(modifiedUser.getUsernameToShow().toUpperCase().trim());
        User oldUser=repository.findById(modifiedUser.getMail()).get();
        if (existById(modifiedUser.getMail())) {
            if (oldUser.getUsername().equals(modifiedUser.getUsername())) {
                if (checkUser(modifiedUser)) {
                    return repository.save(modifiedUser);
                }
            } else
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Username cannot be changed");
        }
        return null;
    }

    public boolean deleteUser(@NonNull String id) throws ResponseStatusException {
        if (existById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }

    public User findById(@NonNull String id) throws ResponseStatusException {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public List<User> findByIds(@NonNull List<String> ids) {
        return StreamSupport.stream(repository.findAllById(ids).spliterator(), false).collect(Collectors.toList());
    }

    public List<User> findByUsername(@NonNull String username) throws ResponseStatusException {
        return repository.findByUsernameContaining(username.toUpperCase());
    }

    public List<User> findByUsername(@NonNull String username, Role role) throws ResponseStatusException {
        List<User> users = new ArrayList<User>();
        for (User user : findByUsername(username)) {
            if (user.getRoles().contains(role)) {
                users.add(user);
            }
        }
        return users;
    }

    public List<User> findByTag(@NonNull UUID tag) {
        return repository.findByTags(tag);
    }

    public List<User> findByTags(@NonNull List<UUID> tags) {
        return repository.findByTagsContaining(tags);
    }

    public List<User> findByTags(@NonNull List<UUID> tags, Role role) {
        List<User> users = new ArrayList<User>();
        for (User user : findByTags(tags)) {
            if (user.getRoles().contains(role)) {
                users.add(user);
            }
        }
        return users;
    }

    public List<User> findAll() {
        return repository.findAll();
    }
}
