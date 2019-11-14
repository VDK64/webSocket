package com.webSocket.webSocket.services;

import com.webSocket.webSocket.exception.CustomErrors;
import com.webSocket.webSocket.exception.CustomException;
import lombok.Getter;
import lombok.Setter;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import javax.annotation.PostConstruct;
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

    @EventListener
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
        usernameList.remove(event.)
    }
}
