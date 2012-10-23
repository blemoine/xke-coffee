###
class Ship
  constructor: (@x, @y) ->
    @live = 5

  height: 30
  width: 40

  moveLeft: (minValue) ->
    newXValue = @x - 10
    newXValue = minValue if newXValue < minValue
    @x = newXValue

  isAlive: -> @live > 0

  moveRight: (maxValue) ->
    newXValue = @x + 10
    newXValue = (maxValue - @width) if newXValue > maxValue - @width
    @x = newXValue

  fire: -> new Projectile(@x + @width / 2, @y - @height)

  destroyAliens: (aliens, number) ->
    @live -= 1
    max = if(number > aliens.length) then aliens.length else number

    aliens[0..max-1].forEach (alien) =>
      alien.decreaseLive()


class Projectile
  constructor: (@x, @y) ->

  width: 5
  height: 10

  move: -> @y -= 10

  hasCollisionWith: (alien) ->
    !( alien.x + alien.width < @x ||
    alien.x > @x + @width ||
    alien.y + alien.height < @y ||
    alien.y > @y + @height)


class Alien
  constructor: (@x, @y) ->
    @live = 1
    @sens = 1
    @value = 10

  width: 30
  height: 30

  isAlive: -> @live > 0

  decreaseLive: ->  @live -= 1

  mutate: -> new VeryBadAlien(this)

  move: (start, end, offsetX, offsetY) ->
    newXValue = @x + @sens * offsetX
    newYValue = @y
    if newXValue > end - @width
      newXValue = end - @width
      newYValue = @y + offsetY
      @sens = -@sens
    if newXValue < start
      newXValue = start
      newYValue = @y + offsetY
      @sens = -@sens
    @x = newXValue
    @y = newYValue


class VeryBadAlien extends Alien
  constructor: (alien) ->
    super(alien.x, alien.y)
    @sens = alien.sens
    @value = 25
    @live = 2

  mutate: -> this

  mutates: (aliens) -> (alien.mutate() for alien in aliens)

class Player
  constructor: (@score) ->

  formattedScore: -> if(@score < 2) then "#{@score} Point" else "#{@score} Points"

  increaseScore: (increase) -> @score += increase
###

@Ship = Ship if Ship?
@Alien = Alien if Alien?
@VeryBadAlien = VeryBadAlien if VeryBadAlien?
@Projectile = Projectile if Projectile?
@Player = Player if Player?



