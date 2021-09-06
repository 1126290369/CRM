package com.hwj.crm.workbench.service.impl;


import com.hwj.crm.utils.SqlSessionUtil;
import com.hwj.crm.vo.ActivityListVo;
import com.hwj.crm.workbench.dao.ActivityDao;
import com.hwj.crm.workbench.domain.Activity;
import com.hwj.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);


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
        activityListVo.setAc(activities);
        return activityListVo;
    }


}
