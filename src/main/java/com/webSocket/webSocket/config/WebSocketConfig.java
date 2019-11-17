package com.webSocket.webSocket.config;

import com.webSocket.webSocket.entities.AnonymousPrincipal;
import com.webSocket.webSocket.services.MemoryInMemory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

import java.security.Principal;
import java.util.Map;

@Configuration
@EnableWebSocketMessageBroker
@EnableWebSocket
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    @Autowired
    private HandShakeHandler handShakeHandler;

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/queue");
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/room")
                .setHandshakeHandler(handShakeHandler)
                .withSockJS();
    }

    @Component
    private class HandShakeHandler extends DefaultHandshakeHandler {
        @Autowired
        private MemoryInMemory memoryInMemory;

        @Override
        protected Principal determineUser(ServerHttpRequest request, WebSocketHandler wsHandler,
                                          Map<String, Object> attributes) {
            Principal principal = request.getPrincipal();
            if (principal == null) {
                return new AnonymousPrincipal(memoryInMemory.getUsername());
            } else {
                return principal;
            }
        }
    }
}

