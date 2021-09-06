package com.hwj.crm.workbench.web.controller;

import com.hwj.crm.settings.domain.User;
import com.hwj.crm.settings.service.UserService;
import com.hwj.crm.settings.service.impl.UserServiceImpl;
import com.hwj.crm.utils.DateTimeUtil;
import com.hwj.crm.utils.PrintJson;
import com.hwj.crm.utils.ServiceFactory;
import com.hwj.crm.utils.UUIDUtil;
import com.hwj.crm.vo.ActivityListVo;
import com.hwj.crm.workbench.domain.Activity;
import com.hwj.crm.workbench.service.ActivityService;
import com.hwj.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        System.out.println("====================1");
        if ("/workbench/activity/getUserList.do".equals(path)){
            System.out.println("====================2");
            List<User> userList = getUserList(request,response);
            PrintJson.printJsonObj(response,userList);
        }else if ("/workbench/activity/saveActivity.do".equals(path)){

            Boolean flag = saveActivity(request,response);
            PrintJson.printJsonFlag(response,flag);

        }else if ("/workbench/activity/activityList.do".equals(path)){
            ActivityListVo<Activity> activityListVo =activityList(request,response);
            PrintJson.printJsonObj(response,activityListVo);
        }
    }

    private ActivityListVo<Activity> activityList(HttpServletRequest request, HttpServletResponse response) {
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        String pageNoStr =request.getParameter("pageNo");
        String pageSizeStr =request.getParameter("pageSize");
        String name =request.getParameter("name");
        String owner =request.getParameter("owner");
        String startDate =request.getParameter("startDate");
        String endDate =request.getParameter("endDate");
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int pageCount = (pageNo-1)*pageSize;
        Map<String ,Object> map = new HashMap<String ,Object>();
        map.put("pageCount",pageCount);
        map.put("pageSizeStr",pageSizeStr);
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);


        ActivityListVo<Activity> activityListVo = service.activityList(map);

        return activityListVo;
    }

    private Boolean saveActivity(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String time = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String describe = request.getParameter("describe");
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(describe);
        activity.setCreateTime(time);
        activity.setCreateBy(createBy);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Boolean flag = activityService.saveActivity(activity);
        return flag;
    }

    private List<User> getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = service.getUserList();
        return userList;
    }
}
