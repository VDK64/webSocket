package com.webSocket.webSocket.config;

import com.webSocket.webSocket.entities.AnonymousPrincipal;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

import java.security.Principal;
import java.util.Map;
import java.util.Random;

@Configuration
@EnableWebSocketMessageBroker
@EnableWebSocket
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/queue");
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/room")
                .setHandshakeHandler(new HandShakeHandler())
                .withSockJS();
    }

    private static class HandShakeHandler extends DefaultHandshakeHandler {
        private String[] usernameArray = {"vkd-", "karl-", "aleks-", "antony-", "franklin-", "alfred-"};
        private String[] usernamePostfix = {"064", "64", "23", "51", "000", "777"};

        private String createUsername() {
            Random random = new Random();
            return usernameArray[random.nextInt(usernameArray.length)] +
                    usernamePostfix[random.nextInt(usernamePostfix.length)];
        }

        @Override
        protected Principal determineUser(ServerHttpRequest request, WebSocketHandler wsHandler,
                                          Map<String, Object> attributes) {
            Principal principal = request.getPrincipal();
            if (principal == null) {
                return new AnonymousPrincipal(createUsername());
            } else {
                return principal;
            }
        }
    }
}

