# Include hook code here
require 'java_access_manager'
require 'header_authorization'
HeaderAuthorization.send(:include, SaturnFlyer::JavaAccessManager)
HeaderAuthorization.send(:java_access_manager)