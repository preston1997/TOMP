-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('收货地址', '2029', '1', 'address', 'user/address/index', 1, 0, 'C', '0', '0', 'user:address:list', '#', 'admin', sysdate(), '', null, '收货地址菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('收货地址查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'user:address:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('收货地址新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'user:address:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('收货地址修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'user:address:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('收货地址删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'user:address:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('收货地址导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'user:address:export',       '#', 'admin', sysdate(), '', null, '');