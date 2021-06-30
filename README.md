# Simple Action

Simple Action provides a convenient DSL for building API endpoints and service objects.  It builds significantly off the the parameter coercion/validation support provided by Simple Params [simple_params](https://github.com/brycesenz/simple_params).

The design of this gem was greatly influenced by this post by Philippe Creux:
http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html

This class provides the following benefits for building API endpoints:
  * Easy assignment and automatic validation of parameters with ActiveModel-like errors.
  * A simple syntax for defining the execution block
  * Easy validation, for integration into controllers

## Installation

Add this line to your application's Gemfile:

    gem 'simple_action'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_action

## Defining your Service Class & Working with Rails Controllers

A service class is defined by two things - the parameters it accepts, and the `execute` method:

```ruby
class RegisterUser < SimpleAction::Service
  params do
    param :name
    param :age, type: :integer, validations: { numericality: { greater_than_or_equal_to: 18 } }
    param :hair_color, default: "brown", validations: { inclusion: { in: ["brown", "red", "blonde", "white"] }}
  end

  def execute
    user = User.create(name: name, age: age, hair_color: hair_color)
    UserMailer.welcome_letter(user).deliver
    user
  end
end
```

The class is executed via a `run` call to the class itself:

```ruby
response = RegisterUser.run(name: "Tom", age: 21)
response.valid? #=> true
response.errors.empty? #=> true
response.result #=> User, id: 1, name: "Tom", age: 21

response = RegisterUser.run(name: nil, age: 21)
response.valid? #=> false
response.errors[:name] #=> ["can't be blank"]
response.result #=> nil
```

## Working with Rails Controllers

Building off of the example service class above, our controller logic can now be greatly simplified, as such

```ruby
class UserController < ApplicationController
  ...

  def new
    @registration = RegisterUser.new
    render action: :new
  end

  def create
    registration = RegisterUser.run(params[:register_user])
    if registration.valid?
      @user = registration.result
      redirect_to @user, notice: "Success!"
    else
      @registration = registration
      render action: :new, alert: "Errors!"
    end
  end
```

Because the service class behaves like an ActiveModel object with regards to it's attribute assignment and parameter validation, it will continue to work with Rails forms.


# Strict/Flexible Parameter Enforcement

By default, SimpleAction via SimpleParams will throw an error if you try to assign a parameter not defined within your class.  However, you can override this setting to allow for flexible parameter assignment.

```ruby
class FlexibleParams < SimpleAction::Service
  params do
    allow_undefined_params
    param :name
    param :age, type: :integer, default: 23
  end

params = FlexibleParams.new(name: "Bryce", age: 30, weight: 160, dog: { name: "Bailey", breed: "Shiba Inu" })

params.name #=> "Bryce"
params.age #=> 30
params.weight #=> 160
params.dog.name #=> "Bailey"
params.dog.breed #=> "Shiba Inu"
```

# Using Transactions

By default, SimpleAction via SimpleParams will run the `execute` method inside of an ActiveRecord transaction.  You can modify this setting inside an initializer file.

```ruby
SimpleAction::Service.transaction = false
```

# ApiPie Documentation

If your project is using [apipie-rails](http://example.com/ "apipie-rails"),
then SimpleAction is able to automatically generate the documentation markup
for apipie.

```ruby
api :POST, '/users', "Registers a user"
eval(RegisterUser.api_pie_documentation)
```

This feature is also delegated to the SimpleParams class.  You can read more on the details of that functionality here [simple_params](https://github.com/brycesenz/simple_params).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
