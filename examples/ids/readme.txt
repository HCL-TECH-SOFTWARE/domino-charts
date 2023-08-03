If you want to use existing Notes ID files during the Domino server setup, do this:
  - put files into this folder
  - update settings in your Values config file:
      - set "true" in the "use existing ID" switch
      - specify the file name of the ID file
      - specify the ID password, if used for the ID file

Notes ID files that you can use:
  - Organization ID (cert.id)
  - Server ID (server.id)
  - Administrator ID (admin.id)

Of course, ID files much match the parameters specified in a config file (Server name, Admin Name, Organization name).