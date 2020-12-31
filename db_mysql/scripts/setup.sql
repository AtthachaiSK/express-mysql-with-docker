SET SQL_SAFE_UPDATES = 0;

CREATE TABLE `ACTIVITY` (
  `id` int NOT NULL AUTO_INCREMENT,
  `readed` char(1) NOT NULL,
  `first_read_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_read_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int NOT NULL,
  `news_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_or_insert_activity`(IN userId int, IN newsId int)
BEGIN
	IF EXISTS (select id from ACTIVITY where user_id = userId and news_id = newsId) THEN
		update ACTIVITY set  last_read_date = now()  where user_id = userId and news_id = newsId ;
  ELSE 
        insert into ACTIVITY (readed, last_read_date, user_id, news_id)  values('Y', now() , userId, newsId);
  END IF;
END$$
DELIMITER ;

CREATE TABLE `PROJECTS` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project` char(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `PROJECTS` (`id`,`project`,`project_desc`) VALUES (1,'ALL','ALL_DESC');
INSERT INTO `PROJECTS` (`id`,`project`,`project_desc`) VALUES (2,'A','A_DESC');
INSERT INTO `PROJECTS` (`id`,`project`,`project_desc`) VALUES (3,'B','B_DESC');


CREATE TABLE `USERS` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `lastname` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `phone_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER $$
CREATE DEFINER=`root`@`%` TRIGGER `USERS_BEFORE_INSERT` BEFORE INSERT ON `USERS` FOR EACH ROW BEGIN
       IF (SELECT IF( EXISTS( SELECT * FROM PROJECTS WHERE id = NEW.project_id), 0, 1))   THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'project_id field is not valid , not exists in projects table';
		END IF;
END$$
DELIMITER ;



INSERT INTO DBMOCKUP.USERS (username,name,lastname,phone_no,project_id) 
VALUES 
('takeshi@gmail.com','Takeshi','Mura','0837273492',2),
('nobita@outlook.com','Nobita','Jian','0981342212',2),
('shizuka@hotmail.com','Shizuka','Jung','0818484848',3),
('suneo@gmail.com','Sueno','Sushi','0979292928',3),
('tsubaza@outlook.com','Tsubaza','Baki','0828472938',2),
('bryan@icloud.com','Bryan','Trump','0849184849',3);


CREATE TABLE `NEWS` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title_th` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `title_en` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `detail_th` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `detail_en` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_id` int NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `stop_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER $$
CREATE DEFINER=`root`@`%` TRIGGER `NEWS_BEFORE_INSERT` BEFORE INSERT ON `NEWS` FOR EACH ROW BEGIN
  IF (SELECT IF( EXISTS( SELECT * FROM PROJECTS WHERE id = NEW.project_id), 0, 1))   THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'project_id field is not valid , not exists in projects table';
		END IF;
END$$
DELIMITER ;

CREATE TABLE `NEWS_USERS` (
  `id` int NOT NULL AUTO_INCREMENT,
  `news_id` int NOT NULL,
  `users_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_idx1` (`news_id`),
  KEY `id_users_groupnews_idx` (`users_id`),
  CONSTRAINT `id_news_groupnews` FOREIGN KEY (`news_id`) REFERENCES `NEWS` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_users_groupnews` FOREIGN KEY (`users_id`) REFERENCES `USERS` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DELIMITER $$
CREATE DEFINER=`root`@`%` TRIGGER `NEWS_AFTER_INSERT` AFTER INSERT ON `NEWS` FOR EACH ROW BEGIN
 IF (NEW.project_id = 1) THEN    
		INSERT INTO  DBMOCKUP.NEWS_USERS (users_id,news_id) 
		SELECT  DISTINCT id , NEW.`id`  from USERS;
ELSE
		INSERT INTO  DBMOCKUP.NEWS_USERS (users_id,news_id) 
		SELECT  DISTINCT id , NEW.`id`  from USERS where  USERS.project_id = NEW.`project_id`;
	END IF;
END$$
DELIMITER ;


-- INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('วันสงกรานต์1','Songkran Day1','detail_th','detail_th',1,'2020-02-01 00:00:00','2020-02-28 00:00:00');
-- INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('วันสงกรานต์2','Songkran Day2','detail_th','detail_th',2,'2020-02-01 00:00:00','2020-02-28 00:00:00');
INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('วันสงกรานต์','Songkran Day','<h2>กิจกรรมวันสงกรานต์</h2> \n<p><strong>การทำบุญตักบาตร</strong>&nbsp;นับว่าเป็นการสร้างบุญสร้างกุศลให้กับตนเอง อีกทั้งยังเป็นการอุทิศส่วนกุศลนั้นให้แก่ผู้ที่ล่วงลับไปแล้ว การทำบุญในลักษณะนี้มักจะมีการเตรียมไว้ล่วงหน้า เมื่อถึงเวลาทำบุญก็จะนำอาหารไปตักบาตรถวายพระภิกษุที่ศาลาวัดโดยจัดเป็นที่รวมสำหรับการทำบุญ ในวันเดียวกันนี้หลังจากที่ได้ทำบุญเสร็จเรียบร้อย ก็จะมีการก่อเจดีย์ทรายอันเป็นประเพณีที่สำคัญในวันสงกรานต์อีกด้วย</p>\n<p><strong>การรดน้ำ</strong>&nbsp;นับได้ว่าเป็นการอวยพรปีใหม่ให้แก่กันและกัน น้ำที่นำมาใช้รดหัวในการนี้มักเป็นน้ำหอมเจือด้วยน้ำธรรมดา</p>\n<p><strong>การสรงน้ำพระ</strong>&nbsp;เป็นการรดน้ำพระพุทธรูปที่บ้านและที่วัด ซึ่งในบางที่ก็จะมีการจัดให้สรงน้ำพระสงฆ์เพิ่มเติมด้วย</p>\n<p><strong>การบังสุกุลอัฐิ</strong>&nbsp;สำหรับเถ้ากระดูกของญาติผู้ใหญ่ที่ได้ล่วงลับไปแล้ว มักทำที่เก็บเป็นลักษณะของเจดีย์ จากนั้นจะนิมนต์พระไปบังสุกุล</p>\n<p><strong>การรดน้ำผู้ใหญ่</strong>&nbsp;คือการที่เราไปอวยพรผู้ใหญ่ใที่ห้ความเคารพนับถือ อย่าง ครูบาอาจารย์ มักจะนั่งลงกับที่ จากนั้นผู้ที่รดก็จะเอาน้ำหอมเจือกับน้ำธรรมดารดลงไปที่มือ ผู้หลักผู้ใหญ่ก็จะให้ศีลให้พรผู้ที่ไปรด หากเป็นพระก็อาจนำเอาผ้าสบงไปถวายเพื่อให้ผลัดเปลี่ยนด้วย แต่หากเป็นฆราวาสก็จะหาผ้าถุง หรือผ้าขาวม้าไปให้เปลี่ยน มีความหมายกับการเริ่มต้นสิ่งใหม่ๆ ในวันปีใหม่ไทย</p>\n<p><strong>การดำหัว</strong>&nbsp;มีจุดประสงค์คล้ายกับการรดน้ำของทางภาคกลาง ส่วนใหญ่จะพบเห็นการดำหัวได้ทางภาคเหนือ การดำหัวทำเพื่อแสดงความเคารพต่อผู้ที่อาวุโสว่า ไม่ว่าเป็น พระ ผู้สูงอายุ ซึ่งจะมีการขอขมาในสิ่งที่ได้ล่วงเกิน หรือเป็นการขอพรปีใหม่จากผู้ใหญ่ ของที่ใช้ในการดำหัวหลักๆ ประกอบด้วย อาภรณ์ มะพร้าว กล้วย ส้มป่อย เทียน และดอกไม้</p>\n<p><strong>การปล่อยนกปล่อยปลา</strong>&nbsp;ถือว่าการล้างบาปที่เราได้ทำไว้ เป็นการสะเดาะเคราะห์ร้ายให้กลายเป็นดี มีแต่ความสุข ความสบายในวันขึ้นปีใหม่</p>\n<p><strong>การขนททรายเข้าวัด</strong>&nbsp;ในทางภาคเหนือนิยมขนทรายเข้าวัดเพื่อเป็นนิมิตโชคลาคให้พบแต่ความสุข ความเจริญ เงินทองไหลมาเทมาดุจทรายที่ขนเข้าวัด แต่ก็มีบางพื้นที่มีความเชื่อว่า การนำทรายที่ติดเท้าออกจากวัดเป็นบาป จึงต้องขนทรายเข้าวัดเพื่อไม่ให้เกิดบาป</p>','<h2>กิจกรรมวันสงกรานต์</h2>\n<p><strong>การทำบุญตักบาตร</strong>&nbsp;นับว่าเป็นการสร้างบุญสร้างกุศลให้กับตนเอง อีกทั้งยังเป็นการอุทิศส่วนกุศลนั้นให้แก่ผู้ที่ล่วงลับไปแล้ว การทำบุญในลักษณะนี้มักจะมีการเตรียมไว้ล่วงหน้า เมื่อถึงเวลาทำบุญก็จะนำอาหารไปตักบาตรถวายพระภิกษุที่ศาลาวัดโดยจัดเป็นที่รวมสำหรับการทำบุญ ในวันเดียวกันนี้หลังจากที่ได้ทำบุญเสร็จเรียบร้อย ก็จะมีการก่อเจดีย์ทรายอันเป็นประเพณีที่สำคัญในวันสงกรานต์อีกด้วย</p>\n<p><strong>การรดน้ำ</strong>&nbsp;นับได้ว่าเป็นการอวยพรปีใหม่ให้แก่กันและกัน น้ำที่นำมาใช้รดหัวในการนี้มักเป็นน้ำหอมเจือด้วยน้ำธรรมดา</p>\n<p><strong>การสรงน้ำพระ</strong>&nbsp;เป็นการรดน้ำพระพุทธรูปที่บ้านและที่วัด ซึ่งในบางที่ก็จะมีการจัดให้สรงน้ำพระสงฆ์เพิ่มเติมด้วย</p>\n<p><strong>การบังสุกุลอัฐิ</strong>&nbsp;สำหรับเถ้ากระดูกของญาติผู้ใหญ่ที่ได้ล่วงลับไปแล้ว มักทำที่เก็บเป็นลักษณะของเจดีย์ จากนั้นจะนิมนต์พระไปบังสุกุล</p>\n<p><strong>การรดน้ำผู้ใหญ่</strong>&nbsp;คือการที่เราไปอวยพรผู้ใหญ่ใที่ห้ความเคารพนับถือ อย่าง ครูบาอาจารย์ มักจะนั่งลงกับที่ จากนั้นผู้ที่รดก็จะเอาน้ำหอมเจือกับน้ำธรรมดารดลงไปที่มือ ผู้หลักผู้ใหญ่ก็จะให้ศีลให้พรผู้ที่ไปรด หากเป็นพระก็อาจนำเอาผ้าสบงไปถวายเพื่อให้ผลัดเปลี่ยนด้วย แต่หากเป็นฆราวาสก็จะหาผ้าถุง หรือผ้าขาวม้าไปให้เปลี่ยน มีความหมายกับการเริ่มต้นสิ่งใหม่ๆ ในวันปีใหม่ไทย</p>\n<p><strong>การดำหัว</strong>&nbsp;มีจุดประสงค์คล้ายกับการรดน้ำของทางภาคกลาง ส่วนใหญ่จะพบเห็นการดำหัวได้ทางภาคเหนือ การดำหัวทำเพื่อแสดงความเคารพต่อผู้ที่อาวุโสว่า ไม่ว่าเป็น พระ ผู้สูงอายุ ซึ่งจะมีการขอขมาในสิ่งที่ได้ล่วงเกิน หรือเป็นการขอพรปีใหม่จากผู้ใหญ่ ของที่ใช้ในการดำหัวหลักๆ ประกอบด้วย อาภรณ์ มะพร้าว กล้วย ส้มป่อย เทียน และดอกไม้</p>\n<p><strong>การปล่อยนกปล่อยปลา</strong>&nbsp;ถือว่าการล้างบาปที่เราได้ทำไว้ เป็นการสะเดาะเคราะห์ร้ายให้กลายเป็นดี มีแต่ความสุข ความสบายในวันขึ้นปีใหม่</p>\n<p><strong>การขนททรายเข้าวัด</strong>&nbsp;ในทางภาคเหนือนิยมขนทรายเข้าวัดเพื่อเป็นนิมิตโชคลาคให้พบแต่ความสุข ความเจริญ เงินทองไหลมาเทมาดุจทรายที่ขนเข้าวัด แต่ก็มีบางพื้นที่มีความเชื่อว่า การนำทรายที่ติดเท้าออกจากวัดเป็นบาป จึงต้องขนทรายเข้าวัดเพื่อไม่ให้เกิดบาป</p>',1,'2020-02-01 00:00:00','2020-02-28 00:00:00');
INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('แจ้งวันหยุดเนื่องในวันมาฆบูชา','Makha  Bucha Day','<p>วันเสาร์ที่ 8 กุมภาพันธ์ 2563 สำนักงานนิติบุคคลปิดทำการเนื่องในวันมาฆบูชา</p>\n<p>จึงเรียนมาเพื่อทราบและขออภัยในความไม่สะดวก</p>','<p>วันเสาร์ที่ 8 กุมภาพันธ์ 2563 สำนักงานนิติบุคคลปิดทำการเนื่องในวันมาฆบูชา</p>\n<p>จึงเรียนมาเพื่อทราบและขออภัยในความไม่สะดวก</p>',2,'2020-02-01 00:00:00','2020-02-25 00:00:00');
INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('เพิ่มเครื่องออกกำลังกายภายในอาคารชุดฯ','เพิ่มเครื่องออกกำลังกายภายในอาคารชุดฯ','<p>เรียน ท่านเจ้าของร่วม/ผู้พักอาศัยทุกท่าน</p>\n<p>เรื่อง เพิ่มเครื่องออกกำลังกายภายในอาคารชุดฯ&nbsp;</p>\n<p>&nbsp; &nbsp; &nbsp; สืบเนื่องจาก บริษัท เอเชี่ยนพร็อพเพอร์ตี้ (2014) จำกัด เจ้าของโครงการ ได้ให้การสนับสนุน เครื่องออกกำลังกาย จำนวน 3 เครื่อง ให้กับอาคารชุด แอสปาย สาทร-ราชพฤกษ์ บริเวณจุดติดตั้งดังนี้&nbsp;</p>\n<p>1.Krankcycle ติดตั้งบริเวณชั้น 32 (พร้อมใช้งาน)</p>\n<p>2.S-Force Performance Trainer ติดตั้งบริเวณชั้น 32 (พร้อมใช้งาน)</p>\n<p>3.Climbmill ติดตั้ง ชั้น 8 (อยู่ระหว่างการจัดส่ง)&nbsp;</p>\n<p>จึงเรียนมาเพื่อทราบ</p>\n<p>นิติบุคคลอาคารชุด แอสปาย สาทร-ราชพฤกษ์</p>\n<p>&nbsp; &nbsp; &nbsp;</p>','<p>เรียน ท่านเจ้าของร่วม/ผู้พักอาศัยทุกท่าน</p>\n<p>เรื่อง เพิ่มเครื่องออกกำลังกายภายในอาคารชุดฯ&nbsp;</p>\n<p>&nbsp; &nbsp; &nbsp; สืบเนื่องจาก บริษัท เอเชี่ยนพร็อพเพอร์ตี้ (2014) จำกัด เจ้าของโครงการ ได้ให้การสนับสนุน เครื่องออกกำลังกาย จำนวน 3 เครื่อง ให้กับอาคารชุด แอสปาย สาทร-ราชพฤกษ์ บริเวณจุดติดตั้งดังนี้&nbsp;</p>\n<p>1.Krankcycle ติดตั้งบริเวณชั้น 32 (พร้อมใช้งาน)</p>\n<p>2.S-Force Performance Trainer ติดตั้งบริเวณชั้น 32 (พร้อมใช้งาน)</p>\n<p>3.Climbmill ติดตั้ง ชั้น 8 (อยู่ระหว่างการจัดส่ง)&nbsp;</p>\n<p>จึงเรียนมาเพื่อทราบ</p>\n<p>นิติบุคคลอาคารชุด แอสปาย สาทร-ราชพฤกษ์</p>\n<p>&nbsp; &nbsp; &nbsp;</p>',3,'2020-02-08 00:00:00','2020-02-29 00:00:00');
INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('การตรวจสอบงานระบบประจำเดือน ธันวาคม 2562','การตรวจสอบงานระบบประจำเดือน ธันวาคม 2562','<p>การตรวจสอบงาน ระบบประจำเดือน ธันวาคม 2562&nbsp;</p>\n<p>ฝ่ายวิศวกรรมส่วนกลาง</p>','<p>การตรวจสอบงาน ระบบประจำเดือน ธันวาคม 2562&nbsp;</p>\n<p>ฝ่ายวิศวกรรมส่วนกลาง</p>',3,NULL,NULL);
INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('รื้อกระเบื้องทางเดินส่วนกลางใหม่  ชั้น 17','รื้อกระเบื้องทางเดินส่วนกลางใหม่  ชั้น 17','<p style=\"text-align: justify;\"><strong>เรื่อง&nbsp; &nbsp;&nbsp;</strong><strong>รื้อกระเบื้องทางเดินส่วนกลางใหม่&nbsp; ชั้น 17 </strong></p>\n<p style=\"text-align: justify;\"><strong>เรียน&nbsp;&nbsp; ท่านเจ้าของร่วม / ผู้พักอาศัย</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>\n<p style=\"text-align: justify;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ทางฝ่ายบริหารได้ทำการรื้อกระเบื้องทางเดินส่วนกลางใหม่ ชั้น 17 เนื่องจากกระเบื้องโก่งตัวระหว่างรอยต่อ ของกระเบื้อง โดยช่างอาคารดำเนิน รื้อและปูกระเบื้องใหม่ใน <strong>วันอังคารที่ 10 ธันวาคม 2562 ถึง วันเสาร์ที่ 21 ธันวาคม 2562</strong> <strong>เวลา 9.00 น. &ndash; 17.00 น.</strong></p>\n<p style=\"text-align: justify;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ฝ่ายบริหารอาคารนิติบุคคลอาคารชุด ริธึ่ม สาทร-นราธิวาส ขออภัยในความไม่สะดวกต่างๆ ที่เกิดขึ้นจากการปฏิบัติงานดังกล่าว&nbsp; หากมีข้อสงสัยประการใด&nbsp; กรุณาติดต่อสอบถามข้อมูลเพิ่มเติม&nbsp; ได้ที่ 02-286-3651 ต่อ 101</p>','<p style=\"text-align: justify;\"><strong>เรื่อง&nbsp; &nbsp;&nbsp;</strong><strong>รื้อกระเบื้องทางเดินส่วนกลางใหม่&nbsp; ชั้น 17 </strong></p>\n<p style=\"text-align: justify;\"><strong>เรียน&nbsp;&nbsp; ท่านเจ้าของร่วม / ผู้พักอาศัย</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>\n<p style=\"text-align: justify;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ทางฝ่ายบริหารได้ทำการรื้อกระเบื้องทางเดินส่วนกลางใหม่ ชั้น 17 เนื่องจากกระเบื้องโก่งตัวระหว่างรอยต่อ ของกระเบื้อง โดยช่างอาคารดำเนิน รื้อและปูกระเบื้องใหม่ใน <strong>วันอังคารที่ 10 ธันวาคม 2562 ถึง วันเสาร์ที่ 21 ธันวาคม 2562</strong> <strong>เวลา 9.00 น. &ndash; 17.00 น.</strong></p>\n<p style=\"text-align: justify;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ฝ่ายบริหารอาคารนิติบุคคลอาคารชุด ริธึ่ม สาทร-นราธิวาส ขออภัยในความไม่สะดวกต่างๆ ที่เกิดขึ้นจากการปฏิบัติงานดังกล่าว&nbsp; หากมีข้อสงสัยประการใด&nbsp; กรุณาติดต่อสอบถามข้อมูลเพิ่มเติม&nbsp; ได้ที่ 02-286-3651 ต่อ 101</p>',2,'2020-02-05 00:00:00','2020-03-05 00:00:00');
INSERT INTO DBMOCKUP.NEWS (`title_th`,`title_en`,`detail_th`,`detail_en`,`project_id`,`start_date`,`stop_date`) VALUES ('ชาวจีนจะไม่หลงทางบนถนนในประเทศไทยอีกต่อไป เมื่อมีป้ายบอกเสอนทางถนนเป็นภาษาจีน','Lost in Thailand:  New Chinese road signs','<p>จากในภาพ คือ ไกด์นําเที่ยว ได้นําทางนักท่่องเที่ยวชาวจีนเดินข้ามถนนบริเวณพระที่นั่ง</p>','<p>A guide leads Chinese tourists at the Ananta Samakhom Throne Hall in Bangkok.The government will make road signs in Chinese to reduce accidents.</p>',2,'2020-01-05 00:00:00','2020-03-05 00:00:00');

CREATE TABLE `NEWS_USERS` (
  `id` int NOT NULL AUTO_INCREMENT,
  `news_id` int NOT NULL,
  `users_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_idx1` (`news_id`),
  KEY `id_users_groupnews_idx` (`users_id`),
  CONSTRAINT `id_news_groupnews` FOREIGN KEY (`news_id`) REFERENCES `NEWS` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_users_groupnews` FOREIGN KEY (`users_id`) REFERENCES `USERS` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;






