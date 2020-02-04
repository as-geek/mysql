/*
Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

UPDATE
	users
SET
	created_at = now(),
	updated_at = now();



/*
 * Таблица users была неудачно спроектирована.
 * Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
 * Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
 */

UPDATE
	users 
SET
	created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE
	users
CHANGE
	created_at created_at DATETIME DEFAULT NOW();

ALTER TABLE
	users
CHANGE
	updated_at updated_at DATETIME DEFAULT NOW() ON UPDATE NOW();



/*
 * В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился
 * и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке
 * увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
 */

-- Создаём таблицу
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

-- Наполняем данными
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
	(1, 1, 0),
	(1, 2, 2500),
	(1, 3, 0),
	(1, 4, 30),
	(1, 5, 500),
	(1, 6, 1);

-- Промежуточная сортировка
-- SELECT value, IF(value > 0, 1, 0) sort FROM storehouses_products ORDER BY sort DESC, value;

-- Окончательная сортировка
SELECT value FROM storehouses_products ORDER BY IF(value > 0, 1, 0) DESC, value;



/*
 * Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
 * Месяцы заданы в виде списка английских названий ('may', 'august')
 */

-- Создаём таблицу
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

-- Наполняем данными
INSERT INTO `users` VALUES
('1','et','2010-07-29','2002-05-13 22:12:08','2009-06-06 07:53:34'),
('2','culpa','1987-10-03','1998-10-12 12:22:19','1999-08-09 21:10:10'),
('3','amet','2020-01-07','1992-03-11 06:48:40','1981-05-09 07:56:45'),
('4','mollitia','1983-08-15','1973-11-21 13:11:30','2015-10-28 19:31:31'),
('5','beatae','2013-04-30','1970-02-21 01:19:08','2004-07-07 13:21:38'),
('6','esse','1974-04-22','1970-12-22 22:11:27','2016-11-25 04:47:19'),
('7','excepturi','1996-07-19','1991-06-27 23:24:10','1989-07-28 06:12:15'),
('8','eaque','2009-03-09','2005-10-04 18:41:39','1994-04-18 10:35:27'),
('9','cupiditate','1984-03-06','2009-01-06 23:55:12','2005-05-01 16:31:43'),
('10','occaecati','1998-10-04','1999-03-03 03:04:55','1983-06-09 05:41:01'); 

-- Промежуточный вывод
-- SELECT name, date_format(birthday_at, '%M') FROM users;

-- Окончательный вывод
SELECT name, birthday_at FROM users WHERE date_format(birthday_at, '%M') IN ('May', 'August');



/*
 * Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
 * Отсортируйте записи в порядке, заданном в списке IN
 */

-- Создаём таблицу
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

-- Наполняем данными
INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
-- Сортируем
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY field(id, 5, 1, 2);



/*
 * Подсчитайте средний возраст пользователей в таблице users
 */

SELECT avg(timestampdiff(YEAR, birthday_at, now())) AS age FROM users;



/*
 * Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 */

SELECT
	date_format(date(concat_ws('-', YEAR(now()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS `day`,
	count(*) AS total
FROM
	users
GROUP BY
	`day`
ORDER BY
	total DESC;



/*
 * Подсчитайте произведение чисел в столбце таблицы
 */

SELECT round(EXP(sum(LN(id)))) FROM catalogs;