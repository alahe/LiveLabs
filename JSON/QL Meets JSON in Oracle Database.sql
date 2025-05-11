-- #SQL Meets JSON in Oracle Database: Unify Data with Duality Views, JSON Collections & MongoDB API
-- https://livelabs.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=3635&p210_wec=&session=122316911509972
-- In this workshop, you will experience Oracle's JSON capabilities using both relational and document-store APIs
-- Objective
-- This workshop is not a 'cookbook' or 'design guideline' on how to work with JSON data - the purpose is to illustrate 
-- various JSON features that the Oracle Database offers.
-- ## Schema flexibility for relational tables with the JSON datatype
-- Please Note:: While this workshop is using Autonomous Database, all commands and features related to JSON enhancement 
-- are also available on any other Oracle Database 23ai (Version 23.4 or higher) release. 
-- This includes the 23ai Free release as well as 23ai running on Oracle Database Base Service or Oracle Engineered Systems.
-- LiveSQL JSON Duality Views Quick Start - https://livelabs.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=4004&p210_wec=&session=8637396206675
-- -----------------------------------------------------------------------------
-- Create a table movies that consists of relational columns and one JSON column.
create table if not exists movies (
      movie_id number primary key
    , title      varchar2(100) not null
    , type       varchar2(100)
    , format     varchar2(100)
    , condition  varchar2(100)
    , year       number
    , extras     JSON
);


-- Let us now insert some data into our table, using normal SQL.
insert into movies values (100, 'Coming to America', 'movie', 'DVD', 'acceptable', 1988,
                            '{ "price": 5,
                                 "comment": "DVD in excellent condition, cover is blurred",
                                "starring": ["Eddie Murphy", 
                                             "Arsenio Hall", 
                                             "James Earl Jones", 
                                             "John Amos"],
                                "decade": "80s"}');

 --Let us insert some more records. We will also use the JSON() constructor in this example and insert two rows in one go.
insert into movies values (101, 'The Thing', 'movie', 'DVD', 'like new', 1982,
                             json { 'price': 9.50,
                                    'comment': 'still sealed',
                                     'starring': ['Kurt Russel',
                                                    'Wilford Brimley',
                                                    'Keith David']}),
                           (102, 'Aliens', 'movie','VHS', 'unknown, cassette looks ok', 1986,
                            json { 'price': 2.50,
                                    'starring': ['Sigourney Weaver',
                                                 'Michael Bien',
                                                 'Carrie Henn'],
                                    'decade': '80s'});
commit;  
-- When you compare the rows you just inserted, you will see that they do not have the same information in the JSON column. 
-- Some have a decade information, but one record does not store this information. 
-- Your documents can vary completely with the information you are storing in your JSON column.

-- Let us now query the table and see what we have.
select * from movies;

-- We can also use the JSON_EXISTS function to check if a certain key exists in the JSON column.
select movie_id, title, JSON_EXISTS(extras, '$.decade') as decade
from movies;

select movie_id, title, year, 
   json_value(extras,'$.price.numberOnly()' returning number) as price,
   jSON_VALUE(extras, '$.price') as price_char,
   json_value(extras,'$.comment') as comments,
   json_value(extras,'$.decade') as decade_information
from movies;


-- Let's insert another movie quickly and use the extended textual representation. 
-- If you do not specify a native binary datatype, then the values will be simply converted as-is to the matching JSON datatype.
update movies set extras = json_transform(extras, 
                           set '$.released' = '1982-06-25') 
where movie_id = 101;
--
update movies set extras = json_transform(extras, 
                           set '$.released' = DATE '1986-07-18') 
where movie_id = 102;

-- Now let's query the extras column for this movie using JSON_SERIALIZE() exposing the extended datatype information
select title, json_serialize(extras extended) from movies 
where movie_id in (101,102);

select title, json_value(extras,'$.released.type()') from movies 
where movie_id in (101,102);

select title, json_value(extras,'$.released' returning date) from movies 
where movie_id in (101,102);

-- drop table
drop table movies purge;

----------------------------------------------------------------------------
-- ## JSON Collections - the native storage for JSON documents


select json_serialize(data pretty) from movies fetch first 1 rows only;

-- -------------------------------------------------------------------------
-- JSON Duality Views - JSON meets relational
-- -------------------------------------------------------------------------

drop table if exists schedule;
drop table if exists sessions;
drop table if exists attendee;
drop table if exists speaker;

create table attendee(
aid      number,
aname    varchar2(128),
extras   JSON (object),
constraint pk_attendee primary key (aid)
);

create table speaker(
sid    number,
name   varchar2(128),
email  varchar2(64),
rating number,
constraint pk_speaker primary key (sid)
);

create table sessions(
sid number,
name varchar2(128),
room varchar2(128),
speakerId number,
constraint pk_session primary key (sid),
constraint fk_session foreign key (speakerId) references speaker(sid)
);

create table schedule (
schedule_id number,
session_id  number,
attendee_id number,
constraint pk_schedule primary key (schedule_id),
constraint fk_schedule_attendee foreign key (attendee_id) references attendee(aid),
constraint fk_schedule_session foreign key (session_id) references sessions(sid)
);

-- insert data
insert into attendee(aid, aname) values(1, 'Shashank');
insert into attendee(aid, aname) values(2, 'Doug');

insert into speaker values(1, 'Bodo', 'beda@university.edu', 7);
insert into speaker values(2, 'Tirthankar','mr.t@univerity.edu', 10);

insert into sessions values (1, 'JSON and SQL', 'Room 1', 1);
insert into sessions values (2, 'PL/SQL or Javascript', 'Room 2', 1);
insert into sessions values (3, 'Oracle on IPhone', 'Room 1', 2);

insert into schedule values (1,1,1);
insert into schedule values (2,2,1);
insert into schedule values (3,2,2);
insert into schedule values (4,3,1);
commit;

-- Duality Views on top of single tables
create or replace JSON Duality view attendeeV as 
attendee @update @insert @delete{
_id   : aid,
name  : aname,
extras @flex 
};


create or replace JSON Duality view speakerV as 
speaker  @update @insert @delete {
_id       : sid,
name      : name,
rating    : rating @noupdate
};

-- Duality Views on multiple tables.
create or replace JSON Duality view ScheduleV AS
attendee 
{
_id      : aid
name       : aname
schedule   : schedule  @insert @update @delete
{
    scheduleId : schedule_id
    sessions @unnest
    {
    sessionId : sid
    name      : name
    location  : room
    speaker @unnest
    {
        speakerId : sid
        speaker   : name
    }
    } 
}
} ;

select * from attendee;
select * from attendeeV;

-- We inserted data into our relational tables before, so let's now add another attendee using the Duality View. 
insert into attendeeV values ('{"_id":3, "name":"Hermann"}');

commit;

select * from attendee;

---
select data from scheduleV;

-- extract some fields from the JSON
select v.data.name, v.data.schedule[*].speaker
from scheduleV v;

-- update bodo to beda
select data
from speakerV v
where v.data."_id" = 1;

update speakerV v
set data = '{"_id":1,"name":"Beda","rating":7}'
where v.data."_id" = 1;

commit;

-- Let's check quickly whether we did it right:
select data
from speakerV v
where v.data."_id" = 1;

select v.data.name, v.data.schedule[*].speaker
from scheduleV v;

-- check rights
update speakerV v
set data = '{"_id":1,"name":"Beda","rating":11}'
where v.data."_id" = 1;

-- Experience schema flexibility
update attendeeV v
set v.data = '{"_id":3, "name":"Hermann", "lastName":"B"}'
where v.data."_id" = 3;

select v.data
from attendeeV v
where v.data."_id" = 3;

select * from attendee;

-- We can use generated fields to add additional data that is derived from other information in our Duality View. (Generated fields are ignored when updating data.)
create or replace JSON Duality view speakerV as 
speaker @update @insert @delete {
_id         : sid,
name        : name,
rating      : rating @noupdate,
sessions    : sessions {
    sessionId   : sid,
    sessionName : name
},
numSessions @generated (path : "$.sessions.size()")
};

-- We did not have touched any data on disk, but only changed the metadata of your Duality View.
select json_serialize(data pretty) from speakerV;


-- etag
select json_serialize(data pretty) 
from attendeeV v
where v.data."_id" = 2;


update ATTENDEE
set aname = 'Douglas'
where aid = 2;


update attendeeV v
set data = '{
        "_id" : 2,
        "_metadata" :
        {
            "etag" : "FC21A1C86EADA0B73424701D0302B982",
            "asof" : "000000004B1CC2FC"
        },
        "name" : "Doug",
        "job" : "Product Manager"
        }'
where v.data."_id" = 2;
