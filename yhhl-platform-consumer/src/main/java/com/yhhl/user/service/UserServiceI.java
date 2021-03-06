package com.yhhl.user.service;

import java.util.Map;

import com.yhhl.core.Page;
import com.yhhl.user.model.User;


public interface UserServiceI {

	User getById(String id);

	Page<User> getAll(Map<String,Object> filterMap,Page<User> page, int pageNo, int pageSize);
	
	int getCount(Map<String, Object> filterMap);
	
	Page<User> getByPage(Page<User> pageProduct, Map<String, Object> filterMap, int pageNo, int pageSize);

	public void saveUser(User user);
	
	public void updateUser(User user);
	
	public void deleteById(String id);
	
	public User getByUserNameAndPwd(String userName, String pwd);
	
	public void registerFromFront(User user);

}
