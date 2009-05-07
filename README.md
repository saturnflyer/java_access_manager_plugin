JavaAccessManager
=================

Introduction goes here.


Configuration File
==================

development:
  use_authority: "stubbed"
  stubbed_user:
    user_id: "phoehne"
    roles: "cn=admn,dc=foo,dc=com|cn=staff,dc=foo,dc=com|cn=users,dc=foo,dc=com"
    groups: "cn=membership,dc=foo,dc=com"
    
test:
  use_authority: "stubbed"
  stubbed_user:
    user_id: "username"
    roles: "cn=admin,dc=foo,dc=com|cn=staff,dc=foo,dc=com|cn=users,dc=foo,dc=com"
    groups: "cn=membership,dc=foo,dc=com"

production:
  use_authority: "headers"
  
Example
=======

Example goes here.


Copyright (c) 2008 Saturn Flyer, LLC, released under the MIT license
