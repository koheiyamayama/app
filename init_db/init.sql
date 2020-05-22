use app;

drop table if exists todos;
create table if not exists todos (
  id int not null auto_increment unique,
  title varchar(50) not null default '',
  body varchar(250) not null default ''
);

insert into todos (title, body) values ('ラズパイでインフラの実験する', 'ラズパイでインフラの実験する。ついでに、フロントの実験もする。ついでに、色々なことをする。');
insert into todos (title, body) values ('LXCでコンテナの実験する', 'ラズパイでインフラの実験する。ついでに、Dockerの実験もする。ついでに、色々なことをする。');
insert into todos (title, body) values ('コンピュターの理論と実装を読む', 'ついでに、色々なことをする。');
insert into todos (title, body) values ('UNIXの本読む', 'ついでに、フロントの実験もする。ついでに、色々なことをする。');
insert into todos (title, body) values ('Linuxの本読む', 'ついでに、フロントの実験もする。ついでに、色々なことをする。');
