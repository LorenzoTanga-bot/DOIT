package it.unicam.qwert123.doit.backend.models;

import java.util.ArrayList;
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
public class User {

    @EqualsAndHashCode.Include
    @Id
    private String mail;
    private String username;
    private String usernameToShow;
    private String name;
    private String surname; // se è un azienda, qui viene memorizzata la partita iva
    private List<Role> roles;
    private List<UUID> tags = new ArrayList<>();
    private List<UUID> proposedProjects = new ArrayList<>();
    private List<UUID> partecipateInProjects = new ArrayList<>();
    private List<UUID> invites = new ArrayList<>();
    private List<UUID> candidacies = new ArrayList<>();
    private List<UUID> evaluations = new ArrayList<>();

    public boolean addPProposedProject(UUID idProject) {
        return proposedProjects.add(idProject);
    }

    public boolean removeProposedProjects(UUID idProject) {
        return proposedProjects.remove(idProject);
    }

    public boolean addPartecipateInProject(UUID idProject) {
        return partecipateInProjects.add(idProject);
    }

    public boolean removepPrtecipateInProject(UUID idProject) {
        return partecipateInProjects.remove(idProject);
    }

    public boolean addEvaluations(UUID idEvaluations) {
        return evaluations.add(idEvaluations);
    }

    public boolean removeEvaluationss(UUID idEvaluations) {
        return evaluations.remove(idEvaluations);
    }

    public boolean addCandidacy(UUID idCandidacy) {
        return candidacies.add(idCandidacy);
    }

    public boolean removeCandidacy(UUID idCandidacy) {
        return candidacies.remove(idCandidacy);
    }

    public boolean addInvite(UUID idInvite) {
        return invites.add(idInvite);
    }

    public boolean removeInvite(UUID idInvite) {
        return invites.remove(idInvite);
    }
}
