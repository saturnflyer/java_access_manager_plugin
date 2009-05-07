require 'test/unit'

##
## Required to be able to run rake test:plugins
##
require "#{File.dirname(__FILE__)}/person"
require "#{File.dirname(__FILE__)}/../lib/java_access_manager"

unless global_variables.include?("RAILS_ROOT")
  RAILS_ROOT = "#{File.dirname(__FILE__)}/../../../../"
  RAILS_ENV = 'test'
end

class NilClass
  def blank?
    return true
  end
end

class Hash
  def blank?
    return self.size == 0
  end
end

class String
  def blank?
    return self.strip.size == 0
  end
end

##
## End test support
##

class Foo 
  include SaturnFlyer::JavaAccessManager
  java_access_manager
  
  def initialize
    configure_user({})
  end
  
  def get_username
    return access_manager_user.username
  end
  
  def get_group_list
    return access_manager_groups
  end
  
  def get_role_list
    return access_manager_roles
  end
end

class JavaAccessManagerTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_this_plugin
    f = Foo.new
    
    assert(f.get_username == "testuser", "Expected 'testuser' but got #{f.get_username}")
    
    [:membership].each do | some_group |
      assert(f.get_group_list.include?(some_group), "Expected group list to contain #{some_group}")
    end
    
    [:staff, :admin, :users].each do | some_role |
      assert(f.get_role_list.include?(some_role), "Expected group list to contain #{some_role}")
    end
  end
end
