package it.unicam.qwert123.doit.backend.models;

import java.util.List;
import java.util.UUID;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

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

    public enum Role {
        PROJECT_PROPOSER, EXPERT, DESIGNER, ADMIN, NOT_COMPLETED
    }

    @EqualsAndHashCode.Include
    @Id
    private UUID id;
    private String username;
    private String name;
    private String surname;
    private String mail;
    private Role role;
    private List<UUID> tag;
    private List<UUID> projects;
    private String password = new BCryptPasswordEncoder().encode("Doit");
}
