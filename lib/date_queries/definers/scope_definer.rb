module DateQueries
  module ScopeDefiner
    def self.define_scopes_for(field, klass)
      define_scopes_without_arguments(field, klass)
      define_scopes_with_arguments(field, klass)
    end

    def self.define_birthday_scopes_for(field, klass)
      define_scopes_without_arguments(field, klass)
      klass.send('scope', :"#{field.to_s.pluralize}_passed", klass.class_eval(
        <<-LAMBDA
          lambda {
            where ::DateQueries::Adapter.adapter_for(self.connection).condition_string_for_range(
              field,
              DateTime.new(Date.today.year, 1, 1),
              DateTime.now - 1.day,
              :year
            )
          }
        LAMBDA
      ))

      klass.send('scope', :"#{field.to_s.pluralize}_in_future", klass.class_eval(
        <<-LAMBDA
          lambda {
            where ::DateQueries::Adapter.adapter_for(self.connection).condition_string_for_range(
              field,
              DateTime.now,
              DateTime.new(Date.today.year, 12, 31),
              :year
            )
          }
        LAMBDA
      ))

      klass.send('scope', :"#{field.to_s.pluralize}_in", klass.class_eval(
        <<-PROC
          lambda {|start_date, end_date|
            where ::DateQueries::Adapter.adapter_for(self.connection).condition_string_for_range(
              field,
              start_date,
              end_date,
              :year
            )
          }
        PROC
      ))
    end

    def self.define_scopes_without_arguments(field, klass)
      # #{field}_in_this_year
      klass.send('scope', :"#{field.to_s.pluralize}_in_this_year", klass.class_eval(
        <<-LAMBDA
          lambda {
            where ::DateQueries::Adapter.adapter_for(self.connection).condition_string_for_current_time(
              field,
              Date.today,
              :date, :month
            )
          }
        LAMBDA
      ))

      # #{field}_in_this_month
      klass.send('scope', :"#{field.to_s.pluralize}_in_this_month", klass.class_eval(
        <<-LAMBDA
          lambda {
            where ::DateQueries::Adapter.adapter_for(self.connection).condition_string_for_current_time(
              field,
              Date.today,
              :date, :year
            )
          }
        LAMBDA
      ))

      # #{field}_is_today
      klass.send('scope', :"#{field.to_s}_is_today", klass.class_eval(
        <<-LAMBDA
          lambda {
            where ::DateQueries::Adapter.adapter_for(self.connection).condition_string_for_current_time(
              field,
              Date.today
            )
          }
        LAMBDA
      ))
    end

    def self.define_scopes_with_arguments(field, klass)

      # #{field}_before(dateTime)
      klass.send('scope', :"#{field.to_s.pluralize}_after", klass.class_eval(
        <<-LAMBDA
          lambda {|end_date|
            where("#{field} < ?", end_date)
          }
        LAMBDA
      ))

      # #{field}_after(dateTime)
      klass.send('scope', :"#{field.to_s.pluralize}_after", klass.class_eval(
        <<-LAMBDA
          lambda {|start_date|
            where("#{field} > ?", start_date)
          }
        LAMBDA
      ))

      # #{field}_in_range(start_date, end_date, *skip_args)
      klass.send('scope', :"#{field.to_s.pluralize}_in_range", klass.class_eval(
        <<-PROC
          proc { |start_date, end_date, *skip_args|
            # creating the scope like
            raise ArgumentError, 'Provide at-least one date.' unless start_date.present?
            raise ArgumentError, 'Invalid arguments in dates, end date is not greater than start date.' if end_date.present? and end_date < start_date
            raise ArgumentError, "can not skip all date, month and year" if ([:year, :month, :date] - skip_args).blank?

            if end_date
              if skip_args.blank?
                # condition without skipping parameters
                where("#{field} BETWEEN :start_date AND :end_date", :start_date => start_date, :end_date => end_date)
              else
                # conditions with skipped parameters
                where ::DateQueries::Adapter.adapter_for(self.connection).condition_string_for_range(field, start_date, end_date, *skip_args)
              end
            else
              # conditions with single date
              where("#{field} = ?", start_date)
            end
          }
        PROC
      )
    )
    end
  end
end
