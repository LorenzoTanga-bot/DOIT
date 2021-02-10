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
    private String mail;
    private boolean isAPerson;
    private String username;
    private String usernameToShow;
    private String name;
    private String surname; //se è un azienda, qui viene memorizzata la partita iva
    private List<Role> roles;
    private List<UUID> tags;
    private List<UUID> proposedProjects;
    private List<UUID> supportedProjects;
    private List<UUID> evaluations;

    public boolean addProposedProjects(UUID idProject) {
        return proposedProjects.add(idProject);
    }

    public boolean removeProposedProjects(UUID idProject) {
        return  proposedProjects.remove(idProject);
    }

    public boolean addSupportedProjects(UUID idProject) {
        return supportedProjects.add(idProject);
    }

    public boolean removeSupportedProjects(UUID idProject) {
        return supportedProjects.remove(idProject);
    }

    public boolean addEvaluations(UUID idEvaluations) {
        return supportedProjects.add(idEvaluations);
    }

    public boolean removeEvaluationss(UUID idEvaluations) {
        return supportedProjects.remove(idEvaluations);
    }
}
