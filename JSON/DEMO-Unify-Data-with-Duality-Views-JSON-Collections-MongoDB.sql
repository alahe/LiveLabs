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
--
-- -----------------------------------------------------------------------------
-- Lab2. Schema flexibility for relational tables with the JSON datatype
-- -----------------------------------------------------------------------------
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

 -- Depending on the SQL client you are using, you might not get a textual representation of the JSON column EXTRAS back. 
 -- Ultimately, this information is stored in a binary format on disk. 
 -- If your SQL client happens to return gibberish or something like '[BLOB]', 
 -- use the following SQL command to serialize the JSON information into a textual representation

select movie_id, title, type, format, condition, year, 
        json_serialize(extras) as extras
from movies;

-- We can also use the JSON_EXISTS function to check if a certain key exists in the JSON column.
select movie_id, title, JSON_EXISTS(extras, '$.decade') as decade
from movies;

-- Now let's use the ANSI standard SQL/JSON operator JSON_VALUE() to extract the common JSON attributes of interest. 
-- You will see that the result set is completely relational.
select movie_id, title, year, 
   json_value(extras,'$.price.numberOnly()' returning number) as price,
   jSON_VALUE(extras, '$.price') as price_char,
   json_value(extras,'$.comment') as comments,
   json_value(extras,'$.decade') as decade_information
from movies;

-- Native binary JSON data (OSON format) extends the JSON language by adding scalar types, such as date, 
-- that correspond to SQL types and are not part of the JSON standard. 
-- Oracle Database also supports the use of textual JSON objects that represent JSON scalar values, including such nonstandard values.

-- When you create native binary JSON data from textual JSON data that contains such extended objects, 
-- they can optionally be replaced with corresponding (native binary) JSON scalar values.

-- Let's insert another movie quickly and use the extended textual representation. 
-- If you do not specify a native binary datatype, then the values will be simply converted as-is to the matching JSON datatype.

update movies set extras = json_transform(extras, 
                           set '$.released' = '19826-6-25') 
where movie_id = 101;
--
update movies set extras = json_transform(extras, 
                           set '$.released' = DATE '1986-07-18') 
where movie_id = 102;

--
commit;

-- Now let's query the extras column for this movie using JSON_SERIALIZE() exposing the extended datatype information
select title, json_serialize(extras extended) from movies 
where movie_id in (101,102);

select title, json_value(extras,'$.released.type()') from movies 
where movie_id in (101,102);

-- Now what does this mean? Does this render the date for the movie 
-- *The Thing unusable as date? No, it does not. Just specify the return type of the SQL/JSON operator, 
-- and you are back in business (assuming that the conversion is successful, 
-- otherwise the default behavior of RETURN NULL ON ERROR will kick in).
select title, json_value(extras,'$.released' returning date) from movies 
where movie_id in (101,102);

-- drop table
drop table movies purge;

----------------------------------------------------------------------------
-- ## Lab 3 - JSON Collections - the native storage for JSON documents
-- 
----------------------------------------------------------------------------

select json_serialize(data pretty) from movies fetch first 1 rows only;

-- -------------------------------------------------------------------------
-- ## Lab 4 - JSON Duality Views - JSON meets relational

-- ### Key benefits of JSON Relational Duality:

-- 1. Experience flexibility in building apps using Duality Views. 
-- You can access the same data relationally or as hierarchical documents based on your use case, 
-- and you're not forced into making compromises because of the limitations of the underlying database. 
-- Build document-centric apps on relational data or create SQL apps on documents.

-- 2. Experience simplicity by retrieving and storing all the data needed for an app in a single database operation. 
-- Duality Views provide fully updatable JSON views over data. 
-- Apps can read a document, make necessary changes, 
-- and write the document back without worrying about the underlying data structure, mapping, or consistency.

-- 3. Enable flexibility and simplicity in building multiple apps on the same set of data. 
-- You can use the power of Duality View to define multiple JSON Views across overlapping groups of tables. 
-- This flexible data modeling makes building multiple apps against the same data easy and efficient.

-- 4. Duality Views eliminate the inherent problem of data duplication and data inconsistency in document databases. 
-- Duality Views are fully ACID (atomicity, consistency, isolation, durability) transactions across multiple documents and tables. 
-- They eliminate data duplication across documents, whereas consistency is maintained automatically.

-- -------------------------------------------------------------------------

drop table if exists schedule;
drop table if exists sessions;
drop table if exists attendee;
drop table if exists speaker;

create table if not exists attendee(
aid      number,
aname    varchar2(128),
extras   JSON (object),
constraint pk_attendee primary key (aid)
);

create table if not exists speaker(
sid    number,
name   varchar2(128),
email  varchar2(64),
rating number,
constraint pk_speaker primary key (sid)
);

create table if not exists sessions(
sid number,
name varchar2(128),
room varchar2(128),
speakerId number,
constraint pk_session primary key (sid),
constraint fk_session foreign key (speakerId) references speaker(sid)
);

create table if not exists schedule (
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

-- ### Task 2: Create your JSON Relational Duality View
-- Duality Views on top of single tables. After we have seen the relational world, let's switch to Duality Views (DVs). 
-- Using Duality Views, data is still stored in relational tables in a highly efficient normalized format 
-- but is accessed by apps in the form of JSON documents.The documents you create (the Duality Views), 
-- are not directly tied to the storage of the data.

-- What does that mean?
-- 
-- Using Duality Views, you can define how the data is accessed and used. 
-- Duality Views allow you to specify @insert, @update, and @delete privileges, 
-- meaning you define exactly how the applications and/or the developers work with data.
-- 
-- Let's create a couple of Duality Views for our conference schedule system. 
-- We are starting with the most simple form, a JSON document representation of a single relational table. 
-- We do this for the attendees and the speakers.
-- Duality Views on top of single tables

create or replace JSON Duality view attendeeV as 
attendee @update @insert @delete{
_id   : aid,
name  : aname,
extras @flex 
};

select * from attendee;
select * from attendeeV;

---- 
create or replace JSON Duality view speakerV as 
speaker  @update @insert @delete {
_id       : sid,
name      : name,
rating    : rating @noupdate
};

select * from speaker;
select * from speakerV;

-- As you can see, these DVs are a 1:1 representation of your relational tables. 
-- Using these DVs, you can see all the data represented in the relational tables, 
-- but we introduced the first set of flexibility and benefits of DVs. Those are namely

-- Full schema flexibility: The Duality View attendeesV as a so-called flex field extras, 
-- the catch-all for any yet unknown attribute.
-- Partial data visibility: You do not have to expose all the information in the underlying tables. 
-- In this case we do not expose the email information in the speaker DV.
-- Fine-grained attribute (data) control: The Duality View speakerV does not allow the update of the rating of a speaker, 
-- identified through the explicit @noupdate clause on the attribute level.

-- We inserted data into our relational tables before, so let's now add another attendee using the Duality View. 
insert into attendeeV values ('{"_id":3, "name":"Hermann"}');

commit;

select * from attendee;

----------------------------------------------------------------------------
-- 2. Duality Views on multiple tables. 
-- Application objects are commonly more complex than simple relational tables, 
-- meaning those are spawning multiple tables when being used within an application. 
-- Let's now do exactly that for the document (Duality View) representation of the schedules.

-- A schedule object comprises of:

-- the attendee information
-- the schedule for an individual attendee
-- the schedule represents one and more sessions an attendee is planning to go to
-- the detail information about a session, incl. the speaker information
--
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


---
select data from scheduleV;

-- extract some fields from the JSON
select v.data.name, v.data.schedule[*].speaker as speakers
from scheduleV v;

-- select speaker
select data
from speakerV v
where v.data."_id" = 1;

-- update bodo to beda
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

-- You just experienced another major benefit of JSON Duality Views. 
-- Unlike JSON Collections that embed all the information of an object within a single document, 
-- causing data duplication, Duality Views benefit from the underlying relational storage: the information about a speaker is stored once 
-- and any change is automatically changed for all related documents.
---
select v.data
from attendeeV v
where v.data."_id" = 3;

-- Update attendee
update attendeeV v
set v.data = '{"_id":3, "name":"Hermann", "lastName":"B"}'
where v.data."_id" = 3;

select v.data
from attendeeV v
where v.data."_id" = 3;

select * from attendee;

-- We can use generated fields to add additional data that is derived from other information in our Duality View. 
-- (Generated fields are ignored when updating data.)
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
            "etag" : "3766C778EFC12397D65927C1F639E64A",
            "asof" : "000000004B1CC2FC"
        },
        "name" : "Doug",
        "job" : "Product Manager"
        }'
where v.data."_id" = 2;

commit;


select json_serialize(data pretty) from attendeeV;


select json_serialize(data pretty) from speakerV;