#!/bin/bash
sqlite3 ~/Dropbox/CivicHack/Water/cso-data.db <<!
.headers on
.mode csv
.output out.csv
select * from CSOs;
!