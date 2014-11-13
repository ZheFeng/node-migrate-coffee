db = require("./db")
exports.up = (next) ->
  db.rpush "owners", "taylor"
  db.rpush "owners", "tj", next
  return

exports.down = (next) ->
  db.rpop "owners"
  db.rpop "owners", next
  return
