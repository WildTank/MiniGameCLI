import 'dart:io';
import 'dart:math';
import 'player.dart';
import 'characters.dart';

int totalEncounters = 0;
int stageCount = 1;
int multiplier = 1;
int turn = 1;
bool retreat = false;

void startAdventure(Player player) {
  if (player.party.length == 0)
    return print("You have no characters in your party!");
  // more characters
  switch (stageCount) {
    case 10: // archer
      print("You see a person on the ground by the enemy...");
    case 20: // tank
      print("The enemies seem to be guarding a huge boulder...");
    case 30: // wizard
      print("You a white bubble surrounded by the enemy...");
  }
  totalEncounters++;
  initiateEncounter(player);
}

void initiateEncounter(Player player) {
  List<Character> allyTeam = [...player.party];
  List<Character> enemyTeam = [];
  enemyTeam = generateEnemyTeam(enemyTeam);
  // healing all player party members back to full
  // CANNOT be placed at the end of encounter because characters are removed
  // from encounter player party when dead (will not be permanently removed)
  for (Character c in allyTeam) {
    c.health = c.maxHealth;
  }
  // start of combat loop
  turn = 1;
  while (enemyTeam.length > 0 && allyTeam.length > 0) {
    // printing battlefield, enemy side first
    print("Stage: $stageCount, Multiplier: $multiplier, Turn: $turn");
    String line = "";
    Character character;
    for (int i = 6; i > 0; i--) {
      if (i <= enemyTeam.length) {
        character = enemyTeam[i - 1];
        line = line + " [$i]$character(${character.health})";
      } else {
        line = line + " [$i]";
      }
      if (i == 4) {
        print(line);
        line = "";
      }
    }
    print(line + "\n");
    // ally side is MIRRORED relative to enemy side
    line = "";
    for (int i = 0; i < 6; i++) {
      if (i < allyTeam.length) {
        character = allyTeam[i];
        line = line + " [${i + 1}]$character(${character.health})";
      } else {
        line = line + " [${i + 1}]";
      }
      if (i == 2) {
        print(line);
        line = "";
      }
    }
    print(line);
    // character actions, player moves first
    for (Character c in allyTeam) {
      allyTurn(player, c, enemyTeam);
      if (retreat) {
        retreat = false;
        return;
      }
      if (enemyTeam.length == 0) break;
    }
    for (Character c in enemyTeam) {
      enemyTurn(c, allyTeam);
      if (allyTeam.length == 0) break;
    }
    turn++;
  } // end of combat loop
  if (allyTeam.length == 0) {
    print("You lost!");
    quitFunctionUsingNever();
  } else {
    int additionalGold = 10 * multiplier;
    print("Congratulations, Gained $additionalGold gold!");
    player.gold += additionalGold;
    // extra characters
    switch (stageCount) {
      case 10:
        print(
            "You looked for and nursed the person... Archer has joined your party!");
        player.party.add(getNewCharacter("Archer"));
      case 20:
        print(
            "The towering boulder was a human! Tank has joined your party...");
        player.party.add(getNewCharacter("Tank"));
      case 30:
        print("The white bubble was barrier magic! Wizard has joined your party...");
        player.party.add(getNewCharacter("Wizard"));
    }
    stageCount++;
    multiplier = 1 + stageCount ~/ 10;
  }
}

void allyTurn(Player player, Character ally, List<Character> enemyTeam) {
  print("$ally: (1-6) Attack, (S) Items${turn == 1 ? ", (D) Retreat" : ""}");
  dynamic input = stdin.readLineSync().toString().toUpperCase();
  // attack
  int? parsedInput = int.tryParse(input);
  if (parsedInput != null) {
    ally.attack(ally, parsedInput, enemyTeam);
    return;
  };
  // other actions
  switch (input) {
    case "S":
      print("Select which item to use:");
      player.openInventory();
      String input = stdin.readLineSync().toString();
      int? parsedInput = int.tryParse(input);
      if (parsedInput != null &&
          parsedInput > 0 &&
          parsedInput <= player.inventory.length) {
        player.inventory[parsedInput - 1].use(player, ally);
      }
    case "D":
      if (turn > 1) return; // can only retreat on initial turn in an encounter
      retreat = true;
  }
}

void enemyTurn(Character enemy, List<Character> allyTeam) {
  int randomIndex = Random().nextInt(5) + 1;
  enemy.attack(enemy, randomIndex, allyTeam);
}

// list of enemies
/// for the enemy rng system, iterate through the following map ([enemies]) in REVERSE
// the default enemy to fall back to is the slime with a 100% pick rate from the start
const List<Map> enemies = [
  // the integer in the list is the chance for the correponding enemy to be picked
  {"Name": "Slime", "Chance": 100},
  {"Name": "Skeleton", "Chance": 50},
  {"Name": "Dark Elf", "Chance": 30},
  {"Name": "Golem", "Chance": 15},
  {"Name": "Orc", "Chance": 10},
  {"Name": "Demon Lord", "Chance": 5}
];

// the amount of enemies and the type of enemies to be selected are based on stage number
Character getRandomEnemy() {
  int randomNum = Random().nextInt(99) + 1; // rng: 1 - 100
  // reverse iteration
  for (int i = enemies.length - 1; i >= 0; i--) {
    int totalChance = enemies[i]["Chance"] * multiplier;
    if (randomNum <= totalChance) return getNewEnemy(enemies[i]["Name"]);
  }
  // defaults to slime in case something breaks
  return getNewEnemy("Slime");
}

/// there will a number generator that outputs: 0 - [enemies.length()]
List<Character> generateEnemyTeam(List<Character> enemyTeam) {
  int numOfEnemies = Random().nextInt(multiplier + 2) + multiplier;
  if (numOfEnemies > 6) numOfEnemies = 6; // num of enemies has a limit of 6
  for (int i = 0; i < numOfEnemies; i++) {
    Character enemy = getRandomEnemy();
    enemyTeam.add(enemy);
  }
  return enemyTeam;
}

/// lose: trying out [Never] type
Never quitFunctionUsingNever() {
  exit(0);
}