package it.unicam.qwert123.doit.backend.restcontrollers;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import it.unicam.qwert123.doit.backend.models.Tag;
import it.unicam.qwert123.doit.backend.models.User;
import it.unicam.qwert123.doit.backend.services.UserService;

@RestController
@RequestMapping("doit/api/user")
public class UserController {

    @Autowired
    private UserService service;

    @PostMapping("/new")
    //@PreAuthorize("hasAuthority('ADMIN')")
    public User addUser(@RequestBody User newUser){
        return service.addUser(newUser);
    }

    @PutMapping("/update")
    //@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('PROJECT_PROPOSER') or hasAuthority('EXPERT') or hasAuthority('DESIGNER') or hasAuthority('NOT_COMPLETED')")
    public User updatUser(@RequestBody User newUser){
        return service.updateUser(newUser);
    }

    @GetMapping("/id/{id}")
	public User getUserById(@PathVariable("id") String id) {
		return service.findById(UUID.fromString(id));
	}

    @GetMapping("/mail/{mail}") 
	public User getUserByMail(@PathVariable("mail") String mail) {
		return service.findByMail(mail);
    }
    
    @GetMapping("/username/{username}")
	public User getUserByUsername(@PathVariable("username") String username) {
		return service.findByUsername(username);
	}

    @GetMapping("/exists/{mail}")
	public boolean userExistsByMail(@PathVariable("mail") String mail) {
		return service.userExistsByMail(mail);
    }
    @GetMapping("/tag") 
	public List<User> getUsersByTags(@RequestBody List<Tag> tags) {
        List<UUID> idTag=new ArrayList<UUID>();
        for(Tag tag : tags ){
            idTag.add(tag.getId());
}
		return service.findByTag(idTag);
    }
}
