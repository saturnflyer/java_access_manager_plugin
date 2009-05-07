class Person
  attr_accessor :username, :first_name, :last_name
  
  def initialize(params = {})
    @username = params[:username]
    @first_name = params[:first_name]
    @last_name = params[:last_name]
  end
  
  def self.find_by_username(username)
    return Person.new(:username => username, :first_name => "First", :last_name => "Name")
  end
end