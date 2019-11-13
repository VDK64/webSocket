package com.webSocket.webSocket.controllers;

import com.webSocket.webSocket.dto.Message;
import com.webSocket.webSocket.dto.OutputMessage;
import com.webSocket.webSocket.exception.CustomErrors;
import com.webSocket.webSocket.exception.CustomException;
import com.webSocket.webSocket.services.MemoryInMemory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    public String getIndex(@RequestParam String username, RedirectAttributes redirectAttributes) {
        memoryInMemory.createUser(username, new ModelAndView("index"));
        redirectAttributes.addFlashAttribute("username", username);
        return "redirect:/messages";
    }

    @RequestMapping("/messages")
    public String getMessages(@RequestParam(required = false) String username) {
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
