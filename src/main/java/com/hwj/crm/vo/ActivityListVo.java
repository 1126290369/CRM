package com.hwj.crm.vo;

import java.util.List;

public class ActivityListVo<t> {
    private List<t> Ac;
    private Integer total;

    public List<t> getAc() {
        return Ac;
    }

    public void setAc(List<t> ac) {
        Ac = ac;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }
}
