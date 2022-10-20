# frozen_string_literal: true

require "sequel"

module RightsDatabase
  class << self
    # Call #db if connecting with ENV["RIGHTS_DATABASE_CONNECTION_STRING"] and
    # need no further customization. This is the method the other RightsDatabase
    # classes to get access to the database connection.
    # Call #connect as a one-time initialization if you need more control.
    def db
      @db ||= DB.new.connect!
      @db.connection
    end

    def connect(connection_string = nil, **kwargs)
      @db = DB.new.connect!(connection_string, **kwargs)
      @db.connection
    end
  end

  class DB
    attr_reader :connection

    def connect!(connection_string = nil, **kwargs)
      @connection = self.class.connection(connection_string, **kwargs)
      self
    end

    # #connection will take
    #  * a full connection string (passed here OR in the environment
    #    variable RIGHTS_DATABASE_CONNECTION_STRING)
    #  * a set of named arguments, drawn from those passed in and the
    #    environment. Arguments are those supported by Sequel.
    #
    # Environment variables are mapped as follows:
    #
    #   user: RIGHTS_DATABASE_USER
    #   password: RIGHTS_DATABASE_PASSWORD
    #   host: RIGHTS_DATABASE_HOST
    #   port: RIGHTS_DATABASE_PORT
    #   database: RIGHTS_DATABASE_DATABASE
    #   adapter: RIGHTS_DATABASE_ADAPTER
    def self.connection(connection_string = nil, **kwargs)
      connection_string ||= ENV["RIGHTS_DATABASE_CONNECTION_STRING"]
      if connection_string.nil?
        db_args = gather_db_args(**kwargs)
        Sequel.connect(**db_args)
      else
        Sequel.connect(connection_string)
      end
    end

    class << self
      private

      def gather_db_args(**args)
        %i[user password host port database adapter].each do |db_arg|
          args[db_arg] ||= ENV["RIGHTS_DATABASE_#{db_arg.to_s.upcase}"]
        end

        args[:host] ||= "localhost"
        args[:adapter] ||= :mysql2
        args[:database] ||= "ht"
        args
      end
    end
  end
end
