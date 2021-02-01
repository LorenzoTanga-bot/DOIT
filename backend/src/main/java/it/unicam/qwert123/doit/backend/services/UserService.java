package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.stereotype.Service;

import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.repositories.UserRepository;
import lombok.NonNull;

@Service
public class UserService{

    @Autowired
    private UserRepository repository;

    private boolean existById(UUID id) throws ResponseStatusException {
        if(repository.existsById(id)) return true;
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"); 
    }
    public User findById(@NonNull UUID id) throws ResponseStatusException {
       return repository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public User findByMail(@NonNull String mail) throws ResponseStatusException {
        return repository.findByMail(mail).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public User findByUsername(@NonNull String username) throws ResponseStatusException {
        return repository.findByUsername(username).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public List<User> findByTag(@NonNull List<UUID> tags) {
        return repository.findByTags(tags);
    }


    public User addUser(@NonNull User newUser) {
        newUser.setId(UUID.randomUUID());
        return repository.insert(newUser);

    }

    public User updateUser(@NonNull User newUser) throws ResponseStatusException{
        return existById(newUser.getId()) ? repository.save(newUser): null;

    }

    public boolean deleteUser(@NonNull UUID id) throws ResponseStatusException {
        if (existById(id)) {
            repository.deleteById(id);
            return true;
        } 
        return false;
    }

    public boolean userExistsById(@NonNull String id) {
		return (findById(UUID.fromString(id)) == null ) ? false : true;
	}

    public boolean userExistsByMail(@NonNull String mail) {
		return (findByMail(mail) == null ) ? false : true;
    }
}
