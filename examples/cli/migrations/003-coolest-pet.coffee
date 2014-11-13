db = require("./db")
exports.up = (next) ->
  db.set "pets:coolest", "tobi", next
  return

exports.down = (next) ->
  db.del "pets:coolest", next
  return
