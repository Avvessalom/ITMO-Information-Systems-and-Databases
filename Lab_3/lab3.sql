select "Н_ВЕДОМОСТИ"."ДАТА", "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД"
from "Н_ВЕДОМОСТИ"
         right join "Н_ТИПЫ_ВЕДОМОСТЕЙ" on "Н_ВЕДОМОСТИ"."ТВ_ИД" = "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД"
where "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" < 3
  and "Н_ВЕДОМОСТИ"."ДАТА" > '1998-10-05 00:00:00.00000';


select "Н_ЛЮДИ"."ФАМИЛИЯ", "Н_ОБУЧЕНИЯ"."НЗК", "Н_УЧЕНИКИ"."НАЧАЛО"
from "Н_ЛЮДИ"
         left join "Н_ОБУЧЕНИЯ" on "Н_ЛЮДИ"."ИД" = "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД"
         left join "Н_УЧЕНИКИ" on "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД"
where "Н_ЛЮДИ"."ОТЧЕСТВО" < 'Георгиевич'
  and "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД" > 163276
  and "Н_УЧЕНИКИ"."ИД" = 1;