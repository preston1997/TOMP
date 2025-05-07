/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80200
 Source Host           : localhost:3306
 Source Schema         : ry

 Target Server Type    : MySQL
 Target Server Version : 80200
 File Encoding         : 65001

 Date: 05/05/2025 04:14:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for after_sales
-- ----------------------------
DROP TABLE IF EXISTS `after_sales`;
CREATE TABLE `after_sales`  (
  `case_id` bigint NOT NULL AUTO_INCREMENT,
  `sub_order_id` bigint NOT NULL,
  `type` enum('QUALITY','DELAY','OTHER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` enum('PENDING','PROCESSING','RESOLVED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PENDING',
  `compensation` decimal(10, 2) NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `resolve_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`case_id`) USING BTREE,
  INDEX `sub_order_id`(`sub_order_id` ASC) USING BTREE,
  CONSTRAINT `after_sales_ibfk_1` FOREIGN KEY (`sub_order_id`) REFERENCES `sub_order` (`sub_order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of after_sales
-- ----------------------------

-- ----------------------------
-- Table structure for delivery_address
-- ----------------------------
DROP TABLE IF EXISTS `delivery_address`;
CREATE TABLE `delivery_address`  (
  `address_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `recipient` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_default` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`address_id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `delivery_address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of delivery_address
-- ----------------------------

-- ----------------------------
-- Table structure for factory
-- ----------------------------
DROP TABLE IF EXISTS `factory`;
CREATE TABLE `factory`  (
  `factory_id` bigint NOT NULL AUTO_INCREMENT,
  `factory_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `capacity_top` int NOT NULL,
  `capacity_pants` int NOT NULL,
  `cost_top` decimal(10, 2) NOT NULL,
  `cost_pants` decimal(10, 2) NOT NULL,
  `quality_top` decimal(5, 3) NOT NULL,
  `quality_pants` decimal(5, 3) NOT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `work_schedule` json NULL,
  `initial_load` int NULL DEFAULT NULL,
  PRIMARY KEY (`factory_id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_factory_active`(`is_active` ASC) USING BTREE,
  CONSTRAINT `factory_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `factory_chk_1` CHECK (`capacity_top` >= 0),
  CONSTRAINT `factory_chk_2` CHECK (`capacity_pants` >= 0),
  CONSTRAINT `factory_chk_3` CHECK (`cost_top` > 0),
  CONSTRAINT `factory_chk_4` CHECK (`cost_pants` > 0),
  CONSTRAINT `factory_chk_5` CHECK (`quality_top` between 0 and 1),
  CONSTRAINT `factory_chk_6` CHECK (`quality_pants` between 0 and 1)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of factory
-- ----------------------------
INSERT INTO `factory` VALUES (1, '通际名联科技有限公司工厂', 100, 1059, 933, 77.16, 48.44, 0.871, 0.866, 1, '{\"morning\": \"08:00-12:00\", \"afternoon\": \"13:30-17:30\"}', 0);
INSERT INTO `factory` VALUES (2, '鑫博腾飞传媒有限公司工厂', 101, 929, 656, 75.24, 37.06, 0.971, 0.852, 1, '{\"morning\": \"08:00-12:00\", \"afternoon\": \"13:30-17:30\"}', 200);
INSERT INTO `factory` VALUES (3, '立信电子信息有限公司工厂', 102, 1208, 1001, 69.87, 64.49, 0.951, 0.849, 1, '{\"morning\": \"08:00-12:00\", \"afternoon\": \"13:30-17:30\"}', 0);

-- ----------------------------
-- Table structure for factory_history
-- ----------------------------
DROP TABLE IF EXISTS `factory_history`;
CREATE TABLE `factory_history`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `factory_id` bigint NOT NULL,
  `changed_field` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `old_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `new_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `change_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `operator_id` bigint NOT NULL,
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `factory_id`(`factory_id` ASC) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE,
  CONSTRAINT `factory_history_ibfk_1` FOREIGN KEY (`factory_id`) REFERENCES `factory` (`factory_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `factory_history_ibfk_2` FOREIGN KEY (`operator_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of factory_history
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (2, 'product_type', '商品类型表', NULL, NULL, 'ProductType', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'type', '商品类型表', '高翔', '0', '/', '{\"parentMenuId\":0}', 'admin', '2025-04-17 01:37:42', '', '2025-04-17 01:46:17', NULL);
INSERT INTO `gen_table` VALUES (6, 'delivery_address', '收货地址表', NULL, NULL, 'DeliveryAddress', 'crud', 'element-ui', 'com.ruoyi.tompSys', 'user', 'address', '收货地址', '高翔', '0', '/', '{\"parentMenuId\":2029}', 'admin', '2025-04-17 15:55:37', '', '2025-04-18 02:11:28', NULL);
INSERT INTO `gen_table` VALUES (7, 'factory', '工厂信息', 'factory_history', 'factory_id', 'Factory', 'sub', 'element-ui', 'com.ruoyi.tompSys', 'factory', 'factorys', '工厂信息', '高翔', '0', '/', '{\"parentMenuId\":2002}', 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12', NULL);
INSERT INTO `gen_table` VALUES (8, 'factory_history', '工厂变更历史表', NULL, NULL, 'FactoryHistory', 'crud', 'element-ui', 'com.ruoyi.tompSys', 'factory', 'factoryHistory', '工厂变更历史', 'ruoyi', '0', '/', '{\"parentMenuId\":2002}', 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06', NULL);
INSERT INTO `gen_table` VALUES (9, 'orders', '订单列表', 'sub_order', 'order_id', 'Orders', 'sub', 'element-ui', 'com.ruoyi.tompSys', 'order', 'orders', '订单列表', '高翔', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2025-04-17 15:58:56', '', '2025-04-18 01:42:25', NULL);
INSERT INTO `gen_table` VALUES (10, 'sub_order', '子订单列表', 'production_plan', 'sub_order_id', 'SubOrder', 'sub', 'element-ui', 'com.ruoyi.tompSys', 'order', 'subOrder', '子订单列表', '高翔', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51', NULL);
INSERT INTO `gen_table` VALUES (11, 'after_sales', '售后信息表', NULL, NULL, 'AfterSales', 'crud', 'element-ui', 'com.ruoyi.tompSys', 'order', 'afterSales', '售后信息', '高翔', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42', NULL);
INSERT INTO `gen_table` VALUES (12, 'notification_template', '', NULL, NULL, 'NotificationTemplate', 'crud', '', 'com.ruoyi.system', 'system', 'template', NULL, 'ruoyi', '0', '/', NULL, 'admin', '2025-04-17 17:11:42', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (13, 'production_log', '生产日志表', NULL, NULL, 'ProductionLog', 'crud', 'element-ui', 'com.ruoyi.tompSys', 'produce', 'log', '生产日志', '高翔', '0', '/', '{\"parentMenuId\":2028}', 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:09:02', NULL);
INSERT INTO `gen_table` VALUES (14, 'production_plan', '生产计划表', 'production_log', 'plan_id', 'ProductionPlan', 'sub', 'element-ui', 'com.ruoyi.tompSys', 'produce', 'plan', '生产计划', '高翔', '0', '/', '{\"parentMenuId\":2028}', 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12', NULL);
INSERT INTO `gen_table` VALUES (15, 'sys_user', '用户信息表', NULL, NULL, 'SysUser', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'user', '用户信息', 'ruoyi', '0', '/', '{}', 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (9, 2, 'product_id', '', 'bigint', 'Long', 'productId', '1', '0', '0', '1', NULL, NULL, '0', 'EQ', 'input', '', 1, 'admin', '2025-04-17 01:37:42', '', '2025-04-17 11:45:35');
INSERT INTO `gen_table_column` VALUES (10, 2, 'type_name', '', 'varchar(20)', 'String', 'typeName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-04-17 01:37:42', '', '2025-04-17 11:45:35');
INSERT INTO `gen_table_column` VALUES (11, 2, 'description', '', 'varchar(200)', 'String', 'description', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-17 01:37:42', '', '2025-04-17 11:45:35');
INSERT INTO `gen_table_column` VALUES (28, 6, 'address_id', '收货地址ID', 'bigint', 'Long', 'addressId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 15:55:37', '', '2025-04-18 02:11:28');
INSERT INTO `gen_table_column` VALUES (29, 6, 'user_id', '所属用户', 'bigint', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 15:55:37', '', '2025-04-18 02:11:28');
INSERT INTO `gen_table_column` VALUES (30, 6, 'recipient', '收件人姓名', 'varchar(50)', 'String', 'recipient', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-04-17 15:55:37', '', '2025-04-18 02:11:28');
INSERT INTO `gen_table_column` VALUES (31, 6, 'phone', '联系电话', 'varchar(20)', 'String', 'phone', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-04-17 15:55:37', '', '2025-04-18 02:11:28');
INSERT INTO `gen_table_column` VALUES (32, 6, 'address', '详细地址', 'varchar(200)', 'String', 'address', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2025-04-17 15:55:37', '', '2025-04-18 02:11:28');
INSERT INTO `gen_table_column` VALUES (33, 6, 'is_default', '默认地址标记', 'tinyint(1)', 'Integer', 'isDefault', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-04-17 15:55:37', '', '2025-04-18 02:11:28');
INSERT INTO `gen_table_column` VALUES (34, 7, 'factory_id', '工厂ID', 'bigint', 'Long', 'factoryId', '1', '1', '0', '1', NULL, NULL, '1', 'EQ', 'input', '', 1, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (35, 7, 'user_id', '关联用户ID', 'bigint', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (36, 7, 'capacity_top', '上衣产能', 'int', 'Long', 'capacityTop', '0', '0', '1', '1', '1', '1', '1', 'GTE', 'input', '', 4, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (37, 7, 'capacity_pants', '裤子产能', 'int', 'Long', 'capacityPants', '0', '0', '1', '1', '1', '1', '1', 'GTE', 'input', '', 5, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (38, 7, 'cost_top', '上衣成本', 'decimal(10,2)', 'BigDecimal', 'costTop', '0', '0', '1', '1', '1', '1', '1', 'LTE', 'input', '', 6, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (39, 7, 'cost_pants', '裤子成本', 'decimal(10,2)', 'BigDecimal', 'costPants', '0', '0', '1', '1', '1', '1', '1', 'LTE', 'input', '', 7, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (40, 7, 'quality_top', '上衣良品率', 'decimal(5,3)', 'BigDecimal', 'qualityTop', '0', '0', '1', '1', '1', '1', '1', 'GTE', 'input', '', 8, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (41, 7, 'quality_pants', '裤子良品率', 'decimal(5,3)', 'BigDecimal', 'qualityPants', '0', '0', '1', '1', '1', '1', '1', 'GTE', 'input', '', 9, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (42, 7, 'is_active', '工厂状态', 'tinyint(1)', 'Boolean', 'isActive', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 10, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (43, 7, 'work_schedule', '工作时间表', 'json', 'String', 'workSchedule', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'fileUpload', '', 11, 'admin', '2025-04-17 15:55:37', '', '2025-04-26 01:02:12');
INSERT INTO `gen_table_column` VALUES (44, 8, 'log_id', '日志ID', 'bigint', 'Long', 'logId', '1', '1', '1', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06');
INSERT INTO `gen_table_column` VALUES (45, 8, 'factory_id', '关联工厂', 'bigint', 'Long', 'factoryId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06');
INSERT INTO `gen_table_column` VALUES (46, 8, 'changed_field', '变更字段', 'varchar(50)', 'String', 'changedField', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06');
INSERT INTO `gen_table_column` VALUES (47, 8, 'old_value', '原值', 'varchar(255)', 'String', 'oldValue', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06');
INSERT INTO `gen_table_column` VALUES (48, 8, 'new_value', '新值', 'varchar(255)', 'String', 'newValue', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06');
INSERT INTO `gen_table_column` VALUES (49, 8, 'change_time', '变更时间', 'datetime', 'Date', 'changeTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 6, 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06');
INSERT INTO `gen_table_column` VALUES (50, 8, 'operator_id', '操作人员', 'bigint', 'Long', 'operatorId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-04-17 15:55:37', '', '2025-04-17 23:47:06');
INSERT INTO `gen_table_column` VALUES (51, 9, 'order_id', '订单ID', 'bigint', 'Long', 'orderId', '1', '1', '0', '1', NULL, NULL, '1', 'EQ', 'input', '', 1, 'admin', '2025-04-17 15:58:56', '', '2025-04-18 01:42:25');
INSERT INTO `gen_table_column` VALUES (52, 9, 'customer_id', '客户ID', 'bigint', 'Long', 'customerId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 15:58:56', '', '2025-04-18 01:42:25');
INSERT INTO `gen_table_column` VALUES (53, 9, 'create_time', '下单时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, '1', 'BETWEEN', 'datetime', '', 3, 'admin', '2025-04-17 15:58:56', '', '2025-04-18 01:42:25');
INSERT INTO `gen_table_column` VALUES (54, 9, 'status', '订单状态', 'enum(\'PENDING\',\'PROCESSING\',\'COMPLETED\',\'CANCELLED\')', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 4, 'admin', '2025-04-17 15:58:56', '', '2025-04-18 01:42:25');
INSERT INTO `gen_table_column` VALUES (55, 9, 'cancel_reason', '取消原因', 'varchar(200)', 'String', 'cancelReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-17 15:58:56', '', '2025-04-18 01:42:25');
INSERT INTO `gen_table_column` VALUES (56, 9, 'total_amount', '订单总金额', 'decimal(12,2)', 'BigDecimal', 'totalAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-04-17 15:58:56', '', '2025-04-18 01:42:25');
INSERT INTO `gen_table_column` VALUES (57, 10, 'sub_order_id', '子订单ID', 'bigint', 'Long', 'subOrderId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51');
INSERT INTO `gen_table_column` VALUES (58, 10, 'order_id', '主订单ID', 'bigint', 'Long', 'orderId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51');
INSERT INTO `gen_table_column` VALUES (59, 10, 'product_id', '产品类型', 'bigint', 'Long', 'productId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51');
INSERT INTO `gen_table_column` VALUES (60, 10, 'quantity', '订购数量', 'int', 'Long', 'quantity', '0', '0', '1', '1', '1', '1', '1', 'BETWEEN', 'input', '', 4, 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51');
INSERT INTO `gen_table_column` VALUES (61, 10, 'deadline', '交货期限', 'date', 'Date', 'deadline', '0', '0', '1', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 5, 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51');
INSERT INTO `gen_table_column` VALUES (62, 10, 'quality_standard', '质量要求', 'decimal(5,3)', 'BigDecimal', 'qualityStandard', '0', '0', '1', '1', '1', '1', '1', 'BETWEEN', 'input', '', 6, 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51');
INSERT INTO `gen_table_column` VALUES (63, 10, 'production_file', '生产要求文件', 'varchar(255)', 'String', 'productionFile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'fileUpload', '', 7, 'admin', '2025-04-17 15:59:39', '', '2025-04-18 02:03:51');
INSERT INTO `gen_table_column` VALUES (64, 11, 'case_id', '主键', 'bigint', 'Long', 'caseId', '1', '1', '0', '1', NULL, NULL, '1', 'EQ', 'input', '', 1, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (65, 11, 'sub_order_id', '关联子订单', 'bigint', 'Long', 'subOrderId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (66, 11, 'type', '问题类型', 'enum(\'QUALITY\',\'DELAY\',\'OTHER\')', 'String', 'type', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (67, 11, 'description', '问题描述', 'text', 'String', 'description', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'textarea', '', 4, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (68, 11, 'status', '处理状态', 'enum(\'PENDING\',\'PROCESSING\',\'RESOLVED\',\'REJECTED\')', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 5, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (69, 11, 'compensation', '赔偿金额', 'decimal(10,2)', 'BigDecimal', 'compensation', '0', '0', '0', '1', '1', '1', '1', 'BETWEEN', 'input', '', 6, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (70, 11, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (71, 11, 'resolve_time', '解决时间', 'datetime', 'Date', 'resolveTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 8, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 00:40:42');
INSERT INTO `gen_table_column` VALUES (72, 12, 'template_id', NULL, 'bigint', 'Long', 'templateId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 17:11:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (73, 12, 'template_type', NULL, 'varchar(50)', 'String', 'templateType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 2, 'admin', '2025-04-17 17:11:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (74, 12, 'content', NULL, 'text', 'String', 'content', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'editor', '', 3, 'admin', '2025-04-17 17:11:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (75, 12, 'variables', NULL, 'json', 'String', 'variables', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2025-04-17 17:11:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (76, 13, 'log_id', '日志ID', 'bigint', 'Long', 'logId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:09:02');
INSERT INTO `gen_table_column` VALUES (77, 13, 'plan_id', '关联生产计划ID', 'bigint', 'Long', 'planId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:09:02');
INSERT INTO `gen_table_column` VALUES (78, 13, 'log_type', '日志类型', 'enum(\'START\',\'PAUSE\',\'RESUME\',\'COMPLETE\',\'ADJUST\')', 'String', 'logType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:09:02');
INSERT INTO `gen_table_column` VALUES (79, 13, 'log_data', '日志详情', 'json', 'String', 'logData', '0', '0', '0', '1', '1', '1', '1', 'LIKE', NULL, '', 4, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:09:02');
INSERT INTO `gen_table_column` VALUES (80, 13, 'operator_id', '操作人员', 'bigint', 'Long', 'operatorId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:09:02');
INSERT INTO `gen_table_column` VALUES (81, 13, 'log_time', '记录时间', 'datetime', 'Date', 'logTime', '0', '0', '0', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 6, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:09:02');
INSERT INTO `gen_table_column` VALUES (82, 14, 'plan_id', '计划ID', 'bigint', 'Long', 'planId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (83, 14, 'sub_order_id', '关联子订单', 'bigint', 'Long', 'subOrderId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (84, 14, 'factory_id', '生产工厂', 'bigint', 'Long', 'factoryId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (85, 14, 'start_date', '计划开始日期', 'date', 'Date', 'startDate', '0', '0', '1', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 4, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (86, 14, 'end_date', '计划完成日期', 'date', 'Date', 'endDate', '0', '0', '1', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 5, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (87, 14, 'actual_end_date', '实际完成日期', 'date', 'Date', 'actualEndDate', '0', '0', '0', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 6, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (88, 14, 'daily_progress', '每日进度', 'json', 'String', 'dailyProgress', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (89, 14, 'current_status', '当前状态', 'enum(\'WAITING\',\'PROCESSING\',\'PAUSED\',\'COMPLETED\')', 'String', 'currentStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 8, 'admin', '2025-04-17 17:11:42', '', '2025-04-18 02:02:12');
INSERT INTO `gen_table_column` VALUES (90, 15, 'user_id', '用户ID', 'bigint', 'Long', 'userId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (91, 15, 'dept_id', '部门ID', 'bigint', 'Long', 'deptId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (92, 15, 'user_name', '用户账号', 'varchar(30)', 'String', 'userName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (93, 15, 'nick_name', '用户昵称', 'varchar(30)', 'String', 'nickName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (94, 15, 'user_type', '用户类型（00系统用户）', 'varchar(2)', 'String', 'userType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (95, 15, 'email', '用户邮箱', 'varchar(50)', 'String', 'email', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (96, 15, 'phonenumber', '手机号码', 'varchar(11)', 'String', 'phonenumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (97, 15, 'sex', '用户性别（0男 1女 2未知）', 'char(1)', 'String', 'sex', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (98, 15, 'avatar', '头像地址', 'varchar(100)', 'String', 'avatar', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (99, 15, 'password', '密码', 'varchar(100)', 'String', 'password', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (100, 15, 'status', '帐号状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 11, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (101, 15, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (102, 15, 'login_ip', '最后登录IP', 'varchar(128)', 'String', 'loginIp', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (103, 15, 'login_date', '最后登录时间', 'datetime', 'Date', 'loginDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 14, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (104, 15, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 15, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (105, 15, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (106, 15, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 17, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (107, 15, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (108, 15, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 19, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (109, 15, 'contact_info', '联系方式', 'varchar(100)', 'String', 'contactInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (110, 15, 'audit_status', '审核状态', 'enum(\'pending\',\'approved\',\'rejected\')', 'String', 'auditStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 21, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (111, 15, 'is_active', '激活状态', 'tinyint(1)', 'Integer', 'isActive', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2025-04-17 23:05:07', '', '2025-04-18 02:06:25');
INSERT INTO `gen_table_column` VALUES (112, 7, 'factory_name', '工厂名', 'varchar(255)', 'String', 'factoryName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, '', '2025-04-26 00:56:00', '', '2025-04-26 01:02:12');

-- ----------------------------
-- Table structure for notification_template
-- ----------------------------
DROP TABLE IF EXISTS `notification_template`;
CREATE TABLE `notification_template`  (
  `template_id` bigint NOT NULL AUTO_INCREMENT,
  `template_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `variables` json NOT NULL,
  PRIMARY KEY (`template_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notification_template
-- ----------------------------

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('PENDING','PROCESSING','COMPLETED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PENDING',
  `cancel_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `total_amount` decimal(12, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`) USING BTREE,
  INDEX `idx_order_customer`(`customer_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`status` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 103, '2025-03-17 14:00:44', 'PENDING', NULL, 122940.00);
INSERT INTO `orders` VALUES (2, 103, '2025-04-02 19:12:47', 'PENDING', NULL, 342840.00);
INSERT INTO `orders` VALUES (3, 103, '2025-03-06 16:02:53', 'PENDING', NULL, 230160.00);
INSERT INTO `orders` VALUES (4, 104, '2025-04-16 20:24:28', 'PENDING', NULL, 266640.00);
INSERT INTO `orders` VALUES (5, 104, '2025-03-19 14:38:11', 'PENDING', NULL, 219030.00);
INSERT INTO `orders` VALUES (6, 104, '2025-04-20 00:46:45', 'PENDING', NULL, 282660.00);
INSERT INTO `orders` VALUES (7, 105, '2025-03-16 17:19:43', 'PENDING', NULL, 182580.00);
INSERT INTO `orders` VALUES (8, 105, '2025-04-20 02:14:15', 'PENDING', NULL, 297630.00);
INSERT INTO `orders` VALUES (9, 105, '2025-03-20 03:41:47', 'PENDING', NULL, 296190.00);

-- ----------------------------
-- Table structure for product_type
-- ----------------------------
DROP TABLE IF EXISTS `product_type`;
CREATE TABLE `product_type`  (
  `product_id` bigint NOT NULL AUTO_INCREMENT,
  `type_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`product_id`) USING BTREE,
  CONSTRAINT `product_type_chk_1` CHECK (`type_name` in (_utf8mb3'上衣',_utf8mb3'裤子'))
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_type
-- ----------------------------
INSERT INTO `product_type` VALUES (1, '上衣', NULL);
INSERT INTO `product_type` VALUES (2, '裤子', NULL);

-- ----------------------------
-- Table structure for production_log
-- ----------------------------
DROP TABLE IF EXISTS `production_log`;
CREATE TABLE `production_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint NOT NULL,
  `log_type` enum('START','PAUSE','RESUME','COMPLETE','ADJUST') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `log_data` json NULL,
  `operator_id` bigint NOT NULL,
  `log_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `plan_id`(`plan_id` ASC) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE,
  CONSTRAINT `production_log_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `production_plan` (`plan_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `production_log_ibfk_2` FOREIGN KEY (`operator_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of production_log
-- ----------------------------
INSERT INTO `production_log` VALUES (2, 2, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (3, 3, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (4, 4, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (5, 5, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (6, 6, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (7, 7, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (8, 8, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (9, 9, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (10, 10, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (11, 11, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (12, 12, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (13, 13, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (14, 14, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (15, 15, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (16, 16, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (17, 17, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (18, 18, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (19, 19, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (20, 20, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (21, 21, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (22, 22, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (23, 23, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (24, 24, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (25, 25, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (26, 26, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (27, 27, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (28, 28, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (29, 29, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (30, 30, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (31, 31, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (32, 32, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (33, 33, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (34, 34, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (35, 35, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (36, 36, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (37, 37, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (38, 38, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (39, 39, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (40, 40, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (41, 41, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (42, 42, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (43, 43, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (44, 44, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (45, 45, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (46, 46, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (47, 47, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (48, 48, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (49, 49, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (50, 50, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (51, 51, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (52, 52, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (53, 53, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (54, 54, 'START', NULL, 1, '2025-05-05 01:38:52');
INSERT INTO `production_log` VALUES (55, 55, 'START', NULL, 1, '2025-05-05 01:38:52');

-- ----------------------------
-- Table structure for production_plan
-- ----------------------------
DROP TABLE IF EXISTS `production_plan`;
CREATE TABLE `production_plan`  (
  `plan_id` bigint NOT NULL AUTO_INCREMENT,
  `sub_order_id` bigint NOT NULL,
  `factory_id` bigint NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `actual_end_date` date NULL DEFAULT NULL,
  `daily_progress` json NULL,
  `current_status` enum('WAITING','PROCESSING','PAUSED','COMPLETED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'WAITING',
  PRIMARY KEY (`plan_id`) USING BTREE,
  INDEX `sub_order_id`(`sub_order_id` ASC) USING BTREE,
  INDEX `factory_id`(`factory_id` ASC) USING BTREE,
  INDEX `idx_plan_dates`(`start_date` ASC, `end_date` ASC) USING BTREE,
  INDEX `idx_plan_status`(`current_status` ASC) USING BTREE,
  CONSTRAINT `production_plan_ibfk_1` FOREIGN KEY (`sub_order_id`) REFERENCES `sub_order` (`sub_order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `production_plan_ibfk_2` FOREIGN KEY (`factory_id`) REFERENCES `factory` (`factory_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `production_plan_chk_1` CHECK (`start_date` <= `end_date`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of production_plan
-- ----------------------------
INSERT INTO `production_plan` VALUES (2, 1, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (3, 2, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (4, 3, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (5, 4, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (6, 5, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (7, 6, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (8, 7, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (9, 8, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (10, 9, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (11, 10, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (12, 11, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (13, 12, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (14, 13, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (15, 14, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (16, 15, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (17, 16, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (18, 17, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (19, 18, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (20, 1, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (21, 2, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (22, 3, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (23, 4, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (24, 5, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (25, 6, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (26, 7, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (27, 8, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (28, 9, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (29, 10, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (30, 11, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (31, 12, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (32, 13, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (33, 14, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (34, 15, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (35, 16, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (36, 17, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (37, 18, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (38, 1, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (39, 2, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (40, 3, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (41, 4, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (42, 5, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (43, 6, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (44, 7, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (45, 8, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (46, 9, 1, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (47, 10, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (48, 11, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (49, 12, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (50, 13, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (51, 14, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (52, 15, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (53, 16, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (54, 17, 3, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');
INSERT INTO `production_plan` VALUES (55, 18, 2, '2025-05-05', '2025-05-12', NULL, NULL, 'PROCESSING');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sub_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_order`;
CREATE TABLE `sub_order`  (
  `sub_order_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `deadline` date NOT NULL,
  `quality_standard` decimal(5, 3) NOT NULL,
  `production_file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`sub_order_id`) USING BTREE,
  INDEX `order_id`(`order_id` ASC) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_deadline`(`deadline` ASC) USING BTREE,
  CONSTRAINT `sub_order_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `sub_order_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product_type` (`product_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sub_order_chk_1` CHECK (`quantity` > 0),
  CONSTRAINT `sub_order_chk_2` CHECK (`quality_standard` between 0 and 1)
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_order
-- ----------------------------
INSERT INTO `sub_order` VALUES (1, 1, 1, 741, '2025-03-23', 0.884, 'design_1.pdf');
INSERT INTO `sub_order` VALUES (2, 1, 2, 378, '2025-03-27', 0.894, 'design_2.pdf');
INSERT INTO `sub_order` VALUES (3, 2, 1, 1915, '2025-04-13', 0.930, 'design_3.pdf');
INSERT INTO `sub_order` VALUES (4, 2, 2, 1256, '2025-04-16', 0.867, 'design_4.pdf');
INSERT INTO `sub_order` VALUES (5, 3, 1, 988, '2025-03-27', 0.947, 'design_5.pdf');
INSERT INTO `sub_order` VALUES (6, 3, 2, 1240, '2025-03-30', 0.906, 'design_6.pdf');
INSERT INTO `sub_order` VALUES (7, 4, 1, 1820, '2025-05-05', 0.919, 'design_7.pdf');
INSERT INTO `sub_order` VALUES (8, 4, 2, 536, '2025-04-24', 0.878, 'design_8.pdf');
INSERT INTO `sub_order` VALUES (9, 5, 1, 1073, '2025-04-05', 0.932, 'design_9.pdf');
INSERT INTO `sub_order` VALUES (10, 5, 2, 1003, '2025-04-16', 0.928, 'design_10.pdf');
INSERT INTO `sub_order` VALUES (11, 6, 1, 1856, '2025-05-11', 0.896, 'design_11.pdf');
INSERT INTO `sub_order` VALUES (12, 6, 2, 666, '2025-05-09', 0.879, 'design_12.pdf');
INSERT INTO `sub_order` VALUES (13, 7, 1, 1238, '2025-03-24', 0.910, 'design_13.pdf');
INSERT INTO `sub_order` VALUES (14, 7, 2, 378, '2025-04-11', 0.918, 'design_14.pdf');
INSERT INTO `sub_order` VALUES (15, 8, 1, 1845, '2025-04-28', 0.919, 'design_15.pdf');
INSERT INTO `sub_order` VALUES (16, 8, 2, 847, '2025-05-03', 0.894, 'design_16.pdf');
INSERT INTO `sub_order` VALUES (17, 9, 1, 1935, '2025-04-10', 0.922, 'design_17.pdf');
INSERT INTO `sub_order` VALUES (18, 9, 2, 711, '2025-04-13', 0.897, 'design_18.pdf');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-04-16 20:34:59', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-04-16 20:34:59', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-04-16 20:34:59', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'false', 'Y', 'admin', '2025-04-16 20:34:59', 'admin', '2025-04-18 01:36:03', '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2025-04-16 20:34:59', 'admin', '2025-04-17 00:40:29', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-04-16 20:34:59', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '纺织互联网平台', 0, '高翔', '13850231340', 'preston_1997@163.com', '0', '0', 'admin', '2025-04-16 20:34:58', 'admin', '2025-04-17 00:31:46');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '开发人员', 1, '高翔', '15888888888', '123@qq.com', '0', '0', 'admin', '2025-04-16 20:34:58', 'admin', '2025-04-17 00:36:24');
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-04-16 20:34:58', '', NULL);
INSERT INTO `sys_dept` VALUES (200, 100, '0,100', '平台管理员', 1, '高翔', '13850231340', 'preston_1997@163.com', '0', '0', 'admin', '2025-04-17 00:32:25', '', NULL);
INSERT INTO `sys_dept` VALUES (201, 100, '0,100', '工厂管理员', 2, '张三', '13555555555', '123@123.com', '0', '0', 'admin', '2025-04-17 00:37:16', '', NULL);
INSERT INTO `sys_dept` VALUES (202, 100, '0,100', '客户', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-04-17 00:39:36', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-04-16 20:34:59', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-04-16 20:34:59', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-04-16 20:34:59', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-04-16 20:34:59', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 193 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-16 22:09:16');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-16 23:38:59');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-16 23:39:08');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 00:12:18');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-17 00:40:34');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 00:40:48');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 01:17:27');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 11:44:42');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 15:54:50');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 17:11:21');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 20:51:38');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 22:25:57');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 23:04:29');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 23:35:13');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 01:35:34');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-18 01:36:10');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 01:36:12');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-18 02:28:54');
INSERT INTO `sys_logininfor` VALUES (118, 'tompAdmin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 02:29:06');
INSERT INTO `sys_logininfor` VALUES (119, 'tompAdmin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-18 02:43:32');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-18 02:43:38');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-18 02:43:39');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 02:43:47');
INSERT INTO `sys_logininfor` VALUES (123, '哈哈哈', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-04-18 02:51:58');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-18 02:55:54');
INSERT INTO `sys_logininfor` VALUES (125, '哈哈哈', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 02:56:03');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-18 11:35:07');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-18 11:35:11');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 11:35:21');
INSERT INTO `sys_logininfor` VALUES (129, '哈哈哈', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 11:36:42');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 19:30:55');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 19:34:57');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 23:21:14');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:12:24');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 01:37:43');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 01:53:56');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:54:01');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:15:05');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:15:07');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:15:48');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:15:54');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 00:18:49');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 01:23:14');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 02:09:37');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 02:19:41');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 02:23:11');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 02:32:22');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 02:53:42');
INSERT INTO `sys_logininfor` VALUES (148, '测试注册', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-04-24 02:53:58');
INSERT INTO `sys_logininfor` VALUES (149, '测试注册', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 02:54:11');
INSERT INTO `sys_logininfor` VALUES (150, '测试注册', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 02:54:58');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 02:55:01');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 04:11:02');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 04:37:33');
INSERT INTO `sys_logininfor` VALUES (154, '消费者一号', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-04-24 04:39:55');
INSERT INTO `sys_logininfor` VALUES (155, '消费者一号', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 04:40:07');
INSERT INTO `sys_logininfor` VALUES (156, '消费者一号', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 04:40:16');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 04:40:21');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 04:41:18');
INSERT INTO `sys_logininfor` VALUES (159, '消费者一号', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 04:41:28');
INSERT INTO `sys_logininfor` VALUES (160, '消费者一号', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-24 04:42:08');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 04:42:13');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 21:58:55');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 22:33:05');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-24 23:13:36');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-25 01:30:56');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-25 01:31:55');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-25 03:33:56');
INSERT INTO `sys_logininfor` VALUES (168, '小高', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-25 03:34:03');
INSERT INTO `sys_logininfor` VALUES (169, '小高', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-25 03:34:14');
INSERT INTO `sys_logininfor` VALUES (170, '小高', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-25 03:34:28');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-25 03:34:59');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-25 22:16:33');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-26 01:11:46');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-26 01:35:26');
INSERT INTO `sys_logininfor` VALUES (175, '郑宇星', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-04-26 01:36:00');
INSERT INTO `sys_logininfor` VALUES (176, '郑宇星', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-26 01:36:16');
INSERT INTO `sys_logininfor` VALUES (177, '郑宇星', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-26 01:36:40');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-26 01:36:43');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-26 01:37:22');
INSERT INTO `sys_logininfor` VALUES (180, '郑宇星', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-26 01:37:43');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-29 11:42:54');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-29 11:48:45');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-02 01:52:06');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-02 01:52:37');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-02 01:52:46');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-02 01:52:49');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-02 01:52:55');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-02 01:54:41');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 00:57:09');
INSERT INTO `sys_logininfor` VALUES (190, '郑宇星', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-04 22:57:17');
INSERT INTO `sys_logininfor` VALUES (191, '郑宇星', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-04 22:57:36');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-04 22:57:43');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2075 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-04-16 20:34:58', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-04-16 20:34:58', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2025-04-16 20:34:58', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-04-16 20:34:58', 'admin', '2025-04-23 01:15:06', '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-04-16 20:34:58', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-04-16 20:34:58', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-04-16 20:34:58', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-04-16 20:34:58', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-04-16 20:34:58', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-04-16 20:34:58', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-04-16 20:34:58', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-04-16 20:34:58', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-04-16 20:34:58', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-04-16 20:34:58', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-04-16 20:34:58', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-04-16 20:34:58', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-04-16 20:34:58', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-04-16 20:34:58', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-04-16 20:34:58', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-04-16 20:34:58', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-04-16 20:34:58', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-04-16 20:34:58', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-04-16 20:34:58', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-04-16 20:34:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '订单管理', 0, 4, 'orders', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'checkbox', 'admin', '2025-04-17 01:22:27', 'admin', '2025-04-17 17:28:01', '');
INSERT INTO `sys_menu` VALUES (2002, '工厂管理', 0, 5, 'factory', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', '2025-04-17 01:52:25', 'admin', '2025-04-17 17:26:42', '');
INSERT INTO `sys_menu` VALUES (2004, '工厂变更历史', 2002, 1, 'factoryHistory', 'factory/factoryHistory/index', NULL, '', 1, 0, 'C', '0', '0', 'factory:factoryHistory:list', '#', 'admin', '2025-04-17 23:50:59', '', NULL, '工厂变更历史菜单');
INSERT INTO `sys_menu` VALUES (2005, '工厂变更历史查询', 2004, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:query', '#', 'admin', '2025-04-17 23:50:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '工厂变更历史新增', 2004, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:add', '#', 'admin', '2025-04-17 23:50:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '工厂变更历史修改', 2004, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:edit', '#', 'admin', '2025-04-17 23:50:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '工厂变更历史删除', 2004, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:remove', '#', 'admin', '2025-04-17 23:50:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '工厂变更历史导出', 2004, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factoryHistory:export', '#', 'admin', '2025-04-17 23:50:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '工厂信息', 2002, 1, 'factorys', 'factory/factorys/index', NULL, '', 1, 0, 'C', '0', '0', 'factory:factorys:list', '#', 'admin', '2025-04-18 00:03:46', '', NULL, '工厂信息菜单');
INSERT INTO `sys_menu` VALUES (2011, '工厂信息查询', 2010, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factorys:query', '#', 'admin', '2025-04-18 00:03:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '工厂信息新增', 2010, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factorys:add', '#', 'admin', '2025-04-18 00:03:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2013, '工厂信息修改', 2010, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factorys:edit', '#', 'admin', '2025-04-18 00:03:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '工厂信息删除', 2010, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factorys:remove', '#', 'admin', '2025-04-18 00:03:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '工厂信息导出', 2010, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'factory:factorys:export', '#', 'admin', '2025-04-18 00:03:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '生产跟踪', 0, 6, 'produce', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'build', 'admin', '2025-04-18 00:43:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '个人信息', 0, 100, 'tompUser', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'user', 'admin', '2025-04-18 01:49:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '收货地址', 2029, 1, 'address', 'user/address/index', NULL, '', 1, 0, 'C', '0', '0', 'user:address:list', '#', 'admin', '2025-04-18 02:15:08', '', NULL, '收货地址菜单');
INSERT INTO `sys_menu` VALUES (2031, '收货地址查询', 2030, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'user:address:query', '#', 'admin', '2025-04-18 02:15:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '收货地址新增', 2030, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'user:address:add', '#', 'admin', '2025-04-18 02:15:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '收货地址修改', 2030, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'user:address:edit', '#', 'admin', '2025-04-18 02:15:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '收货地址删除', 2030, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'user:address:remove', '#', 'admin', '2025-04-18 02:15:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '收货地址导出', 2030, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'user:address:export', '#', 'admin', '2025-04-18 02:15:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '售后信息', 2000, 1, 'afterSales', 'order/afterSales/index', NULL, '', 1, 0, 'C', '0', '0', 'order:afterSales:list', '#', 'admin', '2025-04-18 02:15:16', '', NULL, '售后信息菜单');
INSERT INTO `sys_menu` VALUES (2037, '售后信息查询', 2036, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:afterSales:query', '#', 'admin', '2025-04-18 02:15:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '售后信息新增', 2036, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:afterSales:add', '#', 'admin', '2025-04-18 02:15:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '售后信息修改', 2036, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:afterSales:edit', '#', 'admin', '2025-04-18 02:15:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '售后信息删除', 2036, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:afterSales:remove', '#', 'admin', '2025-04-18 02:15:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '售后信息导出', 2036, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:afterSales:export', '#', 'admin', '2025-04-18 02:15:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '生产日志', 2028, 1, 'log', 'produce/log/index', NULL, '', 1, 0, 'C', '0', '0', 'produce:log:list', '#', 'admin', '2025-04-18 02:15:23', '', NULL, '生产日志菜单');
INSERT INTO `sys_menu` VALUES (2043, '生产日志查询', 2042, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:log:query', '#', 'admin', '2025-04-18 02:15:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '生产日志新增', 2042, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:log:add', '#', 'admin', '2025-04-18 02:15:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '生产日志修改', 2042, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:log:edit', '#', 'admin', '2025-04-18 02:15:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '生产日志删除', 2042, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:log:remove', '#', 'admin', '2025-04-18 02:15:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '生产日志导出', 2042, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:log:export', '#', 'admin', '2025-04-18 02:15:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '订单列表', 2000, 1, 'orders', 'order/orders/index', NULL, '', 1, 0, 'C', '0', '0', 'order:orders:list', '#', 'admin', '2025-04-18 02:15:29', '', NULL, '订单列表菜单');
INSERT INTO `sys_menu` VALUES (2049, '订单列表查询', 2048, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:orders:query', '#', 'admin', '2025-04-18 02:15:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '订单列表新增', 2048, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:orders:add', '#', 'admin', '2025-04-18 02:15:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '订单列表修改', 2048, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:orders:edit', '#', 'admin', '2025-04-18 02:15:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '订单列表删除', 2048, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:orders:remove', '#', 'admin', '2025-04-18 02:15:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '订单列表导出', 2048, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:orders:export', '#', 'admin', '2025-04-18 02:15:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '生产计划', 2028, 1, 'plan', 'produce/plan/index', NULL, '', 1, 0, 'C', '0', '0', 'produce:plan:list', '#', 'admin', '2025-04-18 02:15:34', '', NULL, '生产计划菜单');
INSERT INTO `sys_menu` VALUES (2055, '生产计划查询', 2054, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:plan:query', '#', 'admin', '2025-04-18 02:15:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '生产计划新增', 2054, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:plan:add', '#', 'admin', '2025-04-18 02:15:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '生产计划修改', 2054, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:plan:edit', '#', 'admin', '2025-04-18 02:15:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '生产计划删除', 2054, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:plan:remove', '#', 'admin', '2025-04-18 02:15:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '生产计划导出', 2054, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'produce:plan:export', '#', 'admin', '2025-04-18 02:15:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '子订单列表', 2000, 1, 'subOrder', 'order/subOrder/index', NULL, '', 1, 0, 'C', '0', '0', 'order:subOrder:list', '#', 'admin', '2025-04-18 02:15:40', '', NULL, '子订单列表菜单');
INSERT INTO `sys_menu` VALUES (2061, '子订单列表查询', 2060, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:subOrder:query', '#', 'admin', '2025-04-18 02:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '子订单列表新增', 2060, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:subOrder:add', '#', 'admin', '2025-04-18 02:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '子订单列表修改', 2060, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:subOrder:edit', '#', 'admin', '2025-04-18 02:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '子订单列表删除', 2060, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:subOrder:remove', '#', 'admin', '2025-04-18 02:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '子订单列表导出', 2060, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'order:subOrder:export', '#', 'admin', '2025-04-18 02:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '我的工厂', 2002, 3, 'factorys', 'factory/factorys/index', NULL, '', 1, 0, 'C', '0', '0', 'factory:factorys:list', 'theme', 'admin', '2025-04-24 00:44:15', 'admin', '2025-04-24 00:47:03', '');
INSERT INTO `sys_menu` VALUES (2073, '个人中心', 2029, 2, 'index', 'user/profile/index', NULL, 'userself', 1, 1, 'C', '0', '0', 'user:self', 'user', 'admin', '2025-04-24 01:06:06', 'admin', '2025-04-24 02:10:27', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (10, '全新通知', '1', 0x3C703EE59388E59388E59388E59388E9809AE79FA5EFBC81EFBC81EFBC813C2F703E, '0', '郑宇星', '2025-04-26 02:11:33', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1, '操作日志', 9, 'com.ruoyi.web.controller.monitor.SysOperlogController.clean()', 'DELETE', 1, 'admin', '研发部门', '/monitor/operlog/clean', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 00:48:19', 153);
INSERT INTO `sys_oper_log` VALUES (2, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/factory', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 00:54:06', 814);
INSERT INTO `sys_oper_log` VALUES (3, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/factory', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 00:56:00', 76);
INSERT INTO `sys_oper_log` VALUES (4, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"factorys\",\"className\":\"Factory\",\"columns\":[{\"capJavaField\":\"FactoryId\",\"columnComment\":\"工厂ID\",\"columnId\":34,\"columnName\":\"factory_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 15:55:37\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"factoryId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"updateTime\":\"2025-04-26 00:56:00\",\"usableColumn\":false},{\"capJavaField\":\"FactoryName\",\"columnComment\":\"工厂名\",\"columnId\":112,\"columnName\":\"factory_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-04-26 00:56:00\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"factoryName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联用户ID\",\"columnId\":35,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 15:55:37\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"updateTime\":\"2025-04-26 00:56:00\",\"usableColumn\":false},{\"capJavaField\":\"CapacityTop\",\"columnComment\":\"上衣产能\",\"columnId\":36,\"columnName\":\"capacity_top\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 15:55:37\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 01:02:12', 80);
INSERT INTO `sys_oper_log` VALUES (5, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"factory\"}', NULL, 0, NULL, '2025-04-26 01:02:30', 929);
INSERT INTO `sys_oper_log` VALUES (6, '工厂信息', 2, 'com.ruoyi.tompSys.controller.FactoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/factory/factorys', '127.0.0.1', '内网IP', '{\"capacityPants\":300,\"capacityTop\":500,\"costPants\":70,\"costTop\":50,\"factoryHistoryList\":[],\"factoryId\":1,\"factoryName\":\"欣欣鞋服\",\"isActive\":true,\"params\":{},\"qualityPants\":0.97,\"qualityTop\":0.98,\"userId\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 01:13:10', 60);
INSERT INTO `sys_oper_log` VALUES (7, '工厂信息', 2, 'com.ruoyi.tompSys.controller.FactoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/factory/factorys', '127.0.0.1', '内网IP', '{\"capacityPants\":2,\"capacityTop\":3,\"costPants\":2,\"costTop\":2,\"factoryHistoryList\":[],\"factoryId\":5,\"factoryName\":\"哈哈服装厂\",\"isActive\":true,\"params\":{},\"qualityPants\":0.6,\"qualityTop\":0.5,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 01:13:22', 14);
INSERT INTO `sys_oper_log` VALUES (8, '工厂信息', 2, 'com.ruoyi.tompSys.controller.FactoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/factory/factorys', '127.0.0.1', '内网IP', '{\"capacityPants\":100,\"capacityTop\":100,\"costPants\":3,\"costTop\":2,\"factoryHistoryList\":[],\"factoryId\":6,\"factoryName\":\"经纬织带\",\"isActive\":true,\"params\":{},\"qualityPants\":0.99,\"qualityTop\":0.9,\"userId\":100}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 01:13:47', 11);
INSERT INTO `sys_oper_log` VALUES (9, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-04-17 01:50:46\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,107,1035,1036,1037,1038,2000,2036,2037,2038,2039,2040,2041,2048,2049,2050,2051,2052,2053,2060,2061,2062,2063,2064,2065,2002,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2072,2028,2042,2043,2044,2045,2046,2047,2054,2055,2056,2057,2058,2059,2029,2030,2031,2032,2033,2034,2035,2073],\"params\":{},\"roleId\":102,\"roleKey\":\"factory\",\"roleName\":\"工厂用户\",\"roleSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 01:37:14', 25);
INSERT INTO `sys_oper_log` VALUES (10, '工厂信息', 1, 'com.ruoyi.tompSys.controller.FactoryController.add()', 'POST', 1, '郑宇星', NULL, '/factory/factorys', '127.0.0.1', '内网IP', '{\"capacityPants\":1,\"capacityTop\":1,\"costPants\":1,\"costTop\":1,\"factoryHistoryList\":[],\"factoryId\":7,\"factoryName\":\"经纬织带厂正版\",\"params\":{},\"qualityPants\":1,\"qualityTop\":1,\"userId\":105}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 01:38:32', 11);
INSERT INTO `sys_oper_log` VALUES (11, '通知公告', 3, 'com.ruoyi.web.controller.system.SysNoticeController.remove()', 'DELETE', 1, '郑宇星', NULL, '/system/notice/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 02:10:46', 10);
INSERT INTO `sys_oper_log` VALUES (12, '通知公告', 3, 'com.ruoyi.web.controller.system.SysNoticeController.remove()', 'DELETE', 1, '郑宇星', NULL, '/system/notice/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 02:11:00', 8);
INSERT INTO `sys_oper_log` VALUES (13, '通知公告', 1, 'com.ruoyi.web.controller.system.SysNoticeController.add()', 'POST', 1, '郑宇星', NULL, '/system/notice', '127.0.0.1', '内网IP', '{\"createBy\":\"郑宇星\",\"noticeContent\":\"<p>哈哈哈哈通知！！！</p>\",\"noticeTitle\":\"全新通知\",\"noticeType\":\"1\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-26 02:11:33', 21);
INSERT INTO `sys_oper_log` VALUES (14, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/04/29/1658045718294165804571897_20250429115039A001.jpg\",\"code\":200}', 0, NULL, '2025-04-29 11:50:39', 311);
INSERT INTO `sys_oper_log` VALUES (15, '工厂信息', 3, 'com.ruoyi.tompSys.controller.FactoryController.remove()', 'DELETE', 1, 'admin', '研发部门', '/factory/factorys/1,5,6,7', '127.0.0.1', '内网IP', '[1,5,6,7]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:06:16', 49);
INSERT INTO `sys_oper_log` VALUES (16, '订单列表', 3, 'com.ruoyi.tompSys.controller.OrdersController.remove()', 'DELETE', 1, 'admin', '研发部门', '/order/orders/7,8,11', '127.0.0.1', '内网IP', '[7,8,11]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:07:10', 16);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '超级管理员', 1, '0', 'admin', '2025-04-16 20:34:58', 'admin', '2025-04-24 01:16:17', '');
INSERT INTO `sys_post` VALUES (2, 'se', '普通用户', 2, '0', 'admin', '2025-04-16 20:34:58', 'admin', '2025-04-24 01:16:09', '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-04-16 20:34:58', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-04-16 20:34:58', 'admin', '2025-04-17 01:19:18', '普通角色');
INSERT INTO `sys_role` VALUES (100, '平台管理员', 'Padmin', 3, '1', 1, 1, '0', '0', 'admin', '2025-04-17 00:45:18', 'admin', '2025-04-18 02:28:47', NULL);
INSERT INTO `sys_role` VALUES (101, '消费者', 'customer', 4, '1', 1, 1, '0', '0', 'admin', '2025-04-17 01:50:20', 'admin', '2025-04-24 04:41:15', NULL);
INSERT INTO `sys_role` VALUES (102, '工厂用户', 'factory', 5, '1', 1, 1, '0', '0', 'admin', '2025-04-17 01:50:46', 'admin', '2025-04-26 01:37:14', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_extend
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_extend`;
CREATE TABLE `sys_role_extend`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `max_data_scope` int NULL DEFAULT NULL COMMENT '最大数据权限范围',
  `allowed_modules` json NULL COMMENT '允许访问模块',
  PRIMARY KEY (`role_id`) USING BTREE,
  CONSTRAINT `sys_role_extend_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_extend
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 1);
INSERT INTO `sys_role_menu` VALUES (100, 100);
INSERT INTO `sys_role_menu` VALUES (100, 102);
INSERT INTO `sys_role_menu` VALUES (100, 103);
INSERT INTO `sys_role_menu` VALUES (100, 104);
INSERT INTO `sys_role_menu` VALUES (100, 107);
INSERT INTO `sys_role_menu` VALUES (100, 108);
INSERT INTO `sys_role_menu` VALUES (100, 500);
INSERT INTO `sys_role_menu` VALUES (100, 501);
INSERT INTO `sys_role_menu` VALUES (100, 1000);
INSERT INTO `sys_role_menu` VALUES (100, 1001);
INSERT INTO `sys_role_menu` VALUES (100, 1002);
INSERT INTO `sys_role_menu` VALUES (100, 1003);
INSERT INTO `sys_role_menu` VALUES (100, 1004);
INSERT INTO `sys_role_menu` VALUES (100, 1005);
INSERT INTO `sys_role_menu` VALUES (100, 1006);
INSERT INTO `sys_role_menu` VALUES (100, 1012);
INSERT INTO `sys_role_menu` VALUES (100, 1013);
INSERT INTO `sys_role_menu` VALUES (100, 1014);
INSERT INTO `sys_role_menu` VALUES (100, 1015);
INSERT INTO `sys_role_menu` VALUES (100, 1016);
INSERT INTO `sys_role_menu` VALUES (100, 1017);
INSERT INTO `sys_role_menu` VALUES (100, 1018);
INSERT INTO `sys_role_menu` VALUES (100, 1019);
INSERT INTO `sys_role_menu` VALUES (100, 1020);
INSERT INTO `sys_role_menu` VALUES (100, 1021);
INSERT INTO `sys_role_menu` VALUES (100, 1022);
INSERT INTO `sys_role_menu` VALUES (100, 1023);
INSERT INTO `sys_role_menu` VALUES (100, 1024);
INSERT INTO `sys_role_menu` VALUES (100, 1035);
INSERT INTO `sys_role_menu` VALUES (100, 1036);
INSERT INTO `sys_role_menu` VALUES (100, 1037);
INSERT INTO `sys_role_menu` VALUES (100, 1038);
INSERT INTO `sys_role_menu` VALUES (100, 1039);
INSERT INTO `sys_role_menu` VALUES (100, 1040);
INSERT INTO `sys_role_menu` VALUES (100, 1041);
INSERT INTO `sys_role_menu` VALUES (100, 1042);
INSERT INTO `sys_role_menu` VALUES (100, 1043);
INSERT INTO `sys_role_menu` VALUES (100, 1044);
INSERT INTO `sys_role_menu` VALUES (100, 1045);
INSERT INTO `sys_role_menu` VALUES (100, 2000);
INSERT INTO `sys_role_menu` VALUES (100, 2002);
INSERT INTO `sys_role_menu` VALUES (100, 2004);
INSERT INTO `sys_role_menu` VALUES (100, 2005);
INSERT INTO `sys_role_menu` VALUES (100, 2006);
INSERT INTO `sys_role_menu` VALUES (100, 2007);
INSERT INTO `sys_role_menu` VALUES (100, 2008);
INSERT INTO `sys_role_menu` VALUES (100, 2009);
INSERT INTO `sys_role_menu` VALUES (100, 2010);
INSERT INTO `sys_role_menu` VALUES (100, 2011);
INSERT INTO `sys_role_menu` VALUES (100, 2012);
INSERT INTO `sys_role_menu` VALUES (100, 2013);
INSERT INTO `sys_role_menu` VALUES (100, 2014);
INSERT INTO `sys_role_menu` VALUES (100, 2015);
INSERT INTO `sys_role_menu` VALUES (100, 2028);
INSERT INTO `sys_role_menu` VALUES (100, 2029);
INSERT INTO `sys_role_menu` VALUES (100, 2030);
INSERT INTO `sys_role_menu` VALUES (100, 2031);
INSERT INTO `sys_role_menu` VALUES (100, 2032);
INSERT INTO `sys_role_menu` VALUES (100, 2033);
INSERT INTO `sys_role_menu` VALUES (100, 2034);
INSERT INTO `sys_role_menu` VALUES (100, 2035);
INSERT INTO `sys_role_menu` VALUES (100, 2036);
INSERT INTO `sys_role_menu` VALUES (100, 2037);
INSERT INTO `sys_role_menu` VALUES (100, 2038);
INSERT INTO `sys_role_menu` VALUES (100, 2039);
INSERT INTO `sys_role_menu` VALUES (100, 2040);
INSERT INTO `sys_role_menu` VALUES (100, 2041);
INSERT INTO `sys_role_menu` VALUES (100, 2042);
INSERT INTO `sys_role_menu` VALUES (100, 2043);
INSERT INTO `sys_role_menu` VALUES (100, 2044);
INSERT INTO `sys_role_menu` VALUES (100, 2045);
INSERT INTO `sys_role_menu` VALUES (100, 2046);
INSERT INTO `sys_role_menu` VALUES (100, 2047);
INSERT INTO `sys_role_menu` VALUES (100, 2048);
INSERT INTO `sys_role_menu` VALUES (100, 2049);
INSERT INTO `sys_role_menu` VALUES (100, 2050);
INSERT INTO `sys_role_menu` VALUES (100, 2051);
INSERT INTO `sys_role_menu` VALUES (100, 2052);
INSERT INTO `sys_role_menu` VALUES (100, 2053);
INSERT INTO `sys_role_menu` VALUES (100, 2054);
INSERT INTO `sys_role_menu` VALUES (100, 2055);
INSERT INTO `sys_role_menu` VALUES (100, 2056);
INSERT INTO `sys_role_menu` VALUES (100, 2057);
INSERT INTO `sys_role_menu` VALUES (100, 2058);
INSERT INTO `sys_role_menu` VALUES (100, 2059);
INSERT INTO `sys_role_menu` VALUES (100, 2060);
INSERT INTO `sys_role_menu` VALUES (100, 2061);
INSERT INTO `sys_role_menu` VALUES (100, 2062);
INSERT INTO `sys_role_menu` VALUES (100, 2063);
INSERT INTO `sys_role_menu` VALUES (100, 2064);
INSERT INTO `sys_role_menu` VALUES (100, 2065);
INSERT INTO `sys_role_menu` VALUES (101, 2000);
INSERT INTO `sys_role_menu` VALUES (101, 2028);
INSERT INTO `sys_role_menu` VALUES (101, 2029);
INSERT INTO `sys_role_menu` VALUES (101, 2030);
INSERT INTO `sys_role_menu` VALUES (101, 2031);
INSERT INTO `sys_role_menu` VALUES (101, 2032);
INSERT INTO `sys_role_menu` VALUES (101, 2033);
INSERT INTO `sys_role_menu` VALUES (101, 2034);
INSERT INTO `sys_role_menu` VALUES (101, 2035);
INSERT INTO `sys_role_menu` VALUES (101, 2036);
INSERT INTO `sys_role_menu` VALUES (101, 2037);
INSERT INTO `sys_role_menu` VALUES (101, 2038);
INSERT INTO `sys_role_menu` VALUES (101, 2039);
INSERT INTO `sys_role_menu` VALUES (101, 2040);
INSERT INTO `sys_role_menu` VALUES (101, 2041);
INSERT INTO `sys_role_menu` VALUES (101, 2042);
INSERT INTO `sys_role_menu` VALUES (101, 2043);
INSERT INTO `sys_role_menu` VALUES (101, 2044);
INSERT INTO `sys_role_menu` VALUES (101, 2045);
INSERT INTO `sys_role_menu` VALUES (101, 2046);
INSERT INTO `sys_role_menu` VALUES (101, 2047);
INSERT INTO `sys_role_menu` VALUES (101, 2048);
INSERT INTO `sys_role_menu` VALUES (101, 2049);
INSERT INTO `sys_role_menu` VALUES (101, 2050);
INSERT INTO `sys_role_menu` VALUES (101, 2051);
INSERT INTO `sys_role_menu` VALUES (101, 2052);
INSERT INTO `sys_role_menu` VALUES (101, 2053);
INSERT INTO `sys_role_menu` VALUES (101, 2054);
INSERT INTO `sys_role_menu` VALUES (101, 2055);
INSERT INTO `sys_role_menu` VALUES (101, 2056);
INSERT INTO `sys_role_menu` VALUES (101, 2057);
INSERT INTO `sys_role_menu` VALUES (101, 2058);
INSERT INTO `sys_role_menu` VALUES (101, 2059);
INSERT INTO `sys_role_menu` VALUES (101, 2060);
INSERT INTO `sys_role_menu` VALUES (101, 2061);
INSERT INTO `sys_role_menu` VALUES (101, 2062);
INSERT INTO `sys_role_menu` VALUES (101, 2063);
INSERT INTO `sys_role_menu` VALUES (101, 2064);
INSERT INTO `sys_role_menu` VALUES (101, 2065);
INSERT INTO `sys_role_menu` VALUES (101, 2073);
INSERT INTO `sys_role_menu` VALUES (102, 1);
INSERT INTO `sys_role_menu` VALUES (102, 100);
INSERT INTO `sys_role_menu` VALUES (102, 107);
INSERT INTO `sys_role_menu` VALUES (102, 1000);
INSERT INTO `sys_role_menu` VALUES (102, 1001);
INSERT INTO `sys_role_menu` VALUES (102, 1002);
INSERT INTO `sys_role_menu` VALUES (102, 1003);
INSERT INTO `sys_role_menu` VALUES (102, 1004);
INSERT INTO `sys_role_menu` VALUES (102, 1005);
INSERT INTO `sys_role_menu` VALUES (102, 1006);
INSERT INTO `sys_role_menu` VALUES (102, 1035);
INSERT INTO `sys_role_menu` VALUES (102, 1036);
INSERT INTO `sys_role_menu` VALUES (102, 1037);
INSERT INTO `sys_role_menu` VALUES (102, 1038);
INSERT INTO `sys_role_menu` VALUES (102, 2000);
INSERT INTO `sys_role_menu` VALUES (102, 2002);
INSERT INTO `sys_role_menu` VALUES (102, 2004);
INSERT INTO `sys_role_menu` VALUES (102, 2005);
INSERT INTO `sys_role_menu` VALUES (102, 2006);
INSERT INTO `sys_role_menu` VALUES (102, 2007);
INSERT INTO `sys_role_menu` VALUES (102, 2008);
INSERT INTO `sys_role_menu` VALUES (102, 2009);
INSERT INTO `sys_role_menu` VALUES (102, 2010);
INSERT INTO `sys_role_menu` VALUES (102, 2011);
INSERT INTO `sys_role_menu` VALUES (102, 2012);
INSERT INTO `sys_role_menu` VALUES (102, 2013);
INSERT INTO `sys_role_menu` VALUES (102, 2014);
INSERT INTO `sys_role_menu` VALUES (102, 2015);
INSERT INTO `sys_role_menu` VALUES (102, 2028);
INSERT INTO `sys_role_menu` VALUES (102, 2029);
INSERT INTO `sys_role_menu` VALUES (102, 2030);
INSERT INTO `sys_role_menu` VALUES (102, 2031);
INSERT INTO `sys_role_menu` VALUES (102, 2032);
INSERT INTO `sys_role_menu` VALUES (102, 2033);
INSERT INTO `sys_role_menu` VALUES (102, 2034);
INSERT INTO `sys_role_menu` VALUES (102, 2035);
INSERT INTO `sys_role_menu` VALUES (102, 2036);
INSERT INTO `sys_role_menu` VALUES (102, 2037);
INSERT INTO `sys_role_menu` VALUES (102, 2038);
INSERT INTO `sys_role_menu` VALUES (102, 2039);
INSERT INTO `sys_role_menu` VALUES (102, 2040);
INSERT INTO `sys_role_menu` VALUES (102, 2041);
INSERT INTO `sys_role_menu` VALUES (102, 2042);
INSERT INTO `sys_role_menu` VALUES (102, 2043);
INSERT INTO `sys_role_menu` VALUES (102, 2044);
INSERT INTO `sys_role_menu` VALUES (102, 2045);
INSERT INTO `sys_role_menu` VALUES (102, 2046);
INSERT INTO `sys_role_menu` VALUES (102, 2047);
INSERT INTO `sys_role_menu` VALUES (102, 2048);
INSERT INTO `sys_role_menu` VALUES (102, 2049);
INSERT INTO `sys_role_menu` VALUES (102, 2050);
INSERT INTO `sys_role_menu` VALUES (102, 2051);
INSERT INTO `sys_role_menu` VALUES (102, 2052);
INSERT INTO `sys_role_menu` VALUES (102, 2053);
INSERT INTO `sys_role_menu` VALUES (102, 2054);
INSERT INTO `sys_role_menu` VALUES (102, 2055);
INSERT INTO `sys_role_menu` VALUES (102, 2056);
INSERT INTO `sys_role_menu` VALUES (102, 2057);
INSERT INTO `sys_role_menu` VALUES (102, 2058);
INSERT INTO `sys_role_menu` VALUES (102, 2059);
INSERT INTO `sys_role_menu` VALUES (102, 2060);
INSERT INTO `sys_role_menu` VALUES (102, 2061);
INSERT INTO `sys_role_menu` VALUES (102, 2062);
INSERT INTO `sys_role_menu` VALUES (102, 2063);
INSERT INTO `sys_role_menu` VALUES (102, 2064);
INSERT INTO `sys_role_menu` VALUES (102, 2065);
INSERT INTO `sys_role_menu` VALUES (102, 2072);
INSERT INTO `sys_role_menu` VALUES (102, 2073);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `contact_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系方式',
  `audit_status` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '审核状态',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '激活状态',
  PRIMARY KEY (`user_id`) USING BTREE,
  INDEX `idx_user_type`(`user_type` ASC) USING BTREE,
  INDEX `idx_audit_status`(`audit_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '高翔', '00', 'preston_1997@163.com', '13850231340', '0', '/profile/avatar/2025/04/29/1658045718294165804571897_20250429115039A001.jpg', '$2a$10$mI6IfR9FQvBsFYZfbMMPS.SH5Ory9socEMk18lJdXsLctaGr9yrjq', '0', '0', '127.0.0.1', '2025-05-04 22:57:44', 'admin', '2025-04-16 20:34:58', '', '2025-05-04 22:57:43', '管理员', NULL, 'pending', 1);
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2025-04-16 20:34:58', 'admin', '2025-04-16 20:34:58', '', NULL, '测试员', NULL, 'pending', 1);
INSERT INTO `sys_user` VALUES (100, 101, '小高', '鸿衍布草', '00', '', '', '0', '', '$2a$10$j9p6LFxODf8rAwmJLClX1OcghEvd4cxRH.I3zP1quYe.W5qghwcRC', '0', '0', '127.0.0.1', '2025-04-25 03:34:15', 'admin', '2025-04-18 01:04:41', '', '2025-04-25 03:34:14', NULL, NULL, 'pending', 1);
INSERT INTO `sys_user` VALUES (101, 100, 'tompAdmin', '平台管理员001', '00', '', '', '0', '/profile/avatar/2025/04/18/尊享盒装8件套_20250418023451A001.png', '$2a$10$L3C9dUgWduP45c4ikk/KUeF3Bf3d59NGLPtBFY3B9qHZkQjzPPoDe', '0', '0', '127.0.0.1', '2025-04-18 02:29:06', 'admin', '2025-04-18 02:28:05', '', '2025-04-18 02:29:06', NULL, NULL, 'pending', 1);
INSERT INTO `sys_user` VALUES (102, 200, '哈哈哈', '哈哈哈', '00', '', '', '0', '/profile/avatar/2025/04/18/尊享盒装8件套_20250418025651A002.png', '$2a$10$JMZ1CxfG0ar6Ok.sxnPymOkpiIHFQ0LTccmRfoXxwNPgjwdqH7LsG', '0', '0', '127.0.0.1', '2025-04-18 11:36:43', '', '2025-04-18 02:51:58', 'admin', '2025-04-25 03:39:20', NULL, NULL, 'pending', 1);
INSERT INTO `sys_user` VALUES (103, NULL, '测试注册', '测试注册', '00', '', '', '0', '', '$2a$10$Go.NSawEvXgxScEEP5uLVubbAkOqPLcpqfig1hRwSzH.A/1Ic6fsu', '0', '0', '127.0.0.1', '2025-04-24 02:54:12', '', '2025-04-24 02:53:58', '', '2025-04-24 02:54:11', NULL, NULL, 'pending', 1);
INSERT INTO `sys_user` VALUES (104, NULL, '消费者一号', '消费者一号', '00', '', '', '0', '', '$2a$10$xSFtjljHA7.emw0yHFaG2eC7yiYrB3UMiY1Ayn5Tl0r268WborbN2', '0', '0', '127.0.0.1', '2025-04-24 04:41:28', '', '2025-04-24 04:39:55', '', '2025-04-24 04:41:28', NULL, NULL, 'pending', 1);
INSERT INTO `sys_user` VALUES (105, NULL, '郑宇星', '郑宇星', '00', '', '', '0', '', '$2a$10$Szhc2zmydhA9HGOC1v3Kq.PtStybQ63iTyOzddrqRRAu9PezM51ES', '0', '0', '127.0.0.1', '2025-05-04 22:57:18', '', '2025-04-26 01:36:00', '', '2025-05-04 22:57:17', NULL, NULL, 'pending', 1);

-- ----------------------------
-- Table structure for sys_user_factory
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_factory`;
CREATE TABLE `sys_user_factory`  (
  `user_id` bigint NOT NULL,
  `factory_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  INDEX `factory_id`(`factory_id` ASC) USING BTREE,
  CONSTRAINT `sys_user_factory_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sys_user_factory_ibfk_2` FOREIGN KEY (`factory_id`) REFERENCES `factory` (`factory_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_factory
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (102, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (100, 102);
INSERT INTO `sys_user_role` VALUES (101, 100);
INSERT INTO `sys_user_role` VALUES (102, 100);
INSERT INTO `sys_user_role` VALUES (104, 101);
INSERT INTO `sys_user_role` VALUES (105, 102);

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `config_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `config_value` json NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`config_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_config
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
