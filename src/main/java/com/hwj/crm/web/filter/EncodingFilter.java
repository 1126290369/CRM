package com.hwj.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        //过滤post请求的中文参数乱码
        req.setCharacterEncoding("utf-8");

        //过滤响应流的参数乱码
        resp.setContentType("text/html;charset=utf-8");

        //将请求放行
        chain.doFilter(req,resp);
    }
}
