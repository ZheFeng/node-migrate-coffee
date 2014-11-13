
#!
# * migrate - Migration
# * Copyright (c) 2010 TJ Holowaychuk <tj@vision-media.ca>
# * MIT Licensed
#

###*
Expose `Migration`.
###
Migration = (title, up, down) ->
  @title = title
  @up = up
  @down = down
  return
module.exports = Migration
