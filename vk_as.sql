USE vk;

-- Тип учебного заведения
DROP TABLE IF EXISTS study_types;
CREATE TABLE study_types(
	id SERIAL PRIMARY KEY,
    name ENUM('school', 'college', 'university')
);

-- Где и когда учился
DROP TABLE IF EXISTS study;
CREATE TABLE study(
	id SERIAL PRIMARY KEY,
    study_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	name VARCHAR(255),
  	start_of_study YEAR NOT NULL,
  	end_of_study YEAR NOT NULL,
  	
    INDEX study_name_idx(name),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (study_type_id) REFERENCES study_types(id)
);

-- Последний раз в онлайне
DROP TABLE IF EXISTS online;
CREATE TABLE online(
	user_id SERIAL PRIMARY KEY,
    online_at DATETIME ON UPDATE NOW(),

	FOREIGN KEY (user_id) REFERENCES users(id)
);