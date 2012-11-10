class Player
  constructor: (@score) ->

  increaseScore: (offset) -> @score += offset

  formattedScore: -> if(@score > 1) then "#{@score} Points" else "#{@score} Point"

class Ship
  constructor: (@x, @y) ->
    @live = 5

  width: 40
  height: 30

  moveLeft: (min) -> @x -= 10

  moveRight: (max) -> @x += 10

  isAlive: -> @live > 0

  fire: -> new Projectile(@x + @width / 2, @y)

  destroyAliens: (aliens, number) ->
    @live = @live - 1
    aliens[0..number - 1].forEach (alien) -> alien.decreaseLive()

class Alien
  constructor: (@x, @y) ->
    @live = 1
    @value = 10

  width: 30
  height: 30

  isAlive: -> @live > 0

  move: (sens) ->
    switch sens
      when "right", "left"
        alpha = if (sens == 'right') then 1 else -1
        @x = @x + alpha * 10
      when "down" then @y += 40

  decreaseLive: -> @live = @live - 1

  mutate: -> new VeryBadAlien(@x, @y)

class VeryBadAlien extends Alien
  constructor: (@x, @y) ->
    @live = 2
    @value = 25

  mutate: -> this

  mutates: (aliens) -> (alien.mutate() for alien in aliens)

class Projectile
  constructor: (@x, @y) ->

  height: 10
  width: 5

  move: -> @y = @y - 10

  hasCollisionWith: (alien) ->
    !(alien.x + alien.width < @x ||
    alien.x > @x + @width ||
    alien.y + alien.height < @y ||
    alien.y > @y + @height
    )

@Ship = Ship if Ship?
@Alien = Alien if Alien?
@VeryBadAlien = VeryBadAlien if VeryBadAlien?
@Projectile = Projectile if Projectile?
@Player = Player if Player?



