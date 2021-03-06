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
@Document(collection = "invite")
public class Invite {
    @Id
    private UUID id;
    private String sender;
    private String designer;
    private String projectProposer;
    private UUID project;
    private StateInvite stateProjectProposer;
    private StateInvite stateDesigner;
    private Date dateOfInvite;
    private Date dateOfExpire;
    private String message;

    public enum StateInvite {
        WAITING, POSITIVE, NEGATIVE
    }

}
