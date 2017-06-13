Parse JSON Status 
==========================

This parser includes:
--------------------------

- Ruby (ActiveRecord) Models for storing OLSR status-data in a MySQL / MariaDB and querying.
- A JSON-Parser for extracting status information from OLSR-Status Plugins

Configuration 
-------------------------

- model.rb for the database connection
- Filename / Nodename convetions

Assumptions
-------------------------------------------------

- For each measurement / timestamp there is a subdirectory (prefix: 146 --- Unix Timestamps theses days) containing the files
- Each node writes to a different file (gizmo-01-status.json ... gizmo-06-status.json)

These names can be configured in JsonLoad.rb
