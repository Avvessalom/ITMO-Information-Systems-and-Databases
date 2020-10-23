select count(*) from (select "ФАМИЛИЯ", "ОТЧЕСТВО" from "Н_ЛЮДИ" where ("ОТЧЕСТВО", "ФАМИЛИЯ")
                                 in (select "ОТЧЕСТВО", "ФАМИЛИЯ"
                                     from "Н_ЛЮДИ" group by "ФАМИЛИЯ", "ОТЧЕСТВО"
                                    having count(*)=1
                                 ) order by "ФАМИЛИЯ"
) as rows_count;