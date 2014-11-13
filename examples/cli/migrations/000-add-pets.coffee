db = require("./db")
exports.up = (next) ->
  db.rpush "pets", "tobi"
  db.rpush "pets", "loki", next
  return

exports.down = (next) ->
  db.rpop "pets"
  db.rpop "pets", next
  return
