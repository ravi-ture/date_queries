module DateQueries
  module Adapter
    class MysqlAdapter

      def self.condition_string_for_range(field, start_date, end_date, *skip_args)
        # Mysql related conditions string with skipped arguments

        if skip_args.present?
          if skip_args.include?(:year)
            if skip_args.include?(:month)
              # condition with month and year skipped
              if start_date.strftime('%d') > end_date.strftime('%d')
                <<-QUERY
                  (DATE_FORMAT(`#{field}`, '%d') BETWEEN '#{start_date.in_time_zone.strftime('%d')}' AND '31')
                  OR (DATE_FORMAT(`#{field}`, '%d') BETWEEN '01' AND '#{end_date.in_time_zone.strftime('%d')}')
                QUERY
              else
                <<-QUERY
                  DATE_FORMAT(`#{field}`, '%d') BETWEEN
                    '#{start_date.in_time_zone.strftime('%d')}' AND '#{end_date.in_time_zone.strftime('%d')}'
                QUERY
              end
            elsif skip_args.include?(:date)
              # condition with year and date skipped
              if start_date.strftime('%m') > end_date.strftime('%m')
                <<-QUERY
                  (DATE_FORMAT(`#{field}`, '%m') BETWEEN '#{start_date.in_time_zone.strftime('%m')}' AND '12')
                  OR (DATE_FORMAT(`#{field}`, '%m') BETWEEN '01' AND '#{end_date.in_time_zone.strftime('%m')}')
                QUERY
              else
                <<-QUERY
                  DATE_FORMAT(`#{field}`, '%m') BETWEEN
                    '#{start_date.in_time_zone.strftime('%m')}' AND '#{end_date.in_time_zone.strftime('%m')}'
                QUERY
              end
            else
              # condition with only year skipped
              if start_date.strftime('%m%d') > end_date.strftime('%m%d')
                <<-QUERY
                  (DATE_FORMAT(`#{field}`, '%m%d') BETWEEN '#{start_date.in_time_zone.strftime('%m%d')}' AND '1231')
                  OR (DATE_FORMAT(`#{field}`, '%m%d') BETWEEN '0101' AND '#{end_date.in_time_zone.strftime('%m%d')}')
                QUERY
              else
                <<-QUERY
                  DATE_FORMAT(`#{field}`, '%m%d') BETWEEN
                    '#{start_date.in_time_zone.strftime('%m%d')}' AND '#{end_date.in_time_zone.strftime('%m%d')}'
                QUERY
              end
            end
          elsif skip_args.include?(:month)
            if skip_args.include?(:date)
              # condition with month and date skipped
              <<-QUERY
                DATE_FORMAT(`#{field}`, '%Y') BETWEEN
                  '#{start_date.in_time_zone.strftime('%Y')}' AND '#{end_date.in_time_zone.strftime('%Y')}'
              QUERY
            else
              # condition with only month skipped
              <<-QUERY
                DATE_FORMAT(`#{field}`, '%Y%d') BETWEEN
                  '#{start_date.in_time_zone.strftime('%Y%d')}' AND '#{end_date.in_time_zone.strftime('%Y%d')}'
              QUERY
            end
          elsif skip_args.include?(:date)
            # condition with only date skipped
            <<-QUERY
              DATE_FORMAT(`#{field}`, '%Y%m') BETWEEN
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
              DATE_FORMAT(`#{field}`, '%d') = '#{date.in_time_zone.strftime('%d')}'
            QUERY
          elsif skip_args.include?(:date)
            # condition for month only
            <<-QUERY
              DATE_FORMAT(`#{field}`, '%m') = '#{date.in_time_zone.strftime('%m')}'
            QUERY
          else
            # condition for month and day only
            <<-QUERY
              DATE_FORMAT(`#{field}`, '%m%d') = '#{date.in_time_zone.strftime('%m%d')}'
            QUERY
          end
        elsif skip_args.include?(:month)
          if skip_args.include?(:date)
            # condition for year only
            <<-QUERY
              DATE_FORMAT(`#{field}`, '%Y') = '#{date.in_time_zone.strftime('%Y')}'
            QUERY
          else
            <<-QUERY
              DATE_FORMAT(`#{field}`, '%Y%d') = '#{date.in_time_zone.strftime('%Y%d')}'
            QUERY
          end
        elsif skip_args.include?(:date)
          # condition for month and year only
          <<-QUERY
            DATE_FORMAT(`#{field}`, '%Y%m') = '#{date.in_time_zone.strftime('%Y%m')}'
          QUERY
        else
          # condition for date without time
          <<-QUERY
            DATE_FORMAT(`#{field}`, '%Y%m%d') = '#{date.in_time_zone.strftime('%Y%m%d')}'
          QUERY
        end

      end

    end
  end
end
