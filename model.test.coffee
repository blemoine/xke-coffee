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
test 'There is a class Ship with 2 attributes x and y in the constructor', ->
  ship = new Ship(12, 34)
  equal ship.x, 12
  equal ship.y, 34

test 'There is a class Ship, with 2 properties width and height', ->
  equal Ship:: width, 40
  equal Ship:: height, 30

test 'The method moveLeft of class Ship change the x position of the ship', ->
  ship = new Ship(15, 23)
  ship.moveLeft 4
  equal ship.x, 5

test 'The method moveLeft of class Ship change the x position of the ship but no lower than the argument', ->
  ship = new Ship(15, 23)
  ship.moveLeft 9
  equal ship.x, 9

test 'The method moveRight of class Ship change the x position of the ship', ->
  ship = new Ship(15, 23)
  ship.moveRight 126
  equal ship.x, 25

test 'The method moveRight of class Ship change the x position of the ship, but no higher than the argument + the width', ->
  ship = new Ship(75, 23)
  ship.moveRight 123
  equal ship.x, 83


module 'Alien class'
test 'There is a class Alien, taking 2 attributes x and y in the constructor', ->
  alien = new Alien(34, 67)
  equal alien.x, 34
  equal alien.y, 67

test 'There is a class Alien, with 2 properties height and width', ->
  equal Alien:: width, 30
  equal Alien:: height, 30

test 'The value of an alien is 10 point', ->
  alien = new Alien(10, 23)
  equal alien.value, 10

test 'an instance of Alien have a default live of 1', ->
  alien = new Alien(12, 23)
  equal alien.live, 1

test 'The method decreaseLive of class Alien decrease the live counter', ->
  alien = new Alien(4, 6)
  alien.decreaseLive()
  equal alien.live, 0

test 'The method isAlive of class Alien return true if alien has more than 0 live ', ->
  alien = new Alien(4, 6)
  ok alien.isAlive()

test 'The method isAlive of class Alien return false if alien has 0 live ', ->
  alien = new Alien(4, 6)
  alien.live = 0
  ok !alien.isAlive()

test 'The method move of class Alien move only x if is between start and end', ->
  alien = new Alien(20, 20)
  alien.move(0, 500, 10, 5)
  equal alien.x, 30
  equal alien.y, 20

test 'The method move of class Alien move only y if is at end', ->
  alien = new Alien(20, 20)
  alien.move(0, 59, 10, 5)
  equal alien.x, 29
  equal alien.y, 25

test 'The method move of class Alien change the direction of x deplacement', ->
  alien = new Alien(20, 20)
  alien.move(0, 59, 10, 5)
  alien.move(0, 59, 10, 5)
  equal alien.x, 19
  equal alien.y, 25

test 'The method move of class Alien change move y if at start position', ->
  alien = new Alien(1, 20)
  alien.move(0, 41, 10, 5)
  alien.move(0, 41, 10, 5)
  alien.move(0, 41, 10, 5)
  alien.move(0, 41, 10, 5)
  equal alien.x, 0
  equal alien.y, 30

test 'The method move of class Alien invert a second time direction of x offset', ->
  alien = new Alien(1, 20)
  alien.move(0, 41, 10, 5)
  alien.move(0, 41, 10, 5)
  alien.move(0, 41, 10, 5)
  alien.move(0, 41, 10, 5)
  alien.move(0, 41, 10, 5)
  equal alien.x, 10
  equal alien.y, 30


module 'VeryBadAlien'
test 'There is a class VeryBadAlien which extend Alien and take an alien in the constructor', ->
  veryBadAlien = new VeryBadAlien(new Alien(23, 45))
  ok veryBadAlien instanceof Alien
  equal veryBadAlien.x, 23
  equal veryBadAlien.y, 45

test 'A new instance of VeryBadAlien has 2 lives', ->
  veryBadAlien = new VeryBadAlien(new Alien(23, 45))
  equal veryBadAlien.live, 2

test 'The value of an veryBadAlien is 25 point', ->
  veryBadAlien = new VeryBadAlien(new Alien(10, 23))
  equal veryBadAlien.value, 25

test 'A new instance of VeryBadAlien goes to the same direction as the original alien', ->
  alien = new Alien(20, 20)
  alien.move(0, 59, 10, 5)
  alien.move(0, 59, 10, 5)
  veryBadAlien = new VeryBadAlien(alien)
  veryBadAlien.move(0, 59, 10, 5)
  equal veryBadAlien.x, 9
  equal veryBadAlien.y, 25

test 'A VeryBadAlien has a method mutate which return the current instance of VeryBadAlien', ->
  veryBadAlien = new VeryBadAlien(new Alien(10, 13))
  equal veryBadAlien.mutate(), veryBadAlien

test 'An alien has a method mutate which return the corresponding VeryBadAlien', ->
  alien = new Alien(10, 13)
  alienMutated = alien.mutate()
  ok alienMutated instanceof VeryBadAlien
  equal alien.x, alienMutated.x
  equal alien.y, alienMutated.y

test 'The VeryBadAlien class has a method to mutates a list of alien', ->
  veryBadAlien = new VeryBadAlien(new Alien(54, 78))
  aliens= [new Alien(10, 13), veryBadAlien, new Alien(23, 34)]
  mutatedAliens = VeryBadAlien:: mutates(aliens)
  equal mutatedAliens.length, 3
  ok mutatedAliens.every (alien) -> alien instanceof VeryBadAlien
  equal mutatedAliens[0].x, 10
  equal mutatedAliens[0].y, 13
  equal mutatedAliens[1], veryBadAlien
  equal mutatedAliens[2].x, 23
  equal mutatedAliens[2].y, 34