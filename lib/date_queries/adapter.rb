module DateQueries
  module Adapter
    autoload :MysqlAdapter, 'date_queries/adapters/mysql_adapter'
    autoload :Mysql2Adapter, 'date_queries/adapters/mysql2_adapter'
    autoload :PostgreSQLAdapter, 'date_queries/adapters/postgresql_adapter'
    autoload :OracleEnhancedAdapter, 'date_queries/adapters/oracle_enanced_adapter'
    autoload :SQLite3Adapter, 'date_queries/adapters/sqlite3_adapter'

    def self.adapter_for(connection)
      "DateQueries::Adapter::#{connection.class.name.demodulize}".constantize
    end
  end
end
