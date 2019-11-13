package com.webSocket.webSocket.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class OutputMessage {
    private String from;
    private String to;
    private String text;
    private Date date;
}
