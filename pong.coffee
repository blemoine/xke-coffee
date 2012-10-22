class Game
  constructor: (@id, @width, @height) ->
    @state = null
    @player = null

  changeState: (newState) ->
    @state?.destroy()
    @state = newState
    @state?.init()

  render: () ->
    canvas = document.getElementById @id
    canvas.width = @width
    canvas.height = @height
    @context = canvas.getContext('2d')
    setInterval(( =>
      @state.render @context
    ), 50)

game = new Game('board', 600, 400)

class State
  constructor: (@width, @height, @keyBindings) ->

  init: ->
    $(document).keydown (event) =>
      key = event.which
      if @keyBindings[key]
        @keyBindings[key]()

  destroy: -> $(document).off 'keydown'

  render: (context) ->
    context.fillStyle = "black"
    context.fillRect(0, 0, @width, @height)

class StartState extends State
  constructor: (@width, @height) ->
    keyBindings = {}
    keyBindings[KeyboardEvent.DOM_VK_SPACE] = -> game.changeState new IngameState(game.width, game.height, game.player)
    super(@width, @height, keyBindings)

  render: (context) ->
    super context

    context.fillStyle = 'white'
    context.font = "24pt Helvetica"
    context.fillText("Press space to start", 140, 200)

class LoseState extends State
  constructor: (@width, @height) ->
    keyBindings = {}
    keyBindings[KeyboardEvent.DOM_VK_SPACE] = -> game.changeState new IngameState(game.width, game.height, game.player)
    super(@width, @height, keyBindings)

  render: (context) ->
    super context

    context.fillStyle = 'white'
    context.font = "24pt Helvetica"
    context.fillText("You Lose ! Press start to restart", 100, 200)

class IngameState extends State
  constructor: (@width, @height, @player) ->
    keyBindings = {}
    keyBindings[KeyboardEvent.DOM_VK_LEFT] = => @ship.moveLeft(0) if @ship
    keyBindings[KeyboardEvent.DOM_VK_RIGHT] = => @ship.moveRight(@width) if @ship
    keyBindings[KeyboardEvent.DOM_VK_RETURN] = => @ship.destroyAliens(@aliens, 5) if @ship && @aliens
    keyBindings[KeyboardEvent.DOM_VK_SPACE] = =>
      if(@ship)
        projectile = @ship.fire()
        @projectiles.push projectile if(projectile)
    super(@width, @height, keyBindings)


  init: ->
    super()
    @aliens = []
    @projectiles = []
    @ship = (new Ship(0, @height - Ship:: height) ) if(Ship?)
    @imageProjectile = new Image()
    @imageProjectile.src = 'projectile.png'

    @timePassed = 0
    SPAWN_INTERVAL = 40
    MOVE_INTERVAL = 2
    MUTATE_INTERVAL = 400

    @modelInterval = setInterval(( =>
      @timePassed += 1

      if @timePassed % MOVE_INTERVAL == 0
        newProjectiles = []
        @projectiles.forEach (projectile) =>
          projectile.move()

          hasCollision = false
          @aliens.forEach (alien) =>
            if !hasCollision && projectile.hasCollisionWith(alien)
              alien.decreaseLive()
              hasCollision = true

          if !hasCollision
            newProjectiles.push projectile

        newAliens = @aliens.filter (alien) => alien.isAlive()
        differenceInSize = @aliens.length > newAliens.length
        if(differenceInSize > 0)
          @player.increaseScore(differenceInSize*10)
          @aliens = newAliens


        @projectiles = newProjectiles

        @aliens.forEach (alien) =>
          alien.move(0, @width)
          if alien.y + alien.height > @height
            game.changeState new LoseState(@width, @height)
      if @timePassed % SPAWN_INTERVAL == 0
        @aliens.push new Alien(0, 0) if Alien?

      if @timePassed % MUTATE_INTERVAL == 0
        @aliens = VeryBadAlien::mutates(@aliens) if VeryBadAlien?

      if @timePassed > MOVE_INTERVAL * SPAWN_INTERVAL * MUTATE_INTERVAL
        @timePassed = 0
    ), 20)

  destroy: ->
    super()
    clearInterval @modelInterval

  render: (context) ->
    super context

    if(@player?)
      $('#score').html @player.formattedScore()

    if(@ship?)
      context.fillStyle = "white"
      context.fillRect(@ship.x, @ship.y, @ship.width, @ship.height)

    @aliens.forEach (alien) ->
      context.drawImage(alien.image,alien.x, alien.y)


    @projectiles.forEach (projectile) =>
      context.drawImage(@imageProjectile, projectile.x, projectile.y)

### on redige à partir d'ici ###

class Ship
  constructor: (@x, @y) ->

  height: 8
  width: 40

  moveLeft: (minValue) ->
    newXValue = @x - 10
    newXValue = minValue if newXValue < minValue
    @x = newXValue

  moveRight: (maxValue) ->
    newXValue = @x + 10
    newXValue = (maxValue - @width) if newXValue > maxValue - @width
    @x = newXValue

  fire: -> new Projectile(@x + @width / 2, @y - @height)

  destroyAliens: (aliens, number) ->
    console.log(aliens[0..number])
    aliens[0..Math.max(number, aliens.length)].forEach (alien) -> alien.decreaseLive()


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
    @image = new Image()
    @image.src = 'normal-alien.png'

  width: 30
  height: 30

  isAlive: -> @live > 0

  decreaseLive: ->  @live -= 1

  move: (start, end) ->
    newXValue = @x + @sens * 9
    newYValue = @y
    if newXValue > end - @width
      newXValue = end - @width
      newYValue = @y + 40
      @sens = -@sens
    if newXValue < start
      newXValue = start
      newYValue = @y + 40
      @sens = -@sens
    @x = newXValue
    @y = newYValue


class VeryBadAlien extends Alien
  constructor: (alien) ->
    super(alien.x, alien.y)
    @sens = alien.sens
    @image = new Image()
    @image.src = 'bad-alien.png'
    if(alien instanceof VeryBadAlien)
      @live = alien.live
    else
      @live = 2

  mutates: (aliens) -> (new VeryBadAlien(alien) for alien in aliens)

class Player
  constructor: (@score) ->

  formattedScore: -> if(@score == 0) then "#{@score} Point" else "#{@score} Points"

  increaseScore: (increase) -> @score += increase

### fin de rédaction ###

game.player = new Player(0) if (Player?)
game.changeState(new StartState(game.width, game.height))
game.render()
