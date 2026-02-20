package com.cardcompass.cardcompass;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling  // enables MonthlyReportScheduler
public class CardcompassApplication extends SpringBootServletInitializer {

	// Required for WAR packaging
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(CardcompassApplication.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(CardcompassApplication.class, args);
	}
}