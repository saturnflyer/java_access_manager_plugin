# Include hook code here
require 'java_access_manager'

ActionController::Base.send(:include, SaturnFlyer::JavaAccessManager)
ActionController::Base.send(:java_access_manager)