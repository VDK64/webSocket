package com.webSocket.webSocket.controllers;

import com.webSocket.webSocket.dto.Message;
import com.webSocket.webSocket.dto.OutputMessage;
import com.webSocket.webSocket.entities.User;
import com.webSocket.webSocket.services.MainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.util.Date;

@Controller
public class MainController {
    @Autowired
    private MainService mainservice;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @RequestMapping("/")
    public String getIndex() {
        return "index";
    }

    @RequestMapping("/messages")
    public String getMessages(Model model) {
        model.addAttribute("user", new User(""));
        return "messages";
    }

    @MessageMapping("/room")
    public void sendSpecific(@Payload Message msg, Principal principal, Model model) {
        model.addAttribute("user", new User(principal.getName()));
        OutputMessage out = new OutputMessage(msg.getFrom(), msg.getTo(), msg.getText(), new Date());
        simpMessagingTemplate.convertAndSendToUser(msg.getTo(), "/queue/updates", out);
    }

}
