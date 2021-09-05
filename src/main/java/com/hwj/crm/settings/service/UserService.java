package com.hwj.crm.settings.service;

import com.hwj.crm.exception.LoginException;
import com.hwj.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    List<User> getUserList();
    User login(String login_user, String login_psw, String ip) throws LoginException;
}
