# Лабораторная работа №4

## Описание предметной области, по которой должна быть построена доменная модель:
 
  Олвин уже почти трансформировал свою комнату, когда до его сознания дошел настойчивый сигнал, напоминающий позвякивание колокольчика. Сформировав мысленный импульс, Олвин позволил гостю появиться, и стена, на которой он только что занимался живописью, снова связала его с внешним миром. Как он и ожидал, в обрисовавшемся проеме стояли его родители, а чуть позади них -- Джизирак. Присутствие наставника означало, что визит носит не просто семейный характер. Впрочем, даже и не будь здесь Джизирака, он бы все равно догадался об этом.

## Инфологическая модель
![infolog](https://github.com/Avvessalom/ITMO-Information-Systems-and-Databases/blob/master/Lab_1/infological%20model.png)

## Даталогическая модель

![datalog](https://github.com/Avvessalom/ITMO-Information-Systems-and-Databases/blob/master/Lab_4/Lab_4_new.png)

## Функциональные зависимости для отношений схемы (минимальное множество)
 * Thing_ID → name
 * Thing_ID → size
 * Signal_ID → intensity
 * Signal_ID → looks like
 * Person_ID → name
 * Person_ID → sex
 * Person_ID → age
 * Person_ID → weight
 * Location_ID → name
 * Location_ID → room
 * Doing_ID → name 
 * Doing_ID → result
    
## Нормализация
Пройдёмся эволюционно:
### 1 Нормальная форма (1НФ):
  На пересечении строки и столбца содержится только одно значение.

  Это ключевое определение реляционной базы данных и при проектировании первой лабораторной работы это было учтено.

  _**Изменения не требуются**_

### 2 Нормальная форма (2НФ):
  1. Отношения находятся в 1НФ;
  2. Каждый атрибут, не входящий в первичный ключ, полностью функционально зависит от первичного ключа
   
   В каждой таблице атрибуты не включенные в первичный ключ непосредственно зависят от него. Следовательно схема удовлетворяет условиям 2НФ.

  _**Изменения не требуются**_

  ### 3 Нормальная форма (3НФ):
  1. Отношения находятся в 2НФ;
  2. Нет атрибутов, не входящих в первичный ключ, которые находятся в транзитивной зависимости от первичного ключа.
   
  Я правда не знаю как так получилось, но и третей нормальной формой у меня полный порядок.
   
  Транзитивных зависимостей у меня как не было, так и не появилось (хотя откуда им появляться, если манипуляций со схемой не производилось).  Проще говоря, нет не ключевых полей, содержимое которых может относиться к нескольким записям таблицы.

  _**Изменения не требуются**_

   ### Нормальная форма Бойса-Кодда
   1. Отношения находятся в 3НФ;
   2. Каждый детерминант является потенциальным ключем;
   3. В таблице должен остаться только один первичный ключ.

  Так как мы выполняем нормализацию эволюционно, то первый пункт выполняется сам собой. 
  Каждый детерминант каждой таблицы является потенциальным ключем, например:
 * Location
   * `name`, `room` → `loc_ID`
   * (`name, room`) - являются потенциальным ключем   
 * Signal
   * `looks like`, `intensity` → `signal_ID`
   * (`looks like`, `intensity`) - являются потенциальным ключем  
  Так как все первичные ключи одинарные 3НФ=БКНФ
  ## Полезные денормализации
  1. По тексту у локаций имеется только один хозяин и это *Олвин*, поэтому можно избавиться от таблицы `Owner_loc` и `Location` и  поместить их содержимое в  `Person`. Появятся новы функциональные зависимости  
      * `person_ID → loc_ID`
      * `person_ID` → `loc_ID` → `room_name_ID`
      * `person_ID` → `loc_ID` → `room`
  
  Эта денормализация нарушает третью нормальную форму, так как присутствует транзитивная зависимость от первичного ключа.

  ## Выводы
  В ходе выполненной работы я должен был нормализовать модель из первой лабораторной работы, но что-то пошло не так. Схема изначально была в БКНФ. Вообщем я не понимаю, я молодец или запорол лабу.
