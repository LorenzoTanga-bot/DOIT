package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.services.UserService;

@RestController
@RequestMapping("doit/api/user")
public class UserController {

    @Autowired
    private UserService service;

    @PostMapping("/new")
    public User addUser(@RequestBody User newUser){
        return service.addUser(newUser);
    }

    @PutMapping("/update")
    public User updatUser(@RequestBody User newUser){
        return service.updateUser(newUser);
    }

    @GetMapping("/id/{id}")
	public User getUserById(@PathVariable("id") String id) {
		return service.getUserById(UUID.fromString(id));
	}

    @GetMapping("/mail/{mail}") 
	public User getUserByMail(@PathVariable("mail") String mail) {
		return service.getUserByMail(mail);
    }
    
    @GetMapping("/username/{username}")
	public User getUserByUsername(@PathVariable("username") String username) {
		return service.getUserByUsername(username);
	}

    @GetMapping("/exists/{mail}")
	public boolean userExistsByMail(@PathVariable("mail") String mail) {
		return service.userExistsByMail(mail);
	}
}
