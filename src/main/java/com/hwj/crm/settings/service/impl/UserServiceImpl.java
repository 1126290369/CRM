package com.hwj.crm.settings.service.impl;

import com.hwj.crm.settings.dao.UserDao;
import com.hwj.crm.settings.service.UserService;
import com.hwj.crm.utils.SqlSessionUtil;
import org.apache.ibatis.session.SqlSession;

public class UserServiceImpl implements UserService {
    SqlSession session = (SqlSession) SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

}
