package com.hwj.crm.vo;

import java.util.List;

public class ActivityListVo<t> {
    private List<t> activityList;
    private Integer total;

    public List<t> getActivityList() {
        return activityList;
    }

    public void setActivityList(List<t> activityList) {
        this.activityList = activityList;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }
}
