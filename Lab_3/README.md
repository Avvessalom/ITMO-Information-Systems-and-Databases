#### Первый запрос
```sql
select "Н_ВЕДОМОСТИ"."ДАТА", "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД"
from "Н_ВЕДОМОСТИ"
         right join "Н_ТИПЫ_ВЕДОМОСТЕЙ" on "Н_ВЕДОМОСТИ"."ТВ_ИД" = "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД"
where "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" < 3
  and "Н_ВЕДОМОСТИ"."ДАТА" > '1998-10-05 00:00:00.00000';
```
![планы выполнения первого запроса](https://github.com/Avvessalom/ITMO-Information-Systems-and-Databases/blob/master/Lab_3/img/lab3.jpg)

Оптимальным планом выполнения запроса является правый, так как вместо полного объединения сущностей мы объединяем только выборки из них. Вследствие этого размер промежуточного отношения меньше.
##### Но можно оптимальнее
![планы выполнения первого запроса](https://github.com/Avvessalom/ITMO-Information-Systems-and-Databases/blob/master/Lab_3/img/lab3%20(1).jpg)

Индексы:

```sql
create index "НТВ_ИД" on "Н_ТИПЫ_ВЕДОМОСТЕЙ" using hash("ИД");
create index "НВ_ДАТА" on "Н_ВЕДОМОСТИ" using btree("ДАТА");
```

Добавление этих индексов должно сильно ускорить выполнение запросов, так как по ним идёт выборка с использованием операторов сравнения. 

Выполнение команды `EXPLAIN ANALYSE`:

    Query plan
    Nested Loop  (cost=1394.15..7278.45 rows=70506 width=12) (actual time=25.095..370.193 rows=202609 loops=1)
    "  ->  Seq Scan on ""Н_ТИПЫ_ВЕДОМОСТЕЙ""  (cost=0.00..1.04 rows=1 width=4) (actual time=0.077..0.083 rows=2 loops=1)"
    "        Filter: (""ИД"" < 3)"
            Rows Removed by Filter: 1
    "  ->  Bitmap Heap Scan on ""Н_ВЕДОМОСТИ""  (cost=1394.15..6572.35 rows=70506 width=12) (actual time=13.650..106.685 rows=101304 loops=2)"
    "        Recheck Cond: (""ТВ_ИД"" = ""Н_ТИПЫ_ВЕДОМОСТЕЙ"".""ИД"")"
    "        Filter: (""ДАТА"" > '1998-10-05 00:00:00'::timestamp without time zone)"
            Rows Removed by Filter: 4878
            Heap Blocks: exact=6314
    "        ->  Bitmap Index Scan on ""ВЕД_ТВ_FK_I""  (cost=0.00..1376.52 rows=74147 width=0) (actual time=13.261..13.261 rows=106182 loops=2)"
    "              Index Cond: (""ТВ_ИД"" = ""Н_ТИПЫ_ВЕДОМОСТЕЙ"".""ИД"")"
    Planning time: 3.569 ms
    Execution time: 443.169 ms

#### Второй запрос
```sql
select "Н_ЛЮДИ"."ФАМИЛИЯ", "Н_ОБУЧЕНИЯ"."НЗК", "Н_УЧЕНИКИ"."НАЧАЛО"
from "Н_ЛЮДИ"
         left join "Н_ОБУЧЕНИЯ" on "Н_ЛЮДИ"."ИД" = "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД"
         left join "Н_УЧЕНИКИ" on "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД"
where "Н_ЛЮДИ"."ОТЧЕСТВО" < 'Георгиевич'
  and "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД" > 163276
  and "Н_УЧЕНИКИ"."ИД" = 1;
```
![планы выполнения второго запроса](https://github.com/Avvessalom/ITMO-Information-Systems-and-Databases/blob/master/Lab_3/img/LAB3_2.jpg)

Оптимальным является второй план. За счёт раннего использования выборки, происходит соединение не целых сущностей,а только нужных нам выборок. Следовательно промежуточные данные меньше.


##### Но можно оптимальнее
![планы выполнения первого запроса](https://github.com/Avvessalom/ITMO-Information-Systems-and-Databases/blob/master/Lab_3/img/lab3%20(1).jpg)


Индексы:

```sql
create index "НУ_ИД" on "Н_УЧЕНИКИ" using hash ("ИД");
create index "НО_ЧЛВК_ИД" on "Н_ОБУЧЕНИЯ" using btree ("ЧЛВК_ИД");
create index "КороткиеГеоргии" on "Н_ЛЮДИ" using btree ("ОТЧЕСТВО");
```

Добавление этих индексов должно сильно ускорить выполнение запросов, так как по ним идёт выборка с использованием операторов сравнения. Первый индекс вообще must have для второго запроса.

Выполнение команды `EXPLAIN ANALYSE`:

    Query plan
    Nested Loop  (cost=0.85..17.03 rows=1 width=30) (actual time=0.053..0.053 rows=0 loops=1)
      ->  Nested Loop  (cost=0.57..16.62 rows=1 width=32) (actual time=0.041..0.047 rows=1 loops=1)
    "        ->  Index Scan using ""УЧЕН_PK"" on ""Н_УЧЕНИКИ""  (cost=0.29..8.30 rows=1 width=12) (actual time=0.016..0.017 rows=1 loops=1)"
    "              Index Cond: (""ИД"" = 1)"
    "        ->  Index Scan using ""ЧЛВК_PK"" on ""Н_ЛЮДИ""  (cost=0.28..8.30 rows=1 width=20) (actual time=0.020..0.022 rows=1 loops=1)"
    "              Index Cond: (""ИД"" = ""Н_УЧЕНИКИ"".""ЧЛВК_ИД"")"
    "              Filter: ((""ОТЧЕСТВО"")::text < 'Георгиевич'::text)"
    "  ->  Index Scan using ""ОБУЧ_ЧЛВК_FK_I"" on ""Н_ОБУЧЕНИЯ""  (cost=0.28..0.41 rows=1 width=10) (actual time=0.002..0.002 rows=0 loops=1)"
    "        Index Cond: ((""ЧЛВК_ИД"" = ""Н_ЛЮДИ"".""ИД"") AND (""ЧЛВК_ИД"" > 163276))"
    Planning time: 1.691 ms
    Execution time: 0.145 ms


