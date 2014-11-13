db = require("./db")
exports.up = (next) ->
  db.rpush "pets", "jane", next
  return

exports.down = (next) ->
  db.rpop "pets", next
  return
