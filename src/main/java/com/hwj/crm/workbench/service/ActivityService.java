package com.hwj.crm.workbench.service;

import com.hwj.crm.settings.domain.User;
import com.hwj.crm.vo.ActivityListVo;
import com.hwj.crm.workbench.domain.Activity;
import com.hwj.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {


    Boolean saveActivity(Activity activity);

    ActivityListVo<Activity> activityList(Map<String, Object> map);

    Boolean deleteById(String[] ids);


    Activity edit(String id);

    Boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> showRemark(String activityId);

    Boolean editRemark(ActivityRemark activityRemark);

    Boolean deleteRemark(String id);

    Boolean addRemark(ActivityRemark activityRemark);
}
