-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('生产计划', '2028', '1', 'plan', 'produce/plan/index', 1, 0, 'C', '0', '0', 'produce:plan:list', '#', 'admin', sysdate(), '', null, '生产计划菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('生产计划查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'produce:plan:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('生产计划新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'produce:plan:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('生产计划修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'produce:plan:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('生产计划删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'produce:plan:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('生产计划导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'produce:plan:export',       '#', 'admin', sysdate(), '', null, '');