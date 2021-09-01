package com.hwj.crm.settings.dao;

import com.hwj.crm.settings.domain.User;

import java.util.Map;

public interface UserDao {
    User login(Map<String, String> map);
}
