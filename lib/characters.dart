// could've used this as an interface instead of a parent class
abstract class Character {
  late String name;
  late int maxHealth;
  late int health;
  late int damage;

  void attack(
      Character character, int targetIndex, List<Character> targetTeam);

  @override
  String toString() => name;
}

Character getNewCharacter(String characterName) {
  switch (characterName) {
    case "Knight":
      return _Knight();
    case "Archer":
      return _Archer();
    case "Tank":
      return _Tank();
    case "Wizard":
      return _Wizard();
    default:
      print("Requesting unknown character, defaulting to knight...");
      return _Knight();
  }
}

Character getNewEnemy(String enemyName) {
  switch (enemyName) {
    case "Slime":
      return _Slime();
    case "Skeleton":
      return _Skeleton();
    case "Dark Elf":
      return _DarkElf();
    case "Golem":
      return _Golem();
    case "Orc":
      return _Orc();
    case "Demon Lord":
      return _DemonLord();
    default:
      print("Requesting unknown enemy, defaulting to slime...");
      return _Slime();
  }
}

mixin frontLineReach {
  void attack(Character character, int oneToThree, List<Character> targetTeam) {
    if (oneToThree < 1 || oneToThree > 3 || oneToThree > targetTeam.length) {
      oneToThree = 1;
    }
    Character targetCharacter = targetTeam[oneToThree - 1];
    targetCharacter.health -= character.damage;
    if (targetCharacter.health <= 0) targetTeam.remove(targetCharacter);
  }
}

// could have found a way to mix this with frontline reach
// but this results in a much more readable code
/// Sample: [class _Wizard extends Character with backLineReach]
mixin backLineReach {
  void attack(Character character, int oneToSix, List<Character> targetTeam) {
    if (oneToSix < 1 || oneToSix > 6 || oneToSix > targetTeam.length) {
      oneToSix = 1;
    }
    Character targetCharacter = targetTeam[oneToSix - 1];
    targetCharacter.health -= character.damage;
    if (targetCharacter.health <= 0) targetTeam.remove(targetCharacter);
  }
}

// characters

class _Knight extends Character with frontLineReach {
  _Knight() {
    super.name = "Knight";
    // following code is redundant: this is for uniformity and readability
    super.maxHealth = 100;
    super.health = 100;
    super.damage = 10;
  }
}

class _Archer extends Character with backLineReach {
  _Archer() {
    super.name = "Archer";
    super.maxHealth = 50;
    super.health = 50;
    super.damage = 5;
  }
}

class _Tank extends Character with frontLineReach {
  _Tank() {
    super.name = "Tank";
    super.maxHealth = 150;
    super.health = 150;
    super.damage = 5;
  }
}

class _Wizard extends Character with backLineReach {
  _Wizard() {
    super.name = "Wizard";
    super.maxHealth = 75;
    super.maxHealth = 75;
    super.damage = 10;
  }
}

// enemies
/// NOTE: Enemies do NOT need to have [super.maxHealth] set, but I still put it anyways

class _Slime extends Character with frontLineReach {
  _Slime() {
    super.name = "Slime";
    super.maxHealth = 20;
    super.health = 20;
    super.damage = 5;
  }
}

class _Skeleton extends Character with frontLineReach {
  _Skeleton() {
    super.name = "Skeleton";
    super.maxHealth = 50;
    super.health = 50;
    super.damage = 10;
  }
}

class _DarkElf extends Character with backLineReach {
  _DarkElf() {
    super.name = "Dark Elf";
    super.maxHealth = 50;
    super.health = 50;
    super.damage = 5;
  }
}

class _Golem extends Character with frontLineReach {
  _Golem() {
    super.name = "Golem";
    super.maxHealth = 150;
    super.health = 150;
    super.damage = 5;
  }
}

class _Orc extends Character with frontLineReach {
  _Orc() {
    super.name = "Orc";
    super.maxHealth = 75;
    super.health = 75;
    super.damage = 10;
  }
}

class _DemonLord extends Character with backLineReach {
  _DemonLord() {
    super.name = "Demon Lord";
    super.maxHealth = 125;
    super.health = 125;
    super.damage = 15;
  }
}
