require 'yaml'
require 'pp'
# JavaAccessManager
module SaturnFlyer
  module JavaAccessManager
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def java_access_manager
        if File.exist?("#{RAILS_ROOT}/config/authentication.yml") 
          File.open("#{RAILS_ROOT}/config/authentication.yml", "r") do | f |
            configuration = YAML.load f.read
          end
        end
        include SaturnFlyer::JavaAccessManager::InstanceMethods
        extend SaturnFlyer::JavaAccessManager::SingletonMethods
      end
    end
    
    module InstanceMethods
      def configure_user(parameters = {})
        @access_manager_user      = get_user_information
        @access_manager_roles     = get_role_information
        @access_manager_groups    = get_group_information
      end
      
      def access_manager_user 
        return @access_manager_user
      end
      
      def access_manager_roles
        return @access_manager_roles
      end

      def access_manager_groups
        return @access_manager_groups
      end

      def load_config_data
        if @configuration.blank?
          fname = "#{RAILS_ROOT}/config/authentication.yml"
          if File.exist?(fname)
            File.open(fname, "r") do | f |
              @configuration = YAML.load f.read
            end
          else
            @configuration = {}
          end
        end
      end
      
      def access_manager_environment=(env)
        @configuration = env
      end
      
      def access_manager_environment
        load_config_data
        return @configuration[RAILS_ENV] || {"use_athority" => "headers"}
      end
      
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
      
      def get_role_information
        roles = ""
        
        if access_manager_environment["use_authority"] == "stubbed"
          roles = access_manager_environment["stubbed_user"]["roles"]
        else
          roles = request.env["HTTP_ROLES"]
        end
        
        result = []
        unless roles.blank?
          roles = roles.split("|")
          roles.each do | role_text |
            unless role_text.blank?
              split_role = role_text.split(",")
              result << split_role[0].split("=")[1].to_sym
            end
          end
        end
        return result
      end
    end

    def get_group_information
      groups = ""

      if access_manager_environment["use_authority"] == "stubbed" 
        groups = access_manager_environment["stubbed_user"]["groups"]
      else
        groups = request.env["HTTP_GROUPS"]
      end

      result = []
      unless groups.blank?
        groups = groups.split("|")
        groups.each do | group_text |
          unless group_text.blank?
            split_group = group_text.split(",")
            result << split_group[0].split("=")[1].downcase.to_sym
          end
        end
      end

      return result
    end
    
    module SingletonMethods
      
    end
  end
end
