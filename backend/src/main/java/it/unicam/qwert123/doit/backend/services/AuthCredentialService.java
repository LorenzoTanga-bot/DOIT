package it.unicam.qwert123.doit.backend.services;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import it.unicam.qwert123.doit.backend.models.AuthCredential;
import it.unicam.qwert123.doit.backend.models.AuthCredential.Role;
import it.unicam.qwert123.doit.backend.repositories.AuthCredentialRepository;
import lombok.NonNull;

@Service
public class AuthCredentialService implements UserDetailsService {
	@Autowired
	private AuthCredentialRepository repository;

	public boolean loginWithCredentials(@NonNull AuthCredential authCredentials) throws ResponseStatusException {
		AuthCredential serverAuthCredentials = getAuthCredentialsInstance(authCredentials.getMail());
		if (serverAuthCredentials != null && new BCryptPasswordEncoder().matches(authCredentials.getPassword(),
				serverAuthCredentials.getPassword())) {
			return true;
		}
		throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid login");
	}

	public boolean addCredentials(@NonNull AuthCredential authCredentials) throws ResponseStatusException {
		authCredentials.setRoles(Arrays.asList(new Role[]{Role.NOT_COMPLETED}));
		authCredentials.setPassword(new BCryptPasswordEncoder().encode(authCredentials.getPassword()));
		if (repository.existsById(authCredentials.getMail())) 
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid signin");
		
		repository.insert(authCredentials);
		return true;
	}

	public boolean updateCredentials(@NonNull AuthCredential authCredentials) {
		if (!repository.existsById(authCredentials.getMail())) 
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid update");
		
		authCredentials.setPassword(new BCryptPasswordEncoder().encode(authCredentials.getPassword()));
		repository.save(authCredentials);
		return true;
	}

	public boolean updateRolesCredential(@NonNull AuthCredential authCredentials) {
		if (!repository.existsById(authCredentials.getMail())) 
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid update");
		
		repository.save(authCredentials);
		return true;
	}

	public boolean removeCredentials(@NonNull String mail) {
		if (!repository.existsById(mail)) 
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid update");
		
		repository.delete(getAuthCredentialsInstance(mail));
		return true;
	}

	public Set<AuthCredential> getAuthCredentials() {
		return new HashSet<AuthCredential>(repository.findAll());
	}

	public AuthCredential getAuthCredentialsInstance(@NonNull String mail) {
		return repository.findById(mail)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Credential not found"));

	}

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		return getAuthCredentialsInstance(username);
	}

	public boolean existsById(String id) {
		return repository.existsById(id);
	}
}
