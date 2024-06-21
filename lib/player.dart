import 'dart:io';
import 'characters.dart';
import 'items.dart';

class Player {
  int gold = 50;

  // party system with default party members
  List<Character> _bench = []; // benched characters should be privated
  List<Character> party = [getNewCharacter("Knight")];

  void _showCharacters(List<Character> characterlist) {
    for (int i = 0; i < characterlist.length; i++) {
      // index shown starts at 1
      print("${i + 1}. ${characterlist[i]}");
    }
  }

  bool _hasNoCharacters(List<Character> characterlist) {
    if (characterlist.length == 0) {
      print("There are no more characters!");
      return true;
    }
    return false;
  }

  void addPartyMember() {
    if (_hasNoCharacters(_bench)) return;

    print("Select which benched character to add to party:");
    _showCharacters(_bench);
    String input = stdin.readLineSync().toString();
    int? parsedInput = int.tryParse(input);
    if (parsedInput != null && parsedInput <= _bench.length) {
      Character targetCharacter = _bench[parsedInput - 1];
      _bench.removeAt(parsedInput - 1); // removing targetCharacter
      party.add(targetCharacter);
    }
  }

  void removePartyMember() {
    if (_hasNoCharacters(party)) return;

    print("Select which party member to remove:");
    _showCharacters(party);
    String input = stdin.readLineSync().toString();
    int? parsedInput = int.tryParse(input);
    if (parsedInput != null && parsedInput <= party.length) {
      Character targetCharacter = party[parsedInput - 1];
      party.removeAt(parsedInput - 1); // removing targetCharacter
      _bench.add(targetCharacter);
    }
  }

  // inventory system
  List<Item> inventory = [];

  void openInventory() {
    for (int i = 0; i < inventory.length; i++) {
      print("${i + 1}. ${inventory[i]} (${inventory[i].uses})");
    }
  }

  // has anti duplication feature
  void addToIventory(Item item) {
    if (inventory.contains(item)) {
      inventory[inventory.indexOf(item)].uses++;
    } else {
      /// every new item starts at [item.uses = 1]
      inventory.add(item);
      item.uses = 1;
    }
  }

  void removeFromInventory(Item item) {
    if (inventory.contains(item)) inventory.remove(item);
  }
}
