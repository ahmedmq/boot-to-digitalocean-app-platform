package com.ahmedmq.digitalocean.app;

import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.hamcrest.Matchers;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest
class CustomerControllerTest {

	@Autowired
	MockMvc mockMvc;

	@MockBean
	CustomerRepository customerRepository;

	@Autowired
	ObjectMapper objectMapper;

	@Test
	void postCustomer_shouldCreateCustomer() throws Exception {

		Customer customerRequest = new Customer(null, "Mark", "Wood", "mark.wood@gmail.com");


		String json = objectMapper.writeValueAsString(customerRequest);

		when(customerRepository.save(any(Customer.class))).thenAnswer(answer -> {
			Customer response = answer.getArgument(0, Customer.class);
			response.setId(1L);
			return response;
		});

		mockMvc.perform(MockMvcRequestBuilders
						.post("/api/customer").content(json)
						.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.firstName", Matchers.is("Mark")))
				.andExpect(jsonPath("$.lastName", Matchers.is("Wood")))
				.andExpect(jsonPath("$.email", Matchers.is("mark.wood@gmail.com")));

	}

	@Test
	void getAllCustomer_shouldReturnAllCustomers() throws Exception {

		List<Customer> allCustomers = List.of(new Customer(1L, "Mark", "Wood", "mark.wood@gmail.com"),
				new Customer(2L,"ethna", "hawke", "ethan.hawke@gmail.com"));

		String json = objectMapper.writeValueAsString(allCustomers);

		when(customerRepository.findAll()).thenReturn(allCustomers);

		mockMvc.perform(MockMvcRequestBuilders.get("/api/customer"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.size()", Matchers.is(2)))
				.andExpect(content().json(json));

	}
}