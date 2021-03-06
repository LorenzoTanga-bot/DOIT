package it.unicam.qwert123.doit.backend.models;

import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Document(collection = "project")
public class Project {
    @EqualsAndHashCode.Include

    @Id
    private UUID id;
    private String projectProposer;
    private List<UUID> tag;
    private Date dateOfCreation;
    private Date dateOfStart;
    private Date dateOfEnd;
    private String name;
    private String shortDescription;
    private String description;
    private boolean evaluationMode; // if it's true, the project has evaluation mode.
    private Date startCandidacy;
    private Date endCandidacy;

    private List<String> designers;
    private List<UUID> projectEvaluations;
    private List<UUID> teamEvaluations;

    boolean getCandidacyMode() {
        Date now = new Date();
        return (now.before(endCandidacy) && now.after(startCandidacy));
    }

    boolean getEvaluationMode() {
        if (!evaluationMode)
            return evaluationMode;
        else
            return !getCandidacyMode();
    }

    public boolean addDesigner(String idDesigner) {
        return designers.add(idDesigner);
    }

    public boolean removeDesigner(String idDesigner) {
        return designers.remove(idDesigner);
    }

}
