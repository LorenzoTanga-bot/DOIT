package it.unicam.doit.backend.models;

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

public class Project{

    @EqualsAndHashCode.Include
    @Id
    private UUID id;
    private GregorianCalendar dateOfCreation;
    private String name;
    private String shortDescription;
    private boolean descriptionIsAFile;
    private String description; //if description is a file in this variable there will be saved the path of the file else the description

}