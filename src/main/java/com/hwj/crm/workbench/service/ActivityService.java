package com.hwj.crm.workbench.service;

import com.hwj.crm.settings.domain.User;
import com.hwj.crm.vo.ActivityListVo;
import com.hwj.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {


    Boolean saveActivity(Activity activity);

    ActivityListVo<Activity> activityList(Map<String, Object> map);
}
