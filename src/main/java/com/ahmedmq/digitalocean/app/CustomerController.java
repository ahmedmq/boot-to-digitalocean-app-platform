package com.ahmedmq.digitalocean.app;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/customer")
public class CustomerController {

	private final CustomerRepository customerRepository;

	public CustomerController(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}


	@GetMapping
	public List<Customer> getAllCustomers(){
		return this.customerRepository.findAll();
	}

	@PostMapping
	public Customer createCustomer(@RequestBody Customer customer){
		return customerRepository.save(customer);
	}
}
