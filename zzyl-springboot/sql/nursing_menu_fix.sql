-- ----------------------------
-- 养老护理模块菜单修复与补充脚本
-- 修正菜单component路径拼写，并补充缺失的护理项目、护理计划、护理等级菜单
-- 在 visit.sql 之后执行
-- ----------------------------

-- 修正当来访管理菜单component路径拼写错误（nusring -> nursing）
update sys_menu set component = 'nursing/visit/index' where menu_id = 2001;

-- 添加护理项目菜单
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2010, '护理项目', 2000, 2, 'project', 'nursing/project/index', '', 'NursingProject', 1, 0, 'C', '0', '0', 'nursing:project:list', 'form', 'admin', sysdate(), '护理项目菜单'
where not exists (select 1 from sys_menu where menu_id = 2010);

-- 护理项目按钮权限
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2011, '护理项目查询', 2010, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2011);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2012, '护理项目新增', 2010, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2012);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2013, '护理项目修改', 2010, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2013);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2014, '护理项目删除', 2010, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2014);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2015, '护理项目导出', 2010, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:export', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2015);

-- 添加护理计划菜单
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2020, '护理计划', 2000, 3, 'plan', 'nursing/plan/index', '', 'NursingPlan', 1, 0, 'C', '0', '0', 'plan:plan:list', 'tree-table', 'admin', sysdate(), '护理计划菜单'
where not exists (select 1 from sys_menu where menu_id = 2020);

-- 护理计划按钮权限
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2021, '护理计划查询', 2020, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'plan:plan:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2021);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2022, '护理计划新增', 2020, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:nursingPlan:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2022);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2023, '护理计划修改', 2020, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:plan:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2023);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2024, '护理计划删除', 2020, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:plan:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2024);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2025, '护理计划导出', 2020, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'plan:plan:export', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2025);

-- 添加护理等级菜单
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2030, '护理等级', 2000, 4, 'level', 'nursing/level/index', '', 'NursingLevel', 1, 0, 'C', '0', '0', 'level:level:list', 'guide', 'admin', sysdate(), '护理等级菜单'
where not exists (select 1 from sys_menu where menu_id = 2030);

-- 护理等级按钮权限
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2031, '护理等级查询', 2030, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2031);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2032, '护理等级新增', 2030, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2032);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2033, '护理等级修改', 2030, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2033);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2034, '护理等级删除', 2030, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2034);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2035, '护理等级导出', 2030, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:export', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where menu_id = 2035);

-- 角色菜单关联（普通角色）
insert into sys_role_menu (role_id, menu_id)
select 2, menu_id from sys_menu where menu_id in (2010, 2011, 2012, 2013, 2014, 2015, 2020, 2021, 2022, 2023, 2024, 2025, 2030, 2031, 2032, 2033, 2034, 2035)
and not exists (select 1 from sys_role_menu rm where rm.role_id = 2 and rm.menu_id = sys_menu.menu_id);
