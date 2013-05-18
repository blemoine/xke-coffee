module 'Player class'
test 'There is a class Player with an attribute score set with the constructor', ->
  player = new Player(122)
  equal player.score, 122

test 'The method increaseScore of the class Player increase the score', ->
  player = new Player(540)
  player.increaseScore(26)
  equal player.score, 566

test 'The method formatedScore return a textual representation of the score with no plural if score = 0', ->
  player = new Player(0)
  equal player.formattedScore(), '0 Point'

test 'The method formatedScore return a textual representation of the score with no plural if score = 1', ->
  player = new Player(1)
  equal player.formattedScore(), '1 Point'

test 'The method formatedScore return a textual representation of the score with plural if score > 1', ->
  player = new Player(2)
  equal player.formattedScore(), '2 Points'


module 'Ship class'
test "There is a class Ship with 2 attributes x and y in the constructor, representing the position on the screen of the top-left corner of the ship", ->
  ship = new Ship(12, 34)
  equal ship.x, 12
  equal ship.y, 34

test 'There is a class Ship, with 2 properties width and height', ->
  equal Ship::width, 40, "Width must be 40"
  equal Ship::height, 30, "Height must be 30"

test 'The method moveLeft of class Ship substract 10 to the x position of the ship', ->
  ship = new Ship(15, 23)
  ship.moveLeft()
  equal ship.x, 5

test 'The method moveRight of class Ship add 10 to the x position of the ship', ->
  ship = new Ship(15, 23)
  ship.moveRight()
  equal ship.x, 25

module 'Alien class'
test 'There is a class Alien, taking 2 attributes x and y in the constructor,  representing the position on the screen of the top-left corner of the alien', ->
  alien = new Alien(34, 67)
  equal alien.x, 34
  equal alien.y, 67

test 'There is a class Alien, with 2 properties height and width', ->
  equal Alien::width, 30
  equal Alien::height, 30

test 'an instance of Alien have a default number of live equals to 1', ->
  alien = new Alien(12, 23)
  equal alien.live, 1

test 'The method isAlive of class Alien return true if alien has more than 0 live ', ->
  alien = new Alien(4, 6)
  ok alien.isAlive()

test 'The method isAlive of class Alien return false if alien has 0 live ', ->
  alien = new Alien(4, 6)
  alien.live = 0
  ok !alien.isAlive()

test 'The method move of class Alien add ten to x if the parameter value is right', ->
  alien = new Alien(20, 20)
  alien.move('right')
  equal alien.x, 30
  equal alien.y, 20

test 'The method move of class Alien substract ten to x if the parameter value is left', ->
  alien = new Alien(20, 20)
  alien.move('left')
  equal alien.x, 10
  equal alien.y, 20

test "The method move of class Alien doesn't do anything if parameter isn't valid", ->
  alien = new Alien(20, 20)
  alien.move('top')
  equal alien.x, 20
  equal alien.y, 20

test 'The method move of class Alien add forty to y if the parameter value is down', ->
  alien = new Alien(20, 20)
  alien.move('down')
  equal alien.x, 20
  equal alien.y, 60


test 'The method decreaseLive of class Alien decrease the live counter', ->
  alien = new Alien(4, 6)
  alien.decreaseLive()
  equal alien.live, 0

test 'The value of an alien is 10 points', ->
  alien = new Alien(10, 23)
  equal alien.value, 10

module 'VeryBadAlien'
test 'There is a class VeryBadAlien which extend Alien and taking 2 attributes x and y in the constructor,  representing the position on the screen of the top-left corner of the very bad alien', ->
  veryBadAlien = new VeryBadAlien(23, 45)
  ok veryBadAlien instanceof Alien
  equal veryBadAlien.x, 23
  equal veryBadAlien.y, 45

test 'A new instance of VeryBadAlien has 2 lives', ->
  veryBadAlien = new VeryBadAlien(23, 45)
  equal veryBadAlien.live, 2

test 'The value of an veryBadAlien is 25 points', ->
  veryBadAlien = new VeryBadAlien(10, 23)
  equal veryBadAlien.value, 25

test 'A VeryBadAlien has a method mutate which return the current instance of VeryBadAlien', ->
  veryBadAlien = new VeryBadAlien(10, 13)
  equal veryBadAlien.mutate(), veryBadAlien

test 'An alien has a method mutate which return the corresponding VeryBadAlien', ->
  alien = new Alien(10, 13)
  alienMutated = alien.mutate()
  ok alienMutated instanceof VeryBadAlien
  equal alien.x, alienMutated.x
  equal alien.y, alienMutated.y

test 'The VeryBadAlien class has a method to mutates a list of alien', ->
  veryBadAlien = new VeryBadAlien(54, 78)
  aliens= [new Alien(10, 13), veryBadAlien, new Alien(23, 34)]
  mutatedAliens = VeryBadAlien::mutates(aliens)
  equal mutatedAliens.length, 3
  ok mutatedAliens.every (alien) ->
    alien instanceof VeryBadAlien
  equal mutatedAliens[0].x, 10
  equal mutatedAliens[0].y, 13
  equal mutatedAliens[1], veryBadAlien
  equal mutatedAliens[2].x, 23
  equal mutatedAliens[2].y, 34

module 'class Ship.destroyAliens'
test 'The class Ship must have a method destroyAliens which decrease lives of n first aliens by 1, where n is the second parameters', ->
  ship = new Ship(10, 20)
  aliens = [new Alien(1, 1), new VeryBadAlien(1, 2), new Alien(1, 3)]
  ship.destroyAliens(aliens, 2)
  equal aliens[0].live, 0
  equal aliens[1].live, 1
  equal aliens[2].live, 1

test 'The class Ship must have a method destroyAliens which decrease lives of aliens by 1', ->
  ship = new Ship(10, 20)
  aliens = [new Alien(1, 1), new VeryBadAlien(1, 2), new Alien(1, 3)]
  ship.destroyAliens(aliens, 5)
  equal aliens[0].live, 0
  equal aliens[1].live, 1
  equal aliens[2].live, 0

test 'The class Ship must have a method isAlive which is true by default', ->
  ship = new Ship(10, 20)
  ok ship.isAlive()

test "The class Ship must have a method destroyAliens which destroy the ship if used more than 5 times", ->
  ship = new Ship(10, 20)
  aliens = []
  ship.destroyAliens(aliens, 5)
  ship.destroyAliens(aliens, 5)
  ship.destroyAliens(aliens, 5)
  ship.destroyAliens(aliens, 5)
  ok ship.isAlive()
  ship.destroyAliens(aliens, 5)
  ok !ship.isAlive()

module 'Projectile'
test 'There is a class projectile with 2 attributes x and y in the constructor, representing the top left position of the projectile', ->
  projectile = new Projectile(22, 33)
  equal projectile.x, 22
  equal projectile.y, 33

test 'There is a class Projectile, with 2 properties height and width', ->
  equal Projectile::width, 5
  equal Projectile::height, 10

test 'The class Ship has a method fire which create a new Projectile, and the coordinates of the projectile are centered on the ship', ->
  ship = new Ship(10, 80)
  projectile = ship.fire()
  ok projectile instanceof Projectile
  equal projectile.x, 30
  equal projectile.y, 80

test 'The class Projectile has a method move, which remove 10 to y coordinate', ->
  projectile = new Projectile(22, 33)
  projectile.move()
  equal projectile.y, 23
  equal projectile.x, 22

test 'There must be a method hasCollisionWith in the class projectile, colliding at left', ->
  projectile = new Projectile(100, 100)
  ok !projectile.hasCollisionWith new Alien(69, 10)
  ok !projectile.hasCollisionWith new Alien(71, 10)
  ok !projectile.hasCollisionWith new Alien(69, 100)
  ok projectile.hasCollisionWith new Alien(71, 100)

test 'There must be a method hasCollisionWith in the class projectile, colliding at right', ->
  projectile = new Projectile(100, 100)
  ok !projectile.hasCollisionWith new Alien(106, 10)
  ok !projectile.hasCollisionWith new Alien(104, 10)
  ok !projectile.hasCollisionWith new Alien(106, 100)
  ok projectile.hasCollisionWith new Alien(104, 100)

test 'There must be a method hasCollisionWith in the class projectile, colliding at top', ->
  projectile = new Projectile(100, 100)
  ok !projectile.hasCollisionWith new Alien(2, 69)
  ok !projectile.hasCollisionWith new Alien(2, 71)
  ok !projectile.hasCollisionWith new Alien(100, 69)
  ok projectile.hasCollisionWith new Alien(100, 71)

test 'There must be a method hasCollisionWith in the class projectile, colliding at bottom', ->
  projectile = new Projectile(100, 100)
  ok !projectile.hasCollisionWith new Alien(2, 111)
  ok !projectile.hasCollisionWith new Alien(2, 109)
  ok !projectile.hasCollisionWith new Alien(100, 111)
  ok projectile.hasCollisionWith new Alien(100, 109)

