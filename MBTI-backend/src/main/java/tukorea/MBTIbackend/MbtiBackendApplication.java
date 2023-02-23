package tukorea.MBTIbackend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {"tukorea.MBTIbackend.comparison.mapper"})
public class MbtiBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(MbtiBackendApplication.class, args);
	}

}
