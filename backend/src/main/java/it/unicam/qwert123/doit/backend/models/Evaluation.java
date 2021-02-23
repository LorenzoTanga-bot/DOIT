package it.unicam.qwert123.doit.backend.models;

import java.util.UUID;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Document(collection = "evaluation")
public class Evaluation {
    @Id
    private UUID id;
    private String sender; 
    private UUID project;
    private String message;
    private EvaluationMode evaluationMode;
    

    public enum EvaluationMode {
        PROJECT, TEAM
    }

}
