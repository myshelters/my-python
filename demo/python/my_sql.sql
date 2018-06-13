#先创建“学生选课”数据库：xsxk
create database if not exists xsxk;
#选定“xsxk”为当前数据库
use xsxk;

#院系表department是教师表teacher和学生表students的父表，先创建父表
create table department(
 d_no char(4) primary key comment '系别',
 d_name varchar(10) comment '院系名称'
 )engine=InnoDB default charset=gbk;

#创建子表students之前，必须先创建父表department
create table students(
 s_no char(12) primary key comment '学号',
 s_name varchar(4) not null comment '姓名',
 gender enum('男','女') not null default '男'  comment '性别',
 d_no char(4) not null  comment '系别',
 birthday date not null  comment '出生日期',
 phone char(12) not null  comment '电话',
 address varchar(20) not null comment '家庭住址',
 constraint d_s_fk foreign key (d_no) references department(d_no)
 )engine=InnoDB default charset=gbk;

#创建子表teacher之前，必须先创建父表department
create table teacher(
 t_no char(4) primary key  comment '教师编号',
 t_name varchar(4) not null comment '教师姓名',
 d_no char(4) comment '系别',
 constraint d_t_fk foreign key(d_no) references department(d_no)
 )engine=InnoDB default charset=gbk;

#创建子表course之前，必须先创建父表teacher
create table course(
 c_no char(4) primary key comment '课程号',
 c_name varchar(10) not null comment '课程名',
 credit tinyint(2) default 2 not null comment '学分',
 c_type char(3) default '必修' not null  comment '类型',
 t_no char(4) not null comment '教师编号',
 constraint t_c_fk foreign key(t_no) references teacher(t_no)
 )engine=InnoDB default charset=gbk;

#创建子表choose之前，必须先创建父表course、students
create table choose(
 id int auto_increment primary key comment '选课号',
 s_no char(12) not null comment '学号',
 c_no char(4) not null comment '课程号',
 score tinyint(3) unsigned comment '成绩',
 constraint s_c_fk foreign key(s_no) references students(s_no),
 constraint c_c_fk foreign key(c_no) references course(c_no)
 )engine=InnoDB default charset=gbk; 

/*
	以下命令分别向5个表中插入测试数据：
	因为5个表中存在外键约束，插入数据时必须：
	先插入父表的数据，然后才插入子表数据，所以在表中插入数据的顺序如下：
	院系表department —> 
	—> 教师表teacher、学生表students—> 
	—> 课程表course —> 选课表choose
*/
insert into department(d_no,d_name)
	values ('0001','计算机系') ,
		('0002','会计系') ,
		('0003','经济系') ,
		('0004','国际学院') ,
		('0005','工商管理系') ,
		('0006','数学系') ;

insert into teacher(t_no,t_name,d_no)
	values ('2007', '张丽', '0001'),
	('2008', '王晓宇', '0006'),
	('2009', '李辉', '0006'),
	('2010', '赵海', '0004');

insert into students(s_no,s_name, gender,d_no,birthday,phone,address)
	values ('201510101101','刘晓东','男','0001','1999-5-10','11000000001','昆明') ,
		('201510101102','林慧','女','0001','1999-12-15','11000000002','上海') ,
		('201511101103','李远鹏','男','0002','1998-10-25','11000000003','北京') ,
		('201511101104','吴娜文','女','0002','1999-8-10','11000000004','昆明') ,
		('201512101105','刘智','男','0003','1999-5-8','11000000005','北京') ,
		('201512101106','赵立民','男','0003','1999-2-25','11000000006','上海') ,
		('201513101116','王丽萍','女','0005','1998-6-3','11000000008','重庆') ;

insert into course(c_no,c_name,period,credit,c_type,t_no)
	values('1003','计算机基础',70,4.5,'必修','2001') ,
		('1004','数据库应用',60,4,'必修','2001') ,
		('1005','会计学',100,6.5,'必修','2002') ,
		('1006','经济学',80,5,'必修','2003') ,
		('2001','网页设计',32,1,'选修','2001') ;

insert into choose(id, s_no, c_no, score)
	values (null,'201510101101','1001',50) ,
		(null,'201510101102','1001',60) ,
		(null,'201511101103','1001',67) ,
		(null,'201511101103','1005',70) ,
		(null,'201511101104','1001',80) ,
		(null,'201511101104','1005',78) ,
		(null,'201512101105','1001',75) ,
		(null,'201512101105','1006',82) ,
		(null,'201512101106','1006',90) ,
		(null,'201513101116','2001',null) ;

insert into teacher(t_no,t_name,d_no)
 values('2007','张丽','0001'),
 ('2008',"王晓宇","0006"),
 ("2009","李辉",'0006'),
 ('2010','赵海','0004');



replace into department(d_no, d_name )
 values( '0004', '英语系' );
 
 #开始
		use xsxk;
		insert into students 
		values('201711106340','罗旭阳','男','0006','1999-5-10','11000000001','昆明');
		insert into course(c_no, c_name, credit, c_type, t_no)
		values('2002', '微积分', '5', '默认值', '2008'),
		('2003','统计学', '5', '默认值', '2009');

#数据更新
	update course set c_type       ='默认值' where c_no<=2003;
	update students set d_no       ='0006';
	select * from course ;
	delete from course where period;
	alter table course drop table period;
	update course set t_no         = '2010'where c_no='2002';
	delete from teacher where t_no ='2008';

#建立附表department1, choose1, choose2
	create table if not exists department1 like department;
	    insert into department1 select * from department;
	
	create table choose1 like choose;
	    insert into choose1 select * from choose;
	
	create table choose2 like choose;
	    insert into choose2 select * from choose;

#第八步 使外键不起作用 向department添加数值
    set FOREIGN_KEY_CHECKS = 0;
    replace into department (d_name, d_no) values ('英语系','0004');
    set FOREIGN_KEY_CHECKS = 1;
    select * from department;


#第九步
    delete from choose1;

#第十步
	insert into choose1(id,s_no,c_no)
	    values(null,'201711106340','1001'),
	    (null,'201711106340','1002');

#第十一步
	truncate table choose1;
	    show create table choose1;
	        insert into choose1(id , s_no ,c_no)
	            values(null,'1001','2017');
	        select * from choose1 ;

#第十二步 向choose2插入表格
	insert into choose2 (id,s_no,c_no)
	values(null,'201711106340','1001'),
	(null,'201711106340','1004');
	
	select * from choose2;


#步骤一
#1
select * from course;

#2
select c_no, c_name, period, credit from course;

#步骤二谓词过滤数据
#1
select distinct address from students;

#2
select * from students limit 1,3;


#步骤三 数据表的连接
#1检索学生院系
select students.s_no, s_name, department.d_no, d_name from students inner join department on students.d_no = department.d_no;
#2 检索学生选课信息
select students.s_no, s_name, choose.* from students inner join choose on students.s_no = choose.s_no;

#步骤四 where过滤结果
#1 课程号‘1001’或‘1002’，并且score<70
select s_no, score from choose where (c_no = '1001' or c_no = '1002') and score < 70;
#2 选课但是无成绩的学号，课程号
select s_no , c_no from choose where score is null;
#成绩80 到 90 之间的选课信息
select * from choose where score between 80 and 90;
#家庭住址不在'北京','上海'的学生的所有信息
select * from students where address != '上海' and address != '北京';
#姓“张” “田”老师的所有信息
select * from teacher where substring(t_name, 1, 1) = '张' or substring(t_name, 1, 1) = '田';
#姓'刘'，名字有三个字的学生信息
select * from students where substring(s_name, 1, 1) = '刘' and CHAR_LENGTH(s_name)>=3;
#检索所有课程带“数”
select * from course where c_name like '%数%';
#检索选修了高等数学的所有学生的成绩信息并按成绩降序排列输出结果
select * from choose where c_no = '1001' order by score desc ;
#6、 使用聚合函数汇总结果集。
#（1）  统计全部教师的人数。
select count(t_no) 教师人数 from teacher;
#（2）  统计缺考（score为null）的学生人数。
select count(s_no) - count(score) 缺考人数 from choose;
#（3）  统计学生“刘晓东”的平均成绩。
#7、 使用group by子句对记录分组统计。
#（1）  统计各系的学生人数（要求附上所有系的总人数）。
select department.d_no, count(s_no) from department left join students on students.d_no = department.d_no group by department.d_no with rollup;
#（2）  统计每个学生已经选修多少门课程，该生的最高分、最低分、总分及平均成绩。
select students.s_no, s_name, count(c_no), max(score), min(score), sum(score), avg(score) from students left join choose on students.s_no = choose.s_no group by students.s_no;
#（3）  检索平均成绩高于75分的学生及平均成绩。
select students.s_no, s_name, avg(score) from students left join choose on students.s_no = choose.s_no group by students.s_no having avg(score) >75;
#（4）  检索出选修了两门以上（含两门）课程的学生、课程门数和平均分。
select students.s_no, s_name, count(c_no), avg(score) from students left join choose on students.s_no = choose.s_no group by students.s_no having count(c_no) >2;
#8、 合并结果集。
 #   检索所有人员（包括教师和学生）所在院系的基本信息（编号、姓名、系别）。
 select students.s_no 编号, s_name 姓名, students.d_no 系别 from students union select teacher.t_no, t_name, teacher.d_no from teacher;
#9、 子查询。
#（1）  检索成绩比学生“林慧”平均分低的所有学生信息。
select students.s_no, s_name, score from choose join students on students.s_no = choose.s_no where score < (select avg(score)from students, choose where students.s_no = choose.s_no and s_name = '林慧');
#（2）  检索“会计系”所有学生的成绩。
select students.s_no, s_name, score from choose join  students on choose.s_no = students.s_no where students.s_no in (select s_no from students join department on students.d_no = department.d_no where department.d_name = '会计系');
#（3）  检索至少教授了一门课程的教师信息。
select * from teacher left join course on teacher.t_no = course.t_no group by students.s_no having count(c_no) >1;

select * from teacher join course on teacher.t_no = course.t_no group by teacher.t_no having count(c_no)>1;
#（4）  检索出没有授课的教师信息。
select * from teacher where t_no not in (select teacher.t_no from course where course.t_no = teacher.t_no);
    #（5） 检索出课程平均分高于70分的课程及该课程的最高分，输出该课程名及最高分两列数据。
select c_name, max(score) from course join choose on course.c_no = choose.c_no group by course.c_no having avg(score)>70;

select teacher.t_no, t_name from teacher left join course on course.t_no = teacher.t_no group by teacher.t_no having count(course.t_no)>1;
#1、用SQL语句查询students表中s_no,s_name, gender,d_no四个字段内容
select s_no, s_name, gender, d_no from students;

#2、用SQL语句查询choose表中高等数学成绩大于60的记录
select * from choose where c_no = '1001' and score > '60';

#3、用SQL语句查询高等数学成绩大于60的学生学号、姓名、性别三个字段
select students.s_no, s_name, gender, score, c_no from students left join choose on students.s_no = choose.s_no group by students.s_no having score >60 and c_no = '1001';
select students.s_no, s_name, avg(score) from students left join choose on students.s_no = choose.s_no group by students.s_no having avg(score) >75;

#4、用SQL语句查询students表中所有姓“张”的学生
select s_no, s_name from students where substring(s_name, 1, 1) = '张';
#5、用SQL语句查询choose表中每门课的选课人数
select course.c_no, c_name, count(*) from choose join course on choose.c_no = course.c_no group by c_no;
#6、用SQL语句查询出没有选课的学生名单
select students.s_no, s_name, c_no from students left join choose on students.s_no = choose.s_no group by students.s_no having choose.c_no is null;

#7、向choose表中插入一条新记录
set FOREIGN_KEY_CHECKS = 0;
insert into choose(id, s_no, c_no) values (null, '201811106350', '5220');
set FOREIGN_KEY_CHECKS = 1;
#8、把所有同学的高等数学成绩增加1分
update choose set score = score + 1 where c_no = '1001';
select * from choose where c_no = '1001';
#9、删除高等数学成绩不及格的选课记录。
select * from choose where score < '60';
delete from choose where score < '60' and c_no = '1001';

set foreign_key_checks = 0;
insert into choose values ('11', '201711106395', '1001', '51');