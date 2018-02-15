# Optimizing performance

Consider this query:

```ruby
@users = User.all
render json: @users, status: 200
```

The `UserSerializer` looks like this:

```ruby
class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :movies
  has_many :movies
end
```

Because the user `has_many :movies`, loading a user will _also_ load their associated movies. This is similar to running:

```ruby
@users = User.all
@users.each { |u| u.movies }
```

The corresponding SQL when we `render json: @users`:

```sql
SELECT "users".* FROM "users"
SELECT "movies".* FROM "movies" INNER JOIN "user_movies" ON "movies"."id" = "user_movies"."movie_id" WHERE "user_movies"."user_i
d" = $1  [["user_id", 1]]
SELECT "movies".* FROM "movies" INNER JOIN "user_movies" ON "movies"."id" = "user_movies"."movie_id" WHERE "user_movies"."user_i
d" = $1  [["user_id", 2]]
SELECT "movies".* FROM "movies" INNER JOIN "user_movies" ON "movies"."id" = "user_movies"."movie_id" WHERE "user_movies"."user_i
d" = $1  [["user_id", 3]]

...
```

The first query, `SELECT "users".* FROM "users"`, loads all of our user objects. However, we also need to load each user's movies. In order to load that data, we have to iterate over every single user object _and_ load that object's movies.

### Enter the N + 1 Problem

Iterating over all the users grows proportionally with the number of user objects in the database. If we have 500, iterating takes 500 units of work––O(n). However, we aren't _just_ iterating over every user. We're iterating over every user _AND_ loading that user's movies. This can be expressed as N + 1 where N is the number of users plus one _extra_ unit of work for each item. In other words, for every user in the database, we alos have to make this `SELECT "movies".* FROM "movies" INNER JOIN "user_movies" ON "movies"."id" = "user_movies"."movie_id" WHERE "user_movies"."user_i d" = $1` query.

### Enter Eager Loading™️

According to the [rails documentation](http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations), `Eager loading is the mechanism for loading the associated records of the objects returned by Model.find using as few queries as possible.`

We already know ahead of time that users should be loaded with their movies. This means we can preload all the movies associated with our users while we request our users.

Let's take a look at an example:

```ruby
@users = User.includes(:movies).limit(50)

render json: @users, status: 200
```

Using includes will significantly cut our SQL queries down:

```sql
SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
SELECT "user_movies".* FROM "user_movies" WHERE "user_movies"." user_id" = 1
SELECT "movies".* FROM "movies" WHERE "movies"."id" IN (1, 2, 3, 4, 5, 6, 7.......)
```

Instead of iterating over every single user and finding that object's movies, we can load the data we need ahead of time. Because we know that we'll need the movies associated with a particular user, we can tell ActiveRecord to load the users, load the `user_movies`, and then load associated movies. The total number of queries for this operation has gone from N + 1 to just 3 SQL queries total.

Using `includes` can dramatically improve the performance of your queries _if_ you're making N + 1 queries. This does not mean that `includes` is a magic bullet and you shouldn't throw it into every controller.

For example, when loading a _single record_, the `includes` statement may be overkill. Consider the show page for a single user:

```ruby
@user = User.includes(:movies).find(params[:id])
render json: @user, status: 200
```

Results in the following SQL:

```sql
SELECT  "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 50], ["LIMIT", 1]]

SELECT "user_movies".* FROM "user_movies" WHERE "user_movies"."user_id" = 50

SELECT "movies".* FROM "movies" WHERE "movies"."id" IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 2
8, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50...
```

However, omitting the `includes`

```ruby
@user = User.find(params[:id])
render json: @user, status: 200
```

Results in the following SQL:

```sql
SELECT  "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 50], ["LIMIT", 1]]

SELECT "movies".* FROM "movies" INNER JOIN "user_movies" ON "movies"."id" = "user_movies"."movie_id" WHERE "user_movies"."user_i
d" = $1  [["user_id", 50]]
```

Because we are always loading one user object, an eager load is not appropriate for the show page. We're only loading one user and finding their movies, which can be accomplished in 2 SQL queries instead of 3. This is not an N + 1 query because the amount of work done has nothing to do with the number of users in the database. We're always grabbing a single user.

### Indexing Attributes

What about a case where finding a user does take longer as we add more users?

Consider this query:

```ruby
@user = User.find_by(username: params[:username])
```

In the worst case, we would have to iterate over _all_ the user objects in the database, which can be expressed as an O(n) operation where n is the number of users.

We can avoid having to iterate over every user object by indexing the username on the user table:

```ruby
# ... in migration file:
  add_index :users, :username, unique: true
```

When accessing a user by id, we don't have to iterate over every user object. This is because ids are [indexed](https://stackoverflow.com/questions/2955459/what-is-an-index-in-sql):

```
Indexes are all about finding data quickly.
Indexes in a database are analogous to indexes that you find in a book.
If a book has an index, and I ask you to find a chapter in that book,
you can quickly find that with the help of the index.
```

Similarly, we can index usernames on the user model to cut our O(n) to an O(log n) [depending on the implementation details of whichever version of PG you're using](https://dba.stackexchange.com/questions/7375/is-there-any-index-with-o1-complexity-for-lookup-in-postgresql).
