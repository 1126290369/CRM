package com.hwj.crm.workbench.web.controller;

import com.hwj.crm.settings.domain.User;
import com.hwj.crm.settings.service.UserService;
import com.hwj.crm.settings.service.impl.UserServiceImpl;
import com.hwj.crm.utils.*;
import com.hwj.crm.vo.ActivityListVo;
import com.hwj.crm.workbench.domain.Activity;
import com.hwj.crm.workbench.domain.ActivityRemark;
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
        }else if ("/workbench/activity/delete.do".equals(path)){
            Boolean flag =deleteById(request,response);
            PrintJson.printJsonFlag(response,flag);
        }else if ("/workbench/activity/edit.do".equals(path)){
//            Map<String,Object> map =new HashMap<>();
            Map<String,Object> map =edit(request,response);
            System.out.println("修改的数据");
            PrintJson.printJsonObj(response,map);
        }else if ("/workbench/activity/update.do".equals(path)){
            Boolean flag = update(request,response);
            PrintJson.printJsonFlag(response,flag);
        }else if ("/workbench/activity/detail.do".equals(path)){
            System.out.println("==========detail==========");
            Activity activity = detail(request,response);
            request.setAttribute("a",activity);
            request.getRequestDispatcher("detail.jsp").forward(request,response);

        }else if ("/workbench/activity/showRemark.do".equals(path)){
            System.out.println("==========showRemark==========");
            List<ActivityRemark> list = showRemark(request,response);
            PrintJson.printJsonObj(response,list);
        }else if ("/workbench/activity/editRemark.do".equals(path)){
            System.out.println("==========editRemark==========");
            Map<String ,Object> map = editRemark(request,response);
            PrintJson.printJsonObj(response,map);
        }else if ("/workbench/activity/deleteRemark.do".equals(path)){
            System.out.println("==========deleteRemark==========");
            Boolean success = deleteRemark(request,response);
            PrintJson.printJsonFlag(response,success);
        }else if ("/workbench/activity/addRemark.do".equals(path)){
            System.out.println("==========addRemark==========");
            Map<String ,Object> map = addRemark(request,response);
            PrintJson.printJsonObj(response,map);
        }
    }

    private Map<String, Object> addRemark(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        String id = UUIDUtil.getUUID();
        String activityId = request.getParameter("activityId");
        String noteContent = request.getParameter("noteContent");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setActivityId(activityId);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateTime(createTime);
        activityRemark.setCreateBy(createBy);
        activityRemark.setEditFlag("0");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Boolean success = activityService.addRemark(activityRemark);
        map.put("success",success);
        map.put("activityRemark",activityRemark);
        return map;
    }

    private Boolean deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Boolean success = activityService.deleteRemark(id);
        return success;
    }


    private Map<String, Object> editRemark(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        String editBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        String noteContent = request.getParameter("noteContent");
        String id = request.getParameter("id");
        String editTime = DateTimeUtil.getSysTime();
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setEditBy(editBy);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setId(id);
        activityRemark.setEditTime(editTime);
        activityRemark.setEditFlag("1");
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Boolean flag = activityService.editRemark(activityRemark);
        map.put("activityRemark",activityRemark);
        map.put("success",flag);
        return map;
    }

    private List<ActivityRemark> showRemark(HttpServletRequest request, HttpServletResponse response) {
        String activityId = request.getParameter("activityId");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> list = service.showRemark(activityId);
        return list;
    }

    private Activity detail(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = activityService.detail(id);
        return activity;
    }

    private Boolean update(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String cost = request.getParameter("cost");
        String describe = request.getParameter("describe");
        String editTime = DateTimeUtil.getSysTime();
        System.out.println("============="+endTime+"==============");
        String  editBy = ((User) request.getSession(false).getAttribute("user")).getName();
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startTime);
        activity.setEndDate(endTime);
        activity.setCost(cost);
        activity.setDescription(describe);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);
        Boolean flag = activityService.update(activity);
        return flag;
    }

    private Map<String, Object> edit(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = activityService.edit(id);
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> list = userService.getUserList();
        Map<String,Object> map = new HashMap<>();
        map.put("activity",activity);
        map.put("userList",list);
        return map;
    }

    private Boolean deleteById(HttpServletRequest request, HttpServletResponse response) {
        String[] ids = request.getParameterValues("id");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Boolean flag = service.deleteById(ids);
        return flag;
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
        map.put("pageSize",pageSize);
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
