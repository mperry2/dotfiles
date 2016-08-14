-- ~/login.sql - sql*plus init file
--
-- $Id: login.sql,v 1.2 2005/06/29 17:35:15 matt Exp $
--
-- NAME
--   login.sql
--
-- DESCRIPTION
--   SQL*Plus local login profile file
--
--   Add any SQL*Plus commands here that are to be executed when a
--   user starts SQL*Plus, or uses the SQL*Plus CONNECT command.
--
-- SEE ALSO
--   See http://www.ss64.com/orasyntax/plus_set.html for settings.
--

set termout off

alter session set NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:mi:ss';


-- SET the SQLPROMPT to include the _USER, _CONNECT_IDENTIFIER
-- and _DATE variables.
--set sqlprompt "_USER'@'_CONNECT_IDENTIFIER _DATE> "
--set sqlprompt "_DATE _USER'@'_CONNECT_IDENTIFIER> "

set trimspool on
set trimout on



set termout on






-- -- Do not display commands as they are executed
-- set echo off
--
-- -- The number of blank lines between the top of each page and the top title.
-- set newpage 1
--
-- -- The number of spaces between columns in output (1-10). Default is 1.
-- -- set space 0
--
-- -- The height of the page - number of lines. Default is 14.
-- -- 0 will suppress all headings, page breaks, titles. I set this to a huge
-- -- number because I still would like to see the column headings.
-- set pagesize 50000
--
-- set wrap off
-- set linesize 5000
--
-- set trimspool on
--
-- -- set feedback off
-- -- set heading off
--
-- --define _editor=vim
