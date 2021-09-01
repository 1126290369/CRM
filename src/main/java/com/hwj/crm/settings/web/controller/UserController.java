package com.hwj.crm.settings.web.controller;

import com.hwj.crm.settings.domain.User;
import com.hwj.crm.settings.service.UserService;
import com.hwj.crm.settings.service.impl.UserServiceImpl;
import com.hwj.crm.utils.MD5Util;
import com.hwj.crm.utils.PrintJson;
import com.hwj.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
        String login_user = request.getParameter("login_name");
        String login_psw = request.getParameter("login_psw");
        login_psw = MD5Util.getMD5(login_psw);
        String ip = request.getRemoteAddr();



        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());
        try {
            User user = service.login(login_user,login_psw,ip);

            request.getSession().setAttribute("user",user);

            //程序执行到这说明login（）有返回值，说明user不为空，登入成功
            PrintJson.printJsonFlag(response,true);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            Map<String ,Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);


        }


    }
}
