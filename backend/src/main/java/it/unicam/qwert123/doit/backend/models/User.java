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
    private boolean isAPerson;
    private String username;
    private String usernameToShow;
    private String name;
    private String surname; //se è un azienda, qui viene memorizzata la partita iva
    private String mail;
    private List<Role> roles;
    private List<UUID> tags;
    private List<UUID> projectsFirstRole;
    private List<UUID> projectsSecondRole;

    public boolean addProjectToFirstRole(UUID idProject) {
        return projectsFirstRole.add(idProject);
    }

    public boolean removeProjectToFirstRole(UUID idProject) {
        return  projectsFirstRole.remove(idProject);
    }

    public boolean addProjectToSecondRole(UUID idProject) {
        return projectsSecondRole.add(idProject);
    }

    public boolean removeProjectToSecondRole(UUID idProject) {
        return projectsSecondRole.remove(idProject);
    }
}
