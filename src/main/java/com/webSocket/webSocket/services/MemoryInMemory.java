package com.webSocket.webSocket.services;

import com.webSocket.webSocket.exception.CustomErrors;
import com.webSocket.webSocket.exception.CustomException;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

@Component
public class MemoryInMemory {
    private Set<String> usernameList = new HashSet<>();

    @PostConstruct
    private void init() {
        usernameList.add("vdk");
    }

    public void createUser(String username, ModelAndView modelAndView) {
        modelAndView.addObject("username", username);
        if (!usernameList.contains(username)) {
            usernameList.add(username);
        } else {
            throw new CustomException(CustomErrors.ALREADY_EXIST, modelAndView);
        }
    }
}
