package com.hwj.crm.workbench.dao;

import com.hwj.crm.utils.SqlSessionUtil;
import com.hwj.crm.workbench.domain.Activity;

import java.util.List;


public interface ActivityDao {

    Integer saveActivity(Activity activity);
}
