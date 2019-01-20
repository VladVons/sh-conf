-- Создаем необходимые таблицы и индексы.
-- Контакты.
CREATE TABLE phonebook (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
    name VARCHAR (128) NOT NULL,
    comment VARCHAR (256)
);
CREATE INDEX name ON phonebook (name);
 
-- Номера телефонов.
CREATE TABLE numbers (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    pid INTEGER REFERENCES phonebook (id) ON DELETE CASCADE NOT NULL, 
    comment VARCHAR (24), 
    NUMBER VARCHAR (32) NOT NULL
);
CREATE INDEX NUMBER ON numbers (NUMBER);
 
-- Добавляем немного данных для тестирования.
INSERT INTO `phonebook` (`name`, `comment`) VALUES ('Иван Иванов', 'Рога и копыта, менеджер');
INSERT INTO `numbers` (`pid`, `number`) VALUES (LAST_INSERT_ROWID(), '523703');

INSERT INTO `phonebook` (`name`) VALUES ('Петр Петров');
INSERT INTO `numbers` (`pid`, `number`) VALUES (LAST_INSERT_ROWID(), '423703');


INSERT INTO `phonebook` (`name`) VALUES ('Вонс Володимир');
INSERT INTO `numbers` (`pid`, `number`) VALUES (LAST_INSERT_ROWID(), '2010');
