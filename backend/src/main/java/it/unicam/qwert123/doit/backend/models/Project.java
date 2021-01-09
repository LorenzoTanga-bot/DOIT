package it.unicam.qwert123.doit.backend.models;

import java.util.Date;
import java.util.UUID;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Document(collection = "project")
public class Project {
    @EqualsAndHashCode.Include

    @Id
    private UUID id;
    private UUID projectProposer;
    private List<UUID> tag;
    private Date dateOfCreation;
    private Date dateOfStart;
    private Date dateOfEnd;
    private String name;
    private String shortDescription;
    private boolean descriptionIsAFile;
    private String description; // if descriptionIsAFile is true, in this variable there will be saved the path of the file else the description
    private boolean evaluationMode; // if it's true, the project is in evaluation mode.
    private Date startEvaluation;
    private Date endEvaluation;
    private boolean candidacyMode; // if it's true, the project is in candidacy mode.
    private Date startCandidacy;
    private Date endCandidacy;

}
