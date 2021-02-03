package it.unicam.qwert123.doit.backend.utility;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
public class AccessCheckerComponent {
    
    public boolean sameUser(UserDetails principal, String userMail) {
		return principal.getUsername().equals(userMail);
	}
}
