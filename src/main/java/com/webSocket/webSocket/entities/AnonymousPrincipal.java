package com.webSocket.webSocket.entities;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;

import java.security.Principal;

@AllArgsConstructor
@EqualsAndHashCode
public class AnonymousPrincipal implements Principal {
    private String username;

    @Override
    public String getName() {
        return username;
    }
}
