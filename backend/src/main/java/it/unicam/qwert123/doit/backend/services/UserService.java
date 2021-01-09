package it.unicam.qwert123.doit.backend.services;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.repositories.UserRepository;
import lombok.NonNull;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository repository;

    public User getUserById(@NonNull UUID id) {
        try {

            return repository.findById(id).get();
        } catch (NoSuchElementException e) {
            return null;
        }
    }

    public User getUserByMail(@NonNull String mail) {
        try {
            return repository.findByMail(mail);
        } catch (IndexOutOfBoundsException e) {
            return null;
        }
    }

    public User getUserByUsername(@NonNull String username) {
        try {
            return repository.findByUsername(username);
        } catch (IndexOutOfBoundsException e) {
            return null;
        }
    }

    public User getUserBySkills(@NonNull List<UUID> skills) {
        //TODO da fare
        return null;
    }


    public User addUser(@NonNull User newUser) {
        newUser.setId(UUID.randomUUID());
        return repository.insert(newUser);

    }

    public User updateUser(@NonNull User newUser) {
        if (repository.existsById(newUser.getId())) {
            return repository.save(newUser);
        } else {
            return null;
        }

    }

    public boolean deleteUser(@NonNull UUID id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        } else {
            return false;
        }
    }

    public boolean userExistsById(@NonNull String id) {
		return (getUserById(UUID.fromString(id)) == null ) ? false : true;
	}

    public boolean userExistsByMail(@NonNull String mail) {
		return (getUserByMail(mail) == null ) ? false : true;
    }

    @Override
    public UserDetails loadUserByUsername(String mail) throws UsernameNotFoundException {
        return getUserByMail(mail);
    }
}
