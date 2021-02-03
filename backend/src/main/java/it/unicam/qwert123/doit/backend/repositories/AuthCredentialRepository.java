package it.unicam.qwert123.doit.backend.repositories;

import it.unicam.qwert123.doit.backend.models.AuthCredential;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuthCredentialRepository extends MongoRepository<AuthCredential, String> {

}
