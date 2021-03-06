package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import it.unicam.qwert123.doit.backend.services.AuthCredentialService;
import it.unicam.qwert123.doit.backend.services.UserService;
import it.unicam.qwert123.doit.backend.utility.AccessCheckerComponent;
import it.unicam.qwert123.doit.backend.utility.JwtUtil;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import it.unicam.qwert123.doit.backend.models.AuthCredential;
import it.unicam.qwert123.doit.backend.models.User;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
class TokenUser {
	private String token;
	private User user;
}

@RestController
@RequestMapping("doit/api/authCredential")
public class AuthCredentialController {
	@Autowired
	private UserService userService;

	@Autowired
	private AuthCredentialService authService;

	@Autowired
	private JwtUtil jwtUtil;

	// NON ELIMINARE
	@Autowired
	private AccessCheckerComponent accessCheckerComponent;

	@PostMapping("/public/login")
	@PreAuthorize("permitAll")
	public TokenUser loginWithCredentials(@RequestBody AuthCredential credentials) {
		return authService.loginWithCredentials(credentials)
				? new TokenUser(jwtUtil.generateToken(authService.loadUserByUsername(credentials.getMail())),
						userService.findById(credentials.getMail()))
				: null;

	}

	@PostMapping("/public/addCredential")
	@PreAuthorize("permitAll")
	public TokenUser addCredential(@RequestBody AuthCredential credentials) {
		authService.addCredentials(credentials);
		User newUser = new User();
		newUser.setMail(credentials.getMail());
		newUser.setRoles(credentials.getRoles());
		return new TokenUser(jwtUtil.generateToken(authService.loadUserByUsername(credentials.getMail())),
				userService.addUser(newUser));
	}

	@PostMapping("/addUser")
	@PreAuthorize("@accessCheckerComponent.sameUser(principal, #user.getMail()) or hasAuthority('ADMIN')")
	public User addUser(@RequestBody @Param("user") User user) {
		User newUser = userService.addFirstAccess(user);
		AuthCredential authCredential = authService.getAuthCredentialsInstance(user.getMail());
		authCredential.setRoles(newUser.getRoles());
		authService.updateRolesCredential(authCredential);
		return newUser;
	}

	@PutMapping("/updateCredential")
	@PreAuthorize("@accessCheckerComponent.sameUser(principal, #authCredential.getMail()) or hasAuthority('ADMIN')")
	public boolean updateCredentials(@RequestBody @Param("authCredential") AuthCredential authCredential) {
		return authService.updateCredentials(authCredential);
	}

	@PutMapping("/updateUser")
	@PreAuthorize("@accessCheckerComponent.sameUser(principal, #user.getMail()) or hasAuthority('ADMIN')")
	public User updateUser(@RequestBody @Param("user") User user) {
		return userService.updateUser(user);
	}

	@DeleteMapping("/deleteCredential")
	@PreAuthorize("@accessCheckerComponent.sameUser(principal, #authCredential.getUsername()) or hasAuthority('ADMIN')")
	public boolean removeCredentials(@RequestBody @Param("authCredential") AuthCredential authentication) {
		return authService.removeCredentials(authentication.getMail());
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@GetMapping("/getAuthCredential")
	public Set<AuthCredential> getAuthCredential() {
		return authService.getAuthCredentials();
	}

	@GetMapping("/public/existsById/{id}")
	@PreAuthorize("permitAll")
	public boolean existsByMail(@PathVariable("id") String id) {
		return authService.existsById(id);
	}

}