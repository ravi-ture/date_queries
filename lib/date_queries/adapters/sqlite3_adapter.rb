module DateQueries
  module Adapter
    class SQLite3Adapter

      def self.condition_string_for_range(field, start_date, end_date, *skip_args)
        # SQLite3Adapter related conditions string with skipped arguments

        if skip_args.present?
          if skip_args.include?(:year)
            if skip_args.include?(:month)
              # condition with month and year skipped
              if start_date.strftime('%d') > end_date.strftime('%d')
                <<-QUERY
                  (strftime('%d', #{field}) BETWEEN '#{start_date.in_time_zone.strftime('%d')}' AND '31')
                  OR (strftime('%d', #{field}) BETWEEN '01' AND '#{end_date.in_time_zone.strftime('%d')}')
                QUERY
              else
                <<-QUERY
                  strftime('%d', #{field}) BETWEEN
                    '#{start_date.in_time_zone.strftime('%d')}' AND '#{end_date.in_time_zone.strftime('%d')}'
                QUERY
              end
            elsif skip_args.include?(:date)
              # condition with year and date skipped
              if start_date.strftime('%m') > end_date.strftime('%m')
                <<-QUERY
                  (strftime('%m', #{field}) BETWEEN '#{start_date.in_time_zone.strftime('%m')}' AND '12')
                  OR (strftime('%m', #{field}) BETWEEN '01' AND '#{end_date.in_time_zone.strftime('%m')}')
                QUERY
              else
                <<-QUERY
                  strftime('%m', #{field}) BETWEEN
                    '#{start_date.in_time_zone.strftime('%m')}' AND '#{end_date.in_time_zone.strftime('%m')}'
                QUERY
              end
            else
              # condition with only year skipped
              if start_date.strftime('%m%d') > end_date.strftime('%m%d')
                <<-QUERY
                  (strftime('%m%d', #{field}) BETWEEN '#{start_date.in_time_zone.strftime('%m%d')}' AND '1231')
                  OR (strftime('%m%d', #{field}) BETWEEN '0101' AND '#{end_date.in_time_zone.strftime('%m%d')}')
                QUERY
              else
                <<-QUERY
                  strftime('%m%d', #{field}) BETWEEN
                    '#{start_date.in_time_zone.strftime('%m%d')}' AND '#{end_date.in_time_zone.strftime('%m%d')}'
                QUERY
              end
            end
          elsif skip_args.include?(:month)
            if skip_args.include?(:date)
              # condition with month and date skipped
              <<-QUERY
                strftime('%Y', #{field}) BETWEEN
                  '#{start_date.in_time_zone.strftime('%Y')}' AND '#{end_date.in_time_zone.strftime('%Y')}'
              QUERY
            else
              # condition with only month skipped
              <<-QUERY
                strftime('%Y%d', #{field}) BETWEEN
                  '#{start_date.in_time_zone.strftime('%Y%d')}' AND '#{end_date.in_time_zone.strftime('%Y%d')}'
              QUERY
            end
          elsif skip_args.include?(:date)
            # condition with only date skipped
            <<-QUERY
              strftime('%Y%m', #{field}) BETWEEN
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
              strftime('%d', #{field}) = '#{date.in_time_zone.strftime('%d')}'
            QUERY
          elsif skip_args.include?(:date)
            # condition for month only
            <<-QUERY
              strftime('%m', #{field}) = '#{date.in_time_zone.strftime('%m')}'
            QUERY
          else
            # condition for month and day only
            <<-QUERY
              strftime('%m%d', #{field}) = '#{date.in_time_zone.strftime('%m%d')}'
            QUERY
          end
        elsif skip_args.include?(:month)
          if skip_args.include?(:date)
            # condition for year only
            <<-QUERY
              strftime('%Y', #{field}) = '#{date.in_time_zone.strftime('%Y')}'
            QUERY
          else
            # condition for year and date only
            <<-QUERY
              strftime('%Y%d', #{field}) = '#{date.in_time_zone.strftime('%Y%d')}'
            QUERY
          end
        elsif skip_args.include?(:date)
          # condition for month and year only.
          <<-QUERY
            strftime('%Y%m', #{field}) = '#{date.in_time_zone.strftime('%Y%m')}'
          QUERY
        else
          # condition for checking current date without time
          <<-QUERY
            strftime('%Y%m%d', #{field}) = '#{date.in_time_zone.strftime('%Y%m%d')}'
          QUERY
        end

      end

    end
  end
end
