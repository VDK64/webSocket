package com.webSocket.webSocket.services;

import com.webSocket.webSocket.exception.CustomErrors;
import com.webSocket.webSocket.exception.CustomException;
import lombok.Getter;
import lombok.Setter;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;

import javax.annotation.PostConstruct;
import java.io.ObjectStreamClass;
import java.util.*;

@Component
@Getter
public class MemoryInMemory {
    private Set<String> usernameList = new HashSet<>();
    private String username;
    private Map<String, String> userSession = new HashMap<>();

    @PostConstruct
    private void init() {
        usernameList.add("vdk");
    }

    public void createUser(String username, ModelAndView modelAndView) {
        modelAndView.addObject("username", username);
        if (!usernameList.contains(username)) {
            usernameList.add(username);
            this.username = username;
        } else {
            throw new CustomException(CustomErrors.ALREADY_EXIST, modelAndView);
        }
    }

    @EventListener
    public void deleteUser(SessionDisconnectEvent event) {
        String username = getKeyByValue(event.getSessionId());
        usernameList.remove(username);
        userSession.remove(username);
    }

    @EventListener
    public void setSessionId(SessionSubscribeEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String simpSessionId = (String) headerAccessor.getHeader("simpSessionId");
        userSession.put(username, simpSessionId);
    }

    private String getKeyByValue(String value) {
        for (Map.Entry<String, String> map : userSession.entrySet()) {
            if (map.getValue().equals(value))
                return map.getKey();
        }
        return null;
    }
}
