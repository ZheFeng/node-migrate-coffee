
###*
Module dependencies.
###

# remove migration file

# ignore

# dummy db

# dummy migrations

# tests

# test migrating up / down several times

# test adding / running new migrations
testNewMigrations = ->
  migrate "add dogs", ((next) ->
    db.pets.push name: "simon"
    db.pets.push name: "suki"
    next()
    return
  ), (next) ->
    db.pets.pop()
    db.pets.pop()
    next()
    return

  set.up ->
    assertPets.withDogs()
    set.up ->
      assertPets.withDogs()
      set.down ->
        assertNoPets()
        testMigrationEvents()
        return

      return

    return

  return

# test events
testMigrationEvents = ->
  migrate "adjust emails", ((next) ->
    db.pets.forEach (pet) ->
      pet.email = pet.email.replace("learnboost.com", "lb.com")  if pet.email
      return

    next()
    return
  ), (next) ->
    db.pets.forEach (pet) ->
      pet.email = pet.email.replace("lb.com", "learnboost.com")  if pet.email
      return

    next()
    return

  migrations = []
  completed = 0
  expectedMigrations = [
    "add guy ferrets"
    "add girl ferrets"
    "add emails"
    "add dogs"
    "adjust emails"
  ]
  set.on "migration", (migration, direction) ->
    migrations.push migration.title
    direction.should.be.a "string"
    return

  set.on "complete", ->
    ++completed
    return

  set.up ->
    db.pets[0].email.should.equal "tobi@lb.com"
    migrations.should.eql expectedMigrations
    completed.should.equal 1
    migrations = []
    set.down ->
      migrations.should.eql expectedMigrations.reverse()
      completed.should.equal 2
      assertNoPets()
      testNamedMigrations()
      return

    return

  return

# test migrations when migration name is given
testNamedMigrations = ->
  assertNoPets()
  set.up (->
    assertFirstMigration()
    set.up (->
      assertSecondMigration()
      set.down (->
        assertFirstMigration()
        set.up (->
          assertSecondMigration()
          set.down (->
            set.pos.should.equal 1
            return
          ), "add girl ferrets"
          return
        ), "add girl ferrets"
        return
      ), "add girl ferrets"
      return
    ), "add girl ferrets"
    return
  ), "add guy ferrets"
  return

# helpers
assertNoPets = ->
  db.pets.should.be.empty
  set.pos.should.equal 0
  return
assertPets = ->
  db.pets.should.have.length 3
  db.pets[0].name.should.equal "tobi"
  db.pets[0].email.should.equal "tobi@learnboost.com"
  set.pos.should.equal 3
  return
assertFirstMigration = ->
  db.pets.should.have.length 2
  db.pets[0].name.should.equal "tobi"
  db.pets[1].name.should.equal "loki"
  set.pos.should.equal 1
  return
assertSecondMigration = ->
  db.pets.should.have.length 3
  db.pets[0].name.should.equal "tobi"
  db.pets[1].name.should.equal "loki"
  db.pets[2].name.should.equal "jane"
  set.pos.should.equal 2
  return
migrate = require("../")
should = require("should")
fs = require("fs")
try
  fs.unlinkSync __dirname + "/.migrate"
db = pets: []
migrate __dirname + "/.migrate"
migrate "add guy ferrets", ((next) ->
  db.pets.push name: "tobi"
  db.pets.push name: "loki"
  next()
  return
), (next) ->
  db.pets.pop()
  db.pets.pop()
  next()
  return

migrate "add girl ferrets", ((next) ->
  db.pets.push name: "jane"
  next()
  return
), (next) ->
  db.pets.pop()
  next()
  return

migrate "add emails", ((next) ->
  db.pets.forEach (pet) ->
    pet.email = pet.name + "@learnboost.com"
    return

  next()
  return
), (next) ->
  db.pets.forEach (pet) ->
    delete pet.email

    return

  next()
  return

migrate.version.should.match /^\d+\.\d+\.\d+$/
set = migrate()
set.up ->
  assertPets()
  set.up ->
    assertPets()
    set.down ->
      assertNoPets()
      set.down ->
        assertNoPets()
        set.up ->
          assertPets()
          testNewMigrations()
          return

        return

      return

    return

  return

assertPets.withDogs = ->
  db.pets.should.have.length 5
  db.pets[0].name.should.equal "tobi"
  db.pets[0].email.should.equal "tobi@learnboost.com"
  db.pets[4].name.should.equal "suki"
  return


# status
process.on "exit", ->
  console.log "\n   ok\n"
  return
