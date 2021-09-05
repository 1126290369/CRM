package com.hwj.crm.settings.service.impl;

import com.hwj.crm.exception.LoginException;
import com.hwj.crm.settings.dao.UserDao;
import com.hwj.crm.settings.domain.User;
import com.hwj.crm.settings.service.UserService;
import com.hwj.crm.utils.DateTimeUtil;
import com.hwj.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public List<User> getUserList() {
        List<User> userList = userDao.getUserList();
        System.out.println("===============3");
        return userList;
    }
    @Override
    public User login(String login_user, String login_psw, String ip) throws LoginException {

        Map<String ,String > map = new HashMap<>();
        map.put("loginAct",login_user);
        map.put("loginPwd",login_psw);

        User user = userDao.login(map);

        if (user==null){
            throw new LoginException("账号密码错误");
        }
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号已经失效");
        }
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号被锁定");
        }
        String allowIps = user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("ip受限，无法登入");
        }
        return user;
    }
}
