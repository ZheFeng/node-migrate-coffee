
#!
# * migrate - Set
# * Copyright (c) 2010 TJ Holowaychuk <tj@vision-media.ca>
# * MIT Licensed
#

###*
Module dependencies.
###

###*
Expose `Set`.
###

###*
Initialize a new migration `Set` with the given `path`
which is used to store data between migrations.

@param {String} path
@api private
###
Set = (path) ->
  @migrations = []
  @path = path
  @pos = 0
  return

###*
Inherit from `EventEmitter.prototype`.
###

###*
Save the migration data and call `fn(err)`.

@param {Function} fn
@api public
###

###*
Load the migration data and call `fn(err, obj)`.

@param {Function} fn
@return {Type}
@api public
###

###*
Run down migrations and call `fn(err)`.

@param {Function} fn
@api public
###

###*
Run up migrations and call `fn(err)`.

@param {Function} fn
@api public
###

###*
Migrate in the given `direction`, calling `fn(err)`.

@param {String} direction
@param {Function} fn
@api public
###

###*
Get index of given migration in list of migrations

@api private
###
positionOfMigration = (migrations, filename) ->
  i = 0

  while i < migrations.length
    return i  if migrations[i].title is filename
    ++i
  -1
EventEmitter = require("events").EventEmitter
fs = require("fs")
module.exports = Set
Set::__proto__ = EventEmitter::
Set::save = (fn) ->
  self = this
  json = JSON.stringify(this)
  fs.writeFile @path, json, (err) ->
    self.emit "save"
    fn and fn(err)
    return

  return

Set::load = (fn) ->
  @emit "load"
  fs.readFile @path, "utf8", (err, json) ->
    return fn(err)  if err
    try
      fn null, JSON.parse(json)
    catch err
      fn err
    return

  return

Set::down = (fn, migrationName) ->
  @migrate "down", fn, migrationName
  return

Set::up = (fn, migrationName) ->
  @migrate "up", fn, migrationName
  return

Set::migrate = (direction, fn, migrationName) ->
  self = this
  fn = fn or ->

  @load (err, obj) ->
    if err
      return fn(err)  unless "ENOENT" is err.code
    else
      self.pos = obj.pos
    self._migrate direction, fn, migrationName
    return

  return


###*
Perform migration.

@api private
###
Set::_migrate = (direction, fn, migrationName) ->
  next = (err, migration) ->

    # error from previous migration
    return fn(err)  if err

    # done
    unless migration
      self.emit "complete"
      self.save fn
      return
    self.emit "migration", migration, direction
    migration[direction] (err) ->
      next err, migrations.shift()
      return

    return
  self = this
  migrations = undefined
  migrationPos = undefined
  unless migrationName
    migrationPos = (if direction is "up" then @migrations.length else 0)
  else if (migrationPos = positionOfMigration(@migrations, migrationName)) is -1
    console.error "Could not find migration: " + migrationName
    process.exit 1
  switch direction
    when "up"
      migrations = @migrations.slice(@pos, migrationPos + 1)
      @pos += migrations.length
    when "down"
      migrations = @migrations.slice(migrationPos, @pos).reverse()
      @pos -= migrations.length
  next null, migrations.shift()
  return
