QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root for this schema'

  field :movies do
    type types[MovieType]
    argument :year, types.Int
    resolve ->(_obj, args, _ctx) {
      if args[:year].present?
        Movie.where(year: args[:year])
      else
        Movie.all
      end
    }
  end

  field :movie do
    type MovieType
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) {
      Movie.find(args[:id])
    }
  end

  field :actor do
    type ActorType
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) {
      Actor.find(args[:id])
    }
  end
end
