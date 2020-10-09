create table person (
    idp serial primary key,
    name varchar(20),
    sex Boolean,
    age integer,
    weight integer);

create table thing (
    idt serial primary key,
    name varchar(20),
    size integer);

create table signal (
    ids serial primary key,
    looks_like integer,
    intensity integer);

create table location (
    idloc serial primary key,
    name varchar(20),
    room Boolean);

create table owner_loc (
    idp integer references person(idp),
    idloc integer references location(idloc));

create table parent_child (
    idparent integer references person(idp),
    idchild integer references person(idp));

create table mentor_student (
    idteacher integer references person(idp),
    idstudent integer references person(idp));

create table doing (
    idd serial primary key,
    name varchar(20),
    idp integer references person(idp));

create table ownership (
    idp integer references person(idp),
    idt integer references thing(idt));

create table doing_result (
    idd integer references doing(idd),
    whenn varchar(20),
    impact_on_thing integer,
    impuct_on_person integer,
    result varchar(20));
