package com.webSocket.webSocket.exception;

import lombok.Getter;
import org.springframework.web.servlet.ModelAndView;

@Getter
public class CustomException extends RuntimeException {
    private ModelAndView modelAndView;
    public CustomException(String message, ModelAndView modelAndView) {
        super(message);
        this.modelAndView = modelAndView;
    }
}
