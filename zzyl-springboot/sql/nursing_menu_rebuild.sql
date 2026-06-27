-- ----------------------------
-- 清理并重建养老护理模块菜单
-- ----------------------------

-- 删除角色菜单关联
DELETE FROM sys_role_menu WHERE menu_id >= 2000 AND menu_id <= 2200;

-- 删除旧的菜单数据
DELETE FROM sys_menu WHERE menu_id >= 2000 AND menu_id <= 2200;

-- ----------------------------
-- 重新创建养老护理菜单（menu_id从2000开始）
-- ----------------------------

-- 一级菜单：养老护理
INSERT INTO sys_menu VALUES ('2000', '养老护理', '0', '5', 'nursing', NULL, '', '', 1, 0, 'M', '0', '0', '', 'nursing', 'admin', sysdate(), '', NULL, '养老护理管理目录');

-- 护理项目菜单
INSERT INTO sys_menu VALUES ('2001', '护理项目', '2000', '1', 'project', 'nursing/project/index', '', 'NursingProject', 1, 0, 'C', '0', '0', 'nursing:project:list', 'form', 'admin', sysdate(), '', NULL, '护理项目菜单');
INSERT INTO sys_menu VALUES ('2002', '护理项目查询', '2001', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:query', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2003', '护理项目新增', '2001', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2004', '护理项目修改', '2001', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2005', '护理项目删除', '2001', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:remove', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2006', '护理项目导出', '2001', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:project:export', '#', 'admin', sysdate(), '', NULL, '');

-- 护理计划菜单
INSERT INTO sys_menu VALUES ('2010', '护理计划', '2000', '2', 'plan', 'nursing/plan/index', '', 'NursingPlan', 1, 0, 'C', '0', '0', 'plan:plan:list', 'tree-table', 'admin', sysdate(), '', NULL, '护理计划菜单');
INSERT INTO sys_menu VALUES ('2011', '护理计划查询', '2010', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'plan:plan:query', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2012', '护理计划新增', '2010', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:nursingPlan:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2013', '护理计划修改', '2010', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:plan:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2014', '护理计划删除', '2010', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:plan:remove', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2015', '护理计划导出', '2010', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'plan:plan:export', '#', 'admin', sysdate(), '', NULL, '');

-- 护理等级菜单
INSERT INTO sys_menu VALUES ('2020', '护理等级', '2000', '3', 'level', 'nursing/level/index', '', 'NursingLevel', 1, 0, 'C', '0', '0', 'level:level:list', 'guide', 'admin', sysdate(), '', NULL, '护理等级菜单');
INSERT INTO sys_menu VALUES ('2021', '护理等级查询', '2020', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:query', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2022', '护理等级新增', '2020', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2023', '护理等级修改', '2020', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2024', '护理等级删除', '2020', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:remove', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2025', '护理等级导出', '2020', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'level:level:export', '#', 'admin', sysdate(), '', NULL, '');

-- 来访管理菜单
INSERT INTO sys_menu VALUES ('2030', '来访管理', '2000', '4', 'visit', 'nursing/visit/index', '', 'NursingVisit', 1, 0, 'C', '0', '0', 'nursing:visit:list', 'peoples', 'admin', sysdate(), '', NULL, '来访管理菜单');
INSERT INTO sys_menu VALUES ('2031', '来访查询', '2030', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:query', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2032', '来访新增', '2030', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2033', '来访修改', '2030', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2034', '来访删除', '2030', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:remove', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2035', '来访导出', '2030', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:export', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2036', '来访审核', '2030', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:approve', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2037', '来访取消', '2030', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:cancel', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2038', '访客签到', '2030', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:signIn', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES ('2039', '离开登记', '2030', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'nursing:visit:leave', '#', 'admin', sysdate(), '', NULL, '');

-- AI咨询菜单
INSERT INTO sys_menu VALUES ('2050', 'AI咨询', '0', '6', 'aiconsult', NULL, '', '', 1, 0, 'M', '0', '0', '', 'chat', 'admin', sysdate(), '', NULL, 'AI咨询目录');
INSERT INTO sys_menu VALUES ('2051', '小智健康', '2050', '1', 'virtualagent', 'aiconsult/virtualagent', '', 'VirtualAgent', 1, 0, 'C', '0', '0', 'aiconsult:virtualagent:view', 'robot', 'admin', sysdate(), '', NULL, '小智健康菜单');

-- 角色菜单关联（普通角色role_id=2）
INSERT INTO sys_role_menu VALUES ('2', '2000');
INSERT INTO sys_role_menu VALUES ('2', '2001');
INSERT INTO sys_role_menu VALUES ('2', '2002');
INSERT INTO sys_role_menu VALUES ('2', '2003');
INSERT INTO sys_role_menu VALUES ('2', '2004');
INSERT INTO sys_role_menu VALUES ('2', '2005');
INSERT INTO sys_role_menu VALUES ('2', '2006');
INSERT INTO sys_role_menu VALUES ('2', '2010');
INSERT INTO sys_role_menu VALUES ('2', '2011');
INSERT INTO sys_role_menu VALUES ('2', '2012');
INSERT INTO sys_role_menu VALUES ('2', '2013');
INSERT INTO sys_role_menu VALUES ('2', '2014');
INSERT INTO sys_role_menu VALUES ('2', '2015');
INSERT INTO sys_role_menu VALUES ('2', '2020');
INSERT INTO sys_role_menu VALUES ('2', '2021');
INSERT INTO sys_role_menu VALUES ('2', '2022');
INSERT INTO sys_role_menu VALUES ('2', '2023');
INSERT INTO sys_role_menu VALUES ('2', '2024');
INSERT INTO sys_role_menu VALUES ('2', '2025');
INSERT INTO sys_role_menu VALUES ('2', '2030');
INSERT INTO sys_role_menu VALUES ('2', '2031');
INSERT INTO sys_role_menu VALUES ('2', '2032');
INSERT INTO sys_role_menu VALUES ('2', '2033');
INSERT INTO sys_role_menu VALUES ('2', '2034');
INSERT INTO sys_role_menu VALUES ('2', '2035');
INSERT INTO sys_role_menu VALUES ('2', '2036');
INSERT INTO sys_role_menu VALUES ('2', '2037');
INSERT INTO sys_role_menu VALUES ('2', '2038');
INSERT INTO sys_role_menu VALUES ('2', '2039');
INSERT INTO sys_role_menu VALUES ('2', '2050');
INSERT INTO sys_role_menu VALUES ('2', '2051');
