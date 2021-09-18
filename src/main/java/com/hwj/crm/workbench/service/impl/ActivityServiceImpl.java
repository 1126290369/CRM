package com.hwj.crm.workbench.service.impl;


import com.hwj.crm.utils.SqlSessionUtil;
import com.hwj.crm.vo.ActivityListVo;
import com.hwj.crm.workbench.dao.ActivityDao;
import com.hwj.crm.workbench.dao.ActivityRemarkDao;
import com.hwj.crm.workbench.domain.Activity;
import com.hwj.crm.workbench.domain.ActivityRemark;
import com.hwj.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);

    @Override
    public Boolean saveActivity(Activity activity) {
        Integer result = activityDao.saveActivity(activity);
        Boolean flag = true;
        if (result!=1){
            flag = false;
        }

        return flag;
    }

    @Override
    public ActivityListVo<Activity> activityList(Map<String, Object> map) {
        int Amount = activityDao.searchCount(map);
        List<Activity> activities = activityDao.activityList(map);
        ActivityListVo<Activity> activityListVo = new ActivityListVo<>();
        activityListVo.setTotal(Amount);
        activityListVo.setActivityList(activities);
        return activityListVo;
    }

    @Override
    public Boolean deleteById(String[] ids) {
        Boolean flag =true;
        int res1=activityRemarkDao.deleteById(ids);
        int res2 = activityDao.deleteById(ids);
        if (res2!=ids.length){
            flag=false;
        }
        return flag;
    }

    @Override
    public Activity edit(String id) {
        Activity activity = activityDao.selectById(id);
        return activity;
    }

    @Override
    public Boolean update(Activity activity) {
        int res = activityDao.update(activity);
        Boolean flag = true;
        if (res!=1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> showRemark(String activityId) {
        List<ActivityRemark> list = activityRemarkDao.showRemark(activityId);

        return list;
    }

    @Override
    public Boolean editRemark(ActivityRemark activityRemark) {
        Boolean flag = true;
        int res = activityRemarkDao.editRemark(activityRemark);
        if (res!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Boolean deleteRemark(String id) {
        int res = activityRemarkDao.deleteRemark(id);
        Boolean success = true;
        if (res!=1){
            success=false;
        }
        return success;
    }

    @Override
    public Boolean addRemark(ActivityRemark activityRemark) {
        int res = activityRemarkDao.addRemark(activityRemark);
        Boolean success=true;
        if (res!=1){
            success=false;
        }
        return success;
    }


}
