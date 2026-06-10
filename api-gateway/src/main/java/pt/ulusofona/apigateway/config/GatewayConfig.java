package pt.ulusofona.apigateway.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    @Value("${SERVICES_USER_URL:http://localhost:8081}")
    private String userServiceUrl;

    @Value("${SERVICES_PRODUCT_URL:http://localhost:8082}")
    private String productServiceUrl;

    @Value("${SERVICES_ORDER_URL:http://localhost:8083}")
    private String orderServiceUrl;

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                .route("user-service", r -> r
                        .path("/api/users/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri(userServiceUrl))
                .route("product-service", r -> r
                        .path("/api/products/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri(productServiceUrl))
                .route("order-service", r -> r
                        .path("/api/orders/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri(orderServiceUrl))
                .build();
    }
}