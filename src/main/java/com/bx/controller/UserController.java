package com.bx.controller;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.bx.entity.User;
import com.bx.service.UserService;
import com.bx.util.StringUtil;


@Controller
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    /**
     * 用户登录请求
     * @param user 对应的用户实体
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/login")
    public ModelAndView login(User user, HttpServletRequest request, @RequestParam(required = false)String service) throws Exception {
        ModelAndView modelAndView = new ModelAndView();
        HttpSession session = request.getSession();
        Map<String, Object> map = new HashMap<>();
        if (StringUtil.isEmpty(user.getUserName()) || StringUtil.isEmpty(user.getPassword())) {
            modelAndView.setViewName("login");
            return modelAndView;
        }
        map.put("userName", user.getUserName());
        map.put("password", user.getPassword());
        User result = userService.login(map);
        if (result == null) {
            request.setAttribute("error", "用户名或密码错误");
            request.setAttribute("user", user);
            modelAndView.setViewName("login");
            return modelAndView;
        } else {
            session.setAttribute("currentUser", result);
            if (StringUtil.isNotEmpty(service)) {
                service = service.replace('?', '&').replaceFirst("&", "?");
                modelAndView.setViewName("redirect:" + service);
                return modelAndView;
            }
            modelAndView.setViewName("redirect:/main/list.do");
            return modelAndView;
        }
    }

    /**
     * 用户登出
     * @param request
     * @return
     */
    @RequestMapping("/logout")
    public String logout(HttpServletRequest request){
        HttpSession session = request.getSession();
        session.invalidate();
        return "redirect:/login.jsp";
    }
}
