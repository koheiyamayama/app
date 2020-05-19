use app;

create table if not exists todos (
  id int not null auto_increment unique,
  title varchar(20) not null default '',
  body varchar(250) not null default ''
)
