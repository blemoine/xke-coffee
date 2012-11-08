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

@game = new Game('board', 600, 400)

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

class @StartState extends State
  constructor: (@width, @height) ->
    keyBindings = {}
    keyBindings[32] = -> game.changeState new IngameState(game.width, game.height, game.player)
    super(@width, @height, keyBindings)

  render: (context) ->
    super context

    context.fillStyle = 'white'
    context.font = "24pt Helvetica"
    context.fillText("Press space to start", 140, 200)

class LoseState extends State
  constructor: (@width, @height) ->
    keyBindings = {}
    keyBindings[32] = -> game.changeState new IngameState(game.width, game.height, game.player)
    super(@width, @height, keyBindings)

  render: (context) ->
    super context

    context.fillStyle = 'white'
    context.font = "24pt Helvetica"
    context.fillText("You Lose ! Press start to restart", 100, 200)

spriteImageBuilder = (url) ->
  img = new Image()
  img.src = url
  img

SPRITES =
  ship: spriteImageBuilder('ship.png')
  alien: spriteImageBuilder('normal-alien.png')
  veryBadAlien: spriteImageBuilder('bad-alien.png')
  projectile: spriteImageBuilder('projectile.png')
  space: spriteImageBuilder('space2.png')


class IngameState extends State
  constructor: (@width, @height, @player) ->
    keyBindings = {}
    keyBindings[37] = => @ship.moveLeft(0) if @ship
    keyBindings[39] = => @ship.moveRight(@width) if @ship
    keyBindings[13] = => @ship.destroyAliens(@aliens, 5) if @ship && @aliens
    keyBindings[32] = =>
      if @ship && @projectiles.length < 5
        projectile = @ship.fire()
        @projectiles.push projectile if(projectile)
    super(@width, @height, keyBindings)


  init: ->
    super()
    @aliens = []
    @projectiles = []
    @ship = (new Ship(0, @height - Ship:: height) ) if(Ship?)

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

          if !hasCollision && projectile.y > 0
            newProjectiles.push projectile

        deadAliens = @aliens.filter (alien) => !alien.isAlive()
        if(deadAliens.length > 0)
          score = deadAliens.reduce(((acc, alien) ->
            acc + alien.value
          ), 0)
          @player.increaseScore(score)
          @aliens = @aliens.filter (alien) => alien.isAlive()


        @projectiles = newProjectiles

        @aliens.forEach (alien) =>
          alien.move(0, @width)
          if alien.y + alien.height > @height
            game.changeState new LoseState(@width, @height)
      if @timePassed % SPAWN_INTERVAL == 0
        @aliens.push new Alien(0, 0) if Alien?

      if @timePassed % MUTATE_INTERVAL == 0
        @aliens = VeryBadAlien:: mutates(@aliens) if VeryBadAlien?

      if @ship? && @ship.isAlive? && !@ship.isAlive()
        game.changeState new LoseState(@width, @height)

      if @timePassed > MOVE_INTERVAL * SPAWN_INTERVAL * MUTATE_INTERVAL
        @timePassed = 0
    ), 20)

  destroy: ->
    super()
    clearInterval @modelInterval

  render: (context) ->
    super context

    context.drawImage(SPRITES.space, 0, 0)

    if(@player?)
      $('#score').html @player.formattedScore()

    if(@ship?)
      context.drawImage(SPRITES.ship, @ship.x, @ship.y)

    @aliens.forEach (alien) ->
      if(VeryBadAlien? && alien instanceof VeryBadAlien)
        img = SPRITES.veryBadAlien
      else
        img = SPRITES.alien
      context.drawImage(img, alien.x, alien.y)


    @projectiles.forEach (projectile) ->
      context.drawImage(SPRITES.projectile, projectile.x, projectile.y)

