# EncryptionMigrator

This gem allows you to un-encrypt attr_encrypted fields and convert them back to regular fields.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'encryption_migrator'
```

## Usage
Here is the encrypted attribute that I want to remove:

```irb
2.3.0 :001 > User.first
  User Load (0.6ms)  SELECT  `users`.* FROM `users`  ORDER BY `users`.`id` ASC LIMIT 1
 => #<User id: 1, created_at: "2016-02-20 12:27:46", updated_at: "2016-02-20 12:27:46", encrypted_name: "MoVXQ76yxiQPgJ3mdkR81A==\n">
```

1) Remove `attr_encrypted` line from models:
```ruby
class User < ActiveRecord::Base
  attr_encrypted :name, :key => 'a secret key', :attribute => 'encrypted_name' # => remove this line
end
```

2) Add a migration to un-encrypt columns:
```ruby
class UnencryptFields < ActiveRecord::Migration
  def up
    unencrypt_field :users, :name, key: 'a secret key'
  end
end
```

Now you can see that the field has been unencrypted:

```irb
2.3.0 :001 > User.first
  User Load (0.4ms)  SELECT  `users`.* FROM `users`  ORDER BY `users`.`id` ASC LIMIT 1
 => #<User id: 1, created_at: "2016-02-20 12:27:46", updated_at: "2016-02-20 12:27:46", name: "tom">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/encryption_migrator.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
