class Player
  constructor: (@score) ->

  increaseScore: (offset) -> @score += offset

  formattedScore: -> if(@score > 1) then "#{@score} Points" else "#{@score} Point"

class Ship
  constructor: (@x, @y) ->
     @live = 5

  width: 40
  height: 30

  moveLeft: (min) ->
    newValue = @x - 10
    @x = if(newValue < min) then min else newValue

  moveRight: (max) ->
    newValue = @x + 10
    maxValue = max - @width
    @x = if(newValue > maxValue) then maxValue else newValue

  isAlive: -> @live > 0

  fire: -> new Projectile(@x + @width / 2, @y )

  destroyAliens: (aliens, number) ->
     @live = @live - 1
     aliens[0..number - 1].forEach (alien) -> alien.decreaseLive()

class Alien
  constructor: (@x, @y) ->
    @live = 1
    @sens = 1
    @value = 10

  width: 30
  height: 30

  isAlive: -> @live > 0

  move: (min, max) ->
    newXValue = @x + @sens * 10
    maxXValue = max - @width
    isXMoreThanMax = newXValue > maxXValue
    isXLessThanMin = newXValue < min
    @x = if(isXMoreThanMax || isXLessThanMin) then (if (isXMoreThanMax) then maxXValue else min) else newXValue
    @y = if(isXMoreThanMax || isXLessThanMin) then @y + 40 else @y
    @sens = if(isXMoreThanMax || isXLessThanMin) then -@sens else @sens

  decreaseLive: -> @live = @live - 1

  mutate: -> new VeryBadAlien(this)

class VeryBadAlien extends Alien
  constructor: (alien) ->
    @x = alien.x
    @y = alien.y
    @sens = alien.sens
    @live = 2
    @value = 25

  mutate: -> this

  mutates: (aliens) -> (alien.mutate() for alien in aliens)

class Projectile
  constructor: (@x, @y) ->

  height:10
  width:5

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



