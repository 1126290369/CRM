package com.hwj.crm.workbench.dao;

import com.hwj.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int deleteById(String[] ids);

    List<ActivityRemark> showRemark(String activityId);

    int editRemark(ActivityRemark activityRemark);

    int deleteRemark(String id);

    int addRemark(ActivityRemark activityRemark);
}
