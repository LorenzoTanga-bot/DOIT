package it.unicam.qwert123.doit.backend.models;

import java.util.List;
import java.util.UUID;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import it.unicam.qwert123.doit.backend.models.AuthCredential.Role;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Document(collection = "user")
public class User{

    @EqualsAndHashCode.Include
    @Id
    private UUID id;
    private String username;
    private String usernameToShow;
    private String name;
    private String surname;
    private String mail;
    private List<Role> roles;
    private List<UUID> tag;
    private List<UUID> projects;

    public boolean addProject(UUID idProject) {
        return projects.add(idProject);
    }

    public boolean removeProject(UUID idProject) {
        return projects.remove(idProject);
    }
}
