-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂信息', '2002', '1', 'factorys', 'factory/factorys/index', 1, 0, 'C', '0', '0', 'factory:factorys:list', '#', 'admin', sysdate(), '', null, '工厂信息菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂信息查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'factory:factorys:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂信息新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'factory:factorys:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂信息修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'factory:factorys:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂信息删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'factory:factorys:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂信息导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'factory:factorys:export',       '#', 'admin', sysdate(), '', null, '');