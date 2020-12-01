module DateQueries
  module Adapter
    class PostgreSQLAdapter

      def self.condition_string_for_range(field, start_date, end_date, *skip_args)
        # PostgreSql related conditions string with skipped arguments

        if skip_args.present?
          if skip_args.include?(:year)
            if skip_args.include?(:month)
              # condition with month and year skipped
              if start_date.strftime('%d') > end_date.strftime('%d')
                <<-QUERY
                  (to_char(\"#{field}\", 'DD') BETWEEN '#{start_date.in_time_zone.strftime('%d')}' AND '31')
                  OR (to_char(\"#{field}\", 'DD') BETWEEN '01' AND '#{end_date.in_time_zone.strftime('%d')}')
                QUERY
              else
                <<-QUERY
                  to_char(\"#{field}\", 'DD') BETWEEN
                    '#{start_date.in_time_zone.strftime('%d')}' AND '#{end_date.in_time_zone.strftime('%d')}'
                QUERY
              end
            elsif skip_args.include?(:date)
              # condition with year and date skipped
              if start_date.strftime('%m') > end_date.strftime('%m')
                <<-QUERY
                  (to_char(\"#{field}\", 'MM') BETWEEN '#{start_date.in_time_zone.strftime('%m')}' AND '12')
                  OR (to_char(\"#{field}\", 'MM') BETWEEN '01' AND '#{end_date.in_time_zone.strftime('%m')}')
                QUERY
              else
                <<-QUERY
                  to_char(\"#{field}\", 'MM') BETWEEN
                    '#{start_date.in_time_zone.strftime('%m')}' AND '#{end_date.in_time_zone.strftime('%m')}'
                QUERY
              end
            else
              # condition with only year skipped
              if start_date.strftime('%m%d') > end_date.strftime('%m%d')
                <<-QUERY
                  (to_char(\"#{field}\", 'MMDD') BETWEEN '#{start_date.in_time_zone.strftime('%m%d')}' AND '1231')
                  OR (to_char(\"#{field}\", 'MMDD') BETWEEN '0101' AND '#{end_date.in_time_zone.strftime('%m%d')}')
                QUERY
              else
                <<-QUERY
                  to_char(\"#{field}\", 'MMDD') BETWEEN
                    '#{start_date.in_time_zone.strftime('%m%d')}' AND '#{end_date.in_time_zone.strftime('%m%d')}'
                QUERY
              end
            end
          elsif skip_args.include?(:month)
            if skip_args.include?(:date)
              # condition with month and date skipped
              <<-QUERY
                to_char(\"#{field}\", 'YYYY') BETWEEN
                  '#{start_date.in_time_zone.strftime('%Y')}' AND '#{end_date.in_time_zone.strftime('%Y')}'
              QUERY
            else
              # condition with only month skipped
              <<-QUERY
                to_char(\"#{field}\", 'YYYYDD') BETWEEN
                  '#{start_date.in_time_zone.strftime('%Y%d')}' AND '#{end_date.in_time_zone.strftime('%Y%d')}'
              QUERY
            end
          elsif skip_args.include?(:date)
            # condition with only date skipped
            <<-QUERY
              to_char(\"#{field}\", 'YYYYMM') BETWEEN
                '#{start_date.in_time_zone.strftime('%Y%m')}' AND '#{end_date.in_time_zone.strftime('%Y%m')}'
            QUERY
          end
        end
      end

      def self.condition_string_for_current_time(field, date, *skip_args)

        if skip_args.include?(:year)
          if skip_args.include?(:month)
            # condition for date only
            <<-QUERY
              to_char(\"#{field}\", 'DD') = '#{date.in_time_zone.strftime('%d')}'
            QUERY
          elsif skip_args.include?(:date)
            # condition for month only
            <<-QUERY
              to_char(\"#{field}\", 'MM') = '#{date.in_time_zone.strftime('%m')}'
            QUERY
          else
            # condition for month and day only
            <<-QUERY
              to_char(\"#{field}\", 'MMDD') = '#{date.in_time_zone.strftime('%m%d')}'
            QUERY
          end
        elsif skip_args.include?(:month)
          if skip_args.include?(:date)
            # condition for year only
            <<-QUERY
              to_char(\"#{field}\", 'YYYY') = '#{date.in_time_zone.strftime('%Y')}'
            QUERY
          else
            # condition for year and date only
            <<-QUERY
              to_char(\"#{field}\", 'YYYYDD') = '#{date.in_time_zone.strftime('%Y%d')}'
            QUERY
          end
        elsif skip_args.include?(:date)
          # condition for month and year only.
          <<-QUERY
            to_char(\"#{field}\", 'YYYYMM') = '#{date.in_time_zone.strftime('%Y%m')}'
          QUERY
        else
          # condition for checking current date without time
          <<-QUERY
            to_char(\"#{field}\", 'YYYYMMDD') = '#{date.in_time_zone.strftime('%Y%m%d')}'
          QUERY
        end

      end

    end
  end
end
