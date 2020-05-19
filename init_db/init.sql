use app;

drop table if exists todos;
create table if not exists todos (
  id int not null auto_increment unique,
  title varchar(31) not null default '',
  body varchar(250) not null default ''
)
