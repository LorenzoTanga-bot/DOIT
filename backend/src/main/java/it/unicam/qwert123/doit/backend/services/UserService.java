package it.unicam.qwert123.doit.backend.services;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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
        if (user.getRoles().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid user: it must have a role");
        }
        if (user.isAPerson()) {
            for (Role role : user.getRoles()) {
                if (role == Role.PROJECT_PROPOSER) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "Invalid user: a person cannot be a project proposer");
                }
            }
        } else {
            for (Role role : user.getRoles()) {
                if (role == Role.EXPERT) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "Invalid user: a company cannot be an expert");
                }
            }
        }
        if (user.getTag().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid user: it must have at least one tag");
        }
        return true;
    }

    private boolean existById(UUID id) throws ResponseStatusException {
        if (repository.existsById(id))
            return true;
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
    }

    public User addUser(@NonNull User newUser) throws ResponseStatusException {
        newUser.setUsername(newUser.getUsername().toUpperCase().trim());
        if (repository.existsByUsername(newUser.getUsername()))
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Username already used");
        if (checkUser(newUser)) {
            newUser.setId(UUID.randomUUID());
            return repository.insert(newUser);
        }
        return null;
    }

    public User updateUser(User modifiedUser) throws ResponseStatusException {
        if (existById(modifiedUser.getId())) {
            if (repository.findById(modifiedUser.getId()).get().getUsername() == modifiedUser.getUsername()) {
                if (checkUser(modifiedUser)) {
                    return repository.save(modifiedUser);
                }
            } else
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Username cannot be changed");
        }
        return null;

    }

    public boolean deleteUser(@NonNull UUID id) throws ResponseStatusException {
        if (existById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }

    public User findById(@NonNull UUID id) throws ResponseStatusException {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public List<User> findByIds(@NonNull List<UUID> ids) {
        return repository.findByIds(ids);
    }

    public User findByMail(@NonNull String mail) throws ResponseStatusException {
        return repository.findByMail(mail)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
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
        return repository.findByTag(tag);
    }

    public List<User> findByTags(@NonNull List<UUID> tags) {
        return repository.findByTagContaining(tags);
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

    public boolean existsByMail(@NonNull String mail) {
        return (findByMail(mail) == null) ? false : true;
    }
}
