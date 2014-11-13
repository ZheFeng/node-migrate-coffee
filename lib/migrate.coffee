
#!
# * migrate
# * Copyright(c) 2011 TJ Holowaychuk <tj@vision-media.ca>
# * MIT Licensed
#

###*
Module dependencies.
###

###*
Expose the migrate function.
###

###*
Library version.
###
migrate = (title, up, down) ->

  # migration
  if "string" is typeof title and up and down
    migrate.set.migrations.push new Migration(title, up, down)

  # specify migration file
  else if "string" is typeof title
    migrate.set = new Set(title)

  # no migration path
  else unless migrate.set
    throw new Error("must invoke migrate(path) before running migrations")

  # run migrations
  else
    migrate.set
  return
Migration = require("./migration")
Set = require("./set")
exports = module.exports = migrate
exports.version = "0.1.3"
