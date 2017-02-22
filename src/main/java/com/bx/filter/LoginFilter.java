package com.bx.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginFilter implements Filter {

	private String[] excludedUrls;

	@Override
	public void init(FilterConfig config) throws ServletException {
		String excludes = config.getInitParameter("excludedUrls");
		if (excludes != null) {
			this.excludedUrls = excludes.split(",");
		}
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String requestUri = httpRequest.getServletPath() + "?" + httpRequest.getQueryString();
		requestUri = requestUri.replace('&', '?');
		for (String url : excludedUrls) {
			if (requestUri.contains(url.trim())) {
				chain.doFilter(request, response);
				return;
			}
		}
		HttpSession session = httpRequest.getSession(true);
		if (session.getAttribute("currentUser") == null) {
			httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?service="+requestUri);
		} else {
			chain.doFilter(request, response);
			return;
		}
	}

	@Override
	public void destroy() {

	}

}