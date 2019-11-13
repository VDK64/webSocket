package com.webSocket.webSocket.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class CustomHandler {

    @ExceptionHandler(CustomException.class)
    public ModelAndView handleServerErrors(CustomException serverExceptions) {
        ModelAndView model = serverExceptions.getModelAndView();
        model.addObject("error", serverExceptions.getMessage());
        return model;
    }
}
