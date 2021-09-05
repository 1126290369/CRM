package com.hwj.crm.workbench.service.impl;


import com.hwj.crm.utils.SqlSessionUtil;
import com.hwj.crm.workbench.dao.ActivityDao;
import com.hwj.crm.workbench.domain.Activity;
import com.hwj.crm.workbench.service.ActivityService;

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
}
