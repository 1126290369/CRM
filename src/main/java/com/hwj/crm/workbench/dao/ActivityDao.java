package com.hwj.crm.workbench.dao;

import com.hwj.crm.utils.SqlSessionUtil;
import com.hwj.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;


public interface ActivityDao {

    Integer saveActivity(Activity activity);

    int searchCount(Map<String, Object> map);

    List<Activity> activityList(Map<String, Object> map);
}
