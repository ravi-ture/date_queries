# DateQueries
Package to provide date related scopes for Active Record Models. This gem allows you to have scopes like records with the field in a particular month or year or on a specific day. The gem actually ammends adapters to provide the queries on database level an not just on rails level sopes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'date_queries'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install date_queries

## Usage

This gem has two class methods defined

### acts_as_birthday(:field1, :field2, ...)

This will give you two methods as followed:

```ruby

model User < ActiveRecord::Base
  acts_as_birthday :birth_date
end

user = User.last         # => #<User id: 1, name: "Test User", birth_date: "1991-11-11", created_at: "2021-02-01 11:35:48.713098000 +1100", updated_at: "2021-02-01 11:35:48.713098000 +1100">
user.birth_date_age      #  => 29
user.birth_date_today?   # => false

```

### date_queries_for(:field1, :field2, ...)

This is method provides variety of methods as followed:

```ruby

model User < ActiveRecord::Base
  date_queries_for :birth_date
end
```
In the example above following methods will be created:

#### User.birth_dates_passed

Scope for user model to find out if the field's date has passed in this year or not.

NOTE: This method checks the date in the format of dd/mm and not year.

#### User.birth_dates_in_future

Scope for user model to find out the records with birth date value has not yet passed for this year.

#### User.birth_dates_in(start_date, end_date)

Scope to find out records with birth date lies in the given range

#### User.birth_dates_in_this_year

Finds user records with date field is in this year.

#### User.birth_dates_in_this_month

Finds Users whoes birth date is in this month

#### User.birth_date_is_today

Users with the birth date is today

#### User.birth_dates_after(date)

Users with birth date after given date

#### User.birth_dates_before(date)

Users with birthdate is before given date

#### User.birth_dates_in_range(start_date, end_date, *skip_args)

This is a spacial method providing full power of comparing dates while skipping month or year or date of a date field.

There can be few examples of this method
1. if you want to find out the users with birth day between 11 - 20 in any month and any year

```ruby
User.birth_dates_in_rage('11-01-2020', '15-01-2020', :month, :year)
```

2. If you want to find users with birth_dates in the months of Jan, Feb and March

```ruby
User.birth_dates_in_rage('11-01-2020', '15-03-2020', :date, :year)
```

3. If you want to find birth_dates in this the year 1991 to 2003

```ruby
User.birth_dates_in_rage('11-01-1991', '15-01-2003', :month, :date)
```

4. If you want to users with birth dates in feb to march month of 1992

```ruby
User.birth_dates_in_rage('11-02-1992', '15-03-1992', :date)
```



These scopes are not neccessarily to be used with only for date type fields, its also compatible with date time fields.

Note: This gem is inspired from [Birthday gem](https://github.com/railslove/birthday)


## TODO:

  Write Specs

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/date_queries.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
