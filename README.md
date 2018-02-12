# Optimizing performance

### Enter the N + 1 Problem

Consider this query:

```ruby
@users = User.limit(50)

@user_movies = @users.map do |user|
  user.movies
end
```

The corresponding SQL:

```sql
SELECT  "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
SELECT "movies".* FROM "movies" INNER JOIN "user_movies" ON "movies"."id" = "user_movies"."movie_id" WHERE "user_movies"."user_id" = $1
```

Think about what's happening here and the total number of queries executed. Iterating over our users `@users.map` takes O(n) time; the amount of work done grows proportionally with the number of records we iterate over. In this case, `@users` is an active record collection containing 50 records. Therefore, iterating over that collection takes 50 units of work.

We now add more complexity by performing an additional operation for each operation. This means for every N units of work done, we have to do 1 extra unit of work `user.movies`. Therefore, the time complexity of this query can be expressed as N + 1 where N refers to the number of units of work performed plus 1 extra operation for each step.

### Enter Eager Loading™️

According to the (rails documentation)[http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations], `Eager loading is the mechanism for loading the associated records of the objects returned by Model.find using as few queries as possible.`

In other words, ActiveRecord allows us to specify associated models in advance and significantly cut down the number of queries we need to run against the database. The `includes` keyword can be used to eager load associations.

Using the above example, we can refactor the query like so:

```ruby
@users = User.includes(:movies).limit(50)

@users.each do |user|
  user.movies
end
```

Using includes will cut our SQL queries down:

```sql
SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
SELECT "user_movies".* FROM "user_movies" WHERE "user_movies"." user_id" = 1
SELECT "movies".* FROM "movies" WHERE "movies"."id" IN (1, 2, 3, 4)
```
