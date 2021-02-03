package it.unicam.qwert123.doit.backend.restcontrollers;

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
class Person {
    private User user;
    private AuthCredential authCredential;
}

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
class Company {
    //private Entity entity;
    private AuthCredential authCredential;
}


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
    
    //TODO da testare e implementare il controllo dove serve
	@PutMapping("/update")
	public boolean updateCredentials(@RequestBody AuthCredential authCredentials, Authentication authentication) {
        accessCheckerComponent.sameUser(authentication.getDetails() instanceof UserDetails ? (UserDetails)authentication.getDetails() : null,  authCredentials.getUsername());
        return authService.updateCredentials(authCredentials);
    }

    //TODO da testare l'authentication 
    @PreAuthorize("hasAuthority('ADMIN')")
	@DeleteMapping("/delete")
	public boolean removeCredentials(Authentication authentication) {
		return authService.removeCredentials(authentication.getName());
	}
    
	@PostMapping("/addPerson")
	public boolean addPerson(@RequestBody Person user) {
		user.getAuthCredential().setId(userService.addUser(user.getUser()).getId());
		return authService.addCredentials(user.getAuthCredential());
    }
    
    @PostMapping("/addCompany")
	public boolean addCompany(@RequestBody Company company) {
		//TODO da fare per entity --> user.getAuthCredentials().setId(userService.addUser(user.getUser()).getId());
		return authService.addCredentials(company.getAuthCredential());
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@GetMapping("/getAuthCredential")
	public Set<AuthCredential> getAuthCredential() {
		return authService.getAuthCredentials();
	}
}