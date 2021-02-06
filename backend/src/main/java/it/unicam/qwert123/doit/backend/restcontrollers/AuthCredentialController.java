package it.unicam.qwert123.doit.backend.restcontrollers;

import java.security.Principal;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import it.unicam.qwert123.doit.backend.services.AuthCredentialService;
import it.unicam.qwert123.doit.backend.services.UserService;
import it.unicam.qwert123.doit.backend.utility.AccessCheckerComponent;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import it.unicam.qwert123.doit.backend.models.AuthCredential;
import it.unicam.qwert123.doit.backend.models.User;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@RestController
@RequestMapping("doit/api/authCredential")
public class AuthCredentialController {
	@Autowired
	private UserService userService;

	@Autowired
	private AuthCredentialService authService;

	@Autowired
	private AccessCheckerComponent accessCheckerComponent;

	@PreAuthorize("permitAll")
	@PostMapping("/login")
	public User loginWithCredentials(@RequestBody AuthCredential credentials) {
		return authService.loginWithCredentials(credentials) ? userService.findById(credentials.getId()) : null;
	}

	// TODO da testare e implementare il controllo dove serve
	@PutMapping("/updateCredential")
	public boolean updateCredentials(@RequestBody AuthCredential authCredentials, Authentication authentication) {
	//	accessCheckerComponent.sameUser(authentication.get, authCredentials.getUsername());
		return authService.updateCredentials(authCredentials);
	}

	@PutMapping("/updateUser")
	public User updateUser(@RequestBody User user) {
		return userService.updateUser(user);
	}

	// TODO da testare l'authentication
	@PreAuthorize("hasAuthority('ADMIN')")
	@DeleteMapping("/deleteCredential")
	public boolean removeCredentials(Authentication authentication) {
		return authService.removeCredentials(authentication.getName());
	}

	@PostMapping("/addCredential")
	public boolean addCredential(@RequestBody AuthCredential credentials) {
		return authService.addCredentials(credentials);
	}

	@PostMapping("/addUser")
	public User addUser(@RequestBody User user, Authentication authentication) {
		user = userService.addUser(user);
		AuthCredential authCredential = authService.getAuthCredentialsInstance(user.getMail());
		authCredential.setRoles(user.getRoles());
		authCredential.setId(user.getId());
		updateCredentials(authCredential, authentication);
		return user;
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@GetMapping("/getAuthCredential")
	public Set<AuthCredential> getAuthCredential() {
		return authService.getAuthCredentials();
	}
}