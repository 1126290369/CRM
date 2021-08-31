package com.hwj.crm.settings.web.controller;

import com.hwj.crm.settings.service.UserService;
import com.hwj.crm.settings.service.impl.UserServiceImpl;
import com.hwj.crm.utils.MD5Util;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }else if ("/settings/user/xxx.do".equals(path)){

        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        String login_user = request.getParameter("login_user");
        String login_psw = request.getParameter("login_psw");
        login_psw = MD5Util.getMD5(login_psw);
        String ip = request.getRemoteAddr();
        UserService userService = new UserServiceImpl();


    }
}
