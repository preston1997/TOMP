-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂变更历史', '2002', '1', 'factoryHistory', 'factory/factoryHistory/index', 1, 0, 'C', '0', '0', 'factory:factoryHistory:list', '#', 'admin', sysdate(), '', null, '工厂变更历史菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂变更历史查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂变更历史新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂变更历史修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂变更历史删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('工厂变更历史导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:export',       '#', 'admin', sysdate(), '', null, '');