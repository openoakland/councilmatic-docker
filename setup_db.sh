createdb template_postgis
createdb opencivicdata
psql -d template_postgis -f /usr/share/postgresql/9.6/contrib/postgis-2.4/postgis.sql
psql -d template_postgis -f /usr/share/postgresql/9.6/contrib/postgis-2.4/spatial_ref_sys.sql
pupa dbinit us
