JavaAccessManager
=================

This is a utility plugin to help you integrate your application with authentication
as provided by Sun's Java Access Manager.  Note that you may or may not be able to use
this plugin without modification, depending on your JAM setup, especially the attributes
you wish to retrieve and their prefix as defined in the agent configuration.


Configuration File
==================

<pre>
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

</pre>

Example
=======

Inside of your <code>application_controller.rb</code> file, you might include something like the
following:

<pre>
java_access_manager

before_filter :get_current_user

private

def get_current_user
  configure_user({})
  @user = access_manager_user
  @groups = access_manager_groups
  @roles = access_manager_roles
end
</pre>

You may need to adjust the following lines of code in "vendor/plugins/java\_access\_manager/lib/java\_access\_manager.rb"
to do the "right thing" from you application's perspective:

<pre>
def get_user_information
  the_person = nil
  user_id = ""
  role_string = ""
  
  if access_manager_environment["use_authority"] == "stubbed"
    user_id = access_manager_environment["stubbed_user"]["user_id"]
  else
    user_id = request.env["HTTP_USER_ID"]
  end

  unless user_id.blank? or user_id == "anonymous"
    the_person = Person.find_by_username(user_id)
  else
    the_person = Person.new(:username => 'anonymous', :first_name => 'anonymous', :last_name => 'user')
  end
  return the_person
end
</pre>


Copyright (c) 2008 Saturn Flyer, LLC, released under the MIT license
