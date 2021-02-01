require "date_queries/version"

module DateQueries

  autoload :ScopeDefiner, 'date_queries/definers/scope_definer'
  autoload :Adapter, 'date_queries/adapter'

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def date_queries_for(*query_fields)

      # setting the scope types according to ActiveRecord version
      query_fields.each do |field|
        raise ArgumentError, "Column '#{field}' does not exist in '#{self.name}' model." unless self.column_names.include?(field.to_s)
        ScopeDefiner.define_scopes_for(field, self)
      end
    end

    def acts_as_birthday(*fields)
      # fields to be treated as birthdays
      fields.each do |field|
        raise ArgumentError, "Column '#{field}' does not exist in '#{self.name}' model." unless self.column_names.include?(field.to_s)
        ScopeDefiner.define_birthday_scopes_for(field, self)

        class_eval %{
          def #{field}_age
            return nil unless self.#{field}?
            today = Date.today.in_time_zone
            age = today.year - #{field}.year
            age -= 1 if today.month < #{field}.month || (today.month == #{field}.month && today.mday < #{field}.mday)
            age
          end

          def #{field}_today?
            return nil unless self.#{field}?
            Date.today.strftime('%m%d') == #{field}.strftime('%m%d')
          end
        }
      end
    end

  end

end

ActiveRecord::Base.send :include, DateQueries
