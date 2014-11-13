
# bad example, but you get the point ;)

# $ npm install redis
# $ redis-server
migrate = require("../")
redis = require("redis")
db = redis.createClient()
migrate __dirname + "/.migrate"
migrate "add pets", ((next) ->
  db.rpush "pets", "tobi"
  db.rpush "pets", "loki", next
  return
), (next) ->
  db.rpop "pets"
  db.rpop "pets", next
  return

migrate "add jane", ((next) ->
  db.rpush "pets", "jane", next
  return
), (next) ->
  db.rpop "pets", next
  return

migrate "add owners", ((next) ->
  db.rpush "owners", "taylor"
  db.rpush "owners", "tj", next
  return
), (next) ->
  db.rpop "owners"
  db.rpop "owners", next
  return

migrate "coolest pet", ((next) ->
  db.set "pets:coolest", "tobi", next
  return
), (next) ->
  db.del "pets:coolest", next
  return

set = migrate()
console.log()
set.on "save", ->
  console.log()
  return

set.on "migration", (migration, direction) ->
  console.log "  \u001b[90m%s\u001b[0m \u001b[36m%s\u001b[0m", direction, migration.title
  return

set.up (err) ->
  throw err  if err
  process.exit()
  return
