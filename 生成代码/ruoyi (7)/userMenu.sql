-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('用户信息', '3', '1', 'user', 'system/user/index', 1, 0, 'C', '0', '0', 'system:user:list', '#', 'admin', sysdate(), '', null, '用户信息菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('用户信息查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'system:user:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('用户信息新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'system:user:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('用户信息修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'system:user:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('用户信息删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'system:user:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('用户信息导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'system:user:export',       '#', 'admin', sysdate(), '', null, '');