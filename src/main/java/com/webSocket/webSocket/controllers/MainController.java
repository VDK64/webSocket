package com.webSocket.webSocket.controllers;

import com.webSocket.webSocket.dto.Message;
import com.webSocket.webSocket.dto.OutputMessage;
import com.webSocket.webSocket.exception.CustomErrors;
import com.webSocket.webSocket.exception.CustomException;
import com.webSocket.webSocket.services.MemoryInMemory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.config.SimpleBrokerRegistration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

@Controller
public class MainController {
    @Autowired
    private MemoryInMemory memoryInMemory;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @GetMapping("/")
    public String getIndex() {
        return "index";
    }

    @PostMapping("/")
    public String getIndex(@RequestParam String username, HttpServletRequest request) {
        memoryInMemory.createUser(username, new ModelAndView("index"));
        request.getSession().setAttribute("username", username);
        return "redirect:/messages";
    }

    @RequestMapping("/messages")
    public String getMessages(HttpServletRequest request) {
        String username = (String) request.getSession().getAttribute("username");
        request.getSession().removeAttribute("username");
        if (username == null)
            throw new CustomException(CustomErrors.USERNAME_NULL, new ModelAndView("messages"));
        return "messages";
    }

    @MessageMapping("/room")
    public void sendSpecific(@Payload Message msg) {
        OutputMessage out = new OutputMessage(msg.getFrom(), msg.getTo(), msg.getText(), new Date());
        simpMessagingTemplate.convertAndSendToUser(msg.getTo(), "/queue/updates", out);
    }
}
