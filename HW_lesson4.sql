/*
 * i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)
 */

-- Сделано.



/*
 * ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
 */

SELECT DISTINCT firstname FROM users ORDER BY firstname;



/*
 * iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false).
 * Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
 */

ALTER TABLE profiles ADD is_active VARCHAR(5) DEFAULT 'true';

UPDATE profiles SET is_active='false' WHERE birthday > (now() - INTERVAL 18 YEAR);



/*
 * iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
 */

DELETE FROM messages WHERE created_at > now();



/*
 * v. Написать название темы курсового проекта (в комментарии)
 */

-- БД на примере сайта drive2.ru
