package it.unicam.qwert123.doit.backend.models;

import java.util.Date;
import java.util.UUID;

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
@Document(collection = "candidacy")
public class Candidacy {
    @Id
    private UUID id;
    private String designer;
    private String projectProposer;
    private UUID project;
    private Date dateOfCandidacy;
    private StateCandidacy state;
    private Date dateOfExpire;
    private String message;

    public enum StateCandidacy  {
        WAITING, POSITIVE, NEGATIVE
    } 
    
}
