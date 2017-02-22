package com.bx.service.impl;

import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.bx.dao.UserDao;
import com.bx.entity.User;
import com.bx.service.UserService;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Resource
    private UserDao userDao;

    @Override
    public User login(Map<String, Object> map) {
        return userDao.login(map);
    }

}
