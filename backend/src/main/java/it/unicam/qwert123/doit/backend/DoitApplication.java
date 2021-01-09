package it.unicam.qwert123.doit.backend;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import it.unicam.qwert123.doit.backend.services.UserService;

@SpringBootApplication
public class DoitApplication implements CommandLineRunner {
	@Autowired
	UserService service;

	public static void main(String[] args) {
		SpringApplication.run(DoitApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		System.out.println("___________________________________________________");
	}

}
