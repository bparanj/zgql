Create schema.rb in model directory.

Hello GraphQL

// 1. Define some types
QueryType = GraphQL::ObjectType.define do
  name 'Query'
  field :hello do
    type types.String
    resolve -> (obj, args, ctx) { 'Hello GraphQL' }
  end
end

// 2. Connect them to a schema

Schema = GraphQL::Schema.define do
  query QueryType
end

gem "graphql"
gem "graphiql-rails"

bundle

post '/graphql', to: 'graphql#query'
if Rails.env.development?
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
end

class GraphqlController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def query
    # 3. Execute queries with your schema
    result = Schema.execute(params[:query], variables: params[:variables])
    render json: result
  end
end

ActiveRecord and GraphQL

rails g model people first_name last_name email username
rails g migration create_friendships person:references friend:references

me = Person.create(first_name: 'Steven', last_name: 'Luscher', email: 'steveluscher@fb.com', username: 'steveluscher')
dhh = Person.create(first_name: 'David', last_name: 'Heinemeier Hansson', email: 'dhh@37signals.com', username: 'dhh')
ezra = Person.create(first_name: 'Ezra', last_name: 'Zygmuntowicz', email: 'ezra@merbivore.com', username: 'ezra')
matz = Person.create(first_name: 'Yukihiro', last_name: 'Matsumoto', email: 'matz@heroku.com', username: 'matz')
me.friends << [matz]
dhh.friends << [ezra, matz]
ezra.friends << [dhh, matz]
matz.friends << [me, ezra, dhh]

rails db:migrate

class Person < ApplicationRecord
  has_and_belongs_to_many :friends,
    class_name: 'Person',
    join_table: :friendships,
    foreign_key: :person_id,
    association_foreign_key: :friend_id  
end

app/serializers/person_serializer.rb:

class PersonSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :username, :friends
  def id
    object.id.to_s
  end
  def friends
    object.friend_ids.map do |id|
      Rails.application.routes.url_helpers.person_path(id)
    end
  end
end

rails g controller people 

class PeopleController < ApplicationController
  def index
    render json: Person.all
  end
  def show
    render json: Person.find(params[:id])
  end
end

resources :people, :only => [:index, :show]

localhost:3000/people
localhost:3000/people/1


// 1. Define some types
PersonType = GraphQL::ObjectType.define do
  name 'Person'
  description 'Somebody to lean on'

  field :id, !types.ID
  field :firstName, !types.String, property: :first_name
  field :lastName, !types.String, property: :last_name
  field :email, !types.String, 'Like a phone number, but spammier'
  field :username, !types.String, 'Use this to log in to your computer'
  field :friends, -> { types[PersonType] }, 'Some people to lean on'
  field :fullName do
    type !types.String
    description 'Every name, all at once'
    resolve -> (obj, args, ctx) { "#{obj.first_name} #{obj.last_name}" }
  end
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :allPeople do
    type types[PersonType]
    description 'Everyone in the Universe'
    resolve -> (obj, args, ctx) { Person.all }
  end
  field :person do
    type PersonType
    description 'The person associated with a given ID'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { Person.find(args[:id]) }
  end
end

// 2. Connect them to a schema
Schema = GraphQL::Schema.new(
  query: QueryType,
)

https://www.youtube.com/watch?v=UBGzsb2UkeY
https://github.com/steveluscher/zero-to-graphql

