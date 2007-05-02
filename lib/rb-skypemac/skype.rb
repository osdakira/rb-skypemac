require 'rubygems'
require 'appscript'
include Appscript

module SkypeMac  

  # Singleton for interfacing with Skype
	class Skype
	  @@groups = nil

    # The Appscript interface to Skype.  Requires a Hash containing:
    # (1) <i>:command</i> - the Skype API command to pass,
    # (2) <i>:script_name</i> - unknown all though an empty String makes Skype happy.
    # Impl adds <i>:script_name</i> to Hash and warns if it is not provided
    def Skype.send_(params)
      params[:script_name] = "" if not params.has_key? :script_name 
      app('Skype').send_ params
    end

    # Initiates a Skype call
	  def Skype.call(*person)
      user_handles = person.collect { |u| user_str << ((u.is_a? User) ? u.handle : u) }
      status = Skype.send_ :command => "call #{user_handles.join(', ')}"
      if status =~ /CALL (\d+) STATUS/: Call.new($1)
      else raise RuntimeError.new("Call failed.  Skype returned '#{status}'")
      end        
    end

    # Returns an Array of call IDs if there is an incoming Skype call otherwise nil
    def Skype.incoming_calls
      Call.incoming_calls
    end
    
    # Answers a call given a skype call ID.  Returns an Array of Call objects.
    def Skype.answer_calls(*id)
      ids.collect { |id| Call.new id }
    end
    
    # Returns an Array of Group
    def Skype.groups
      @@groups = Group.groups if not @@groups
      @@groups
    end
    
    # Returns Array of all users in Group.  Accepts types as defined by Group.types
    def Skype.find_users_of_type(group_type)
      Skype.groups.find { |g| g.gtype == group_type}.users
    end

    # Returns an array of users online friends as User objects
    def Skype.online_friends
      Skype.find_users_of_type "ONLINE_FRIENDS"
    end
    
    # Array of all Users that are friends of the current user
    def Skype.all_friends
      Skype.find_users_of_type "ALL_FRIENDS"
    end
    
    # Array of all Users defined as Skype Out users
    def Skype.skypeout_friends
      Skype.find_users_of_type "SKYPEOUT_FRIENDS"
    end
    
    # Array of all Users that the user knows
    def Skype.all_users
      Skype.find_users_of_type "ALL_USERS"
    end
    
    # Array of Users recently contacted by the user, friends or not
    def Skype.recently_contacted_users
      Skype.find_users_of_type "RECENTLY_CONTACTED_USERS"
    end
    
    # Array of Users waiting for authorization
    def Skype.users_waiting_for_authorization
      Skype.find_users_of_type "USERS_WAITING_MY_AUTHORIZATION"
    end
    
    # Array of Users blocked
    def Skype.blocked_users
      Skype.find_users_of_type "USERS_BLOCKED_BY_ME"
    end
  end
end