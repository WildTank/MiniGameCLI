import 'dart:io';
import './lib/player.dart';
import './lib/shop.dart';
import './lib/adventure.dart';

Player currentPlayer = Player(); // player is top level object

main() {
  // this serves as the main menu
  while (true) {
    print("\n\nCurrent Stage: $stageCount, Total Encounters: $totalEncounters");
    print("Main Menu: (A) Adventure, (S) Shop, (D) Party, (F) Inventory");
    String input = stdin.readLineSync().toString().toUpperCase();
    switch (input) {
      case "A":
        startAdventure(currentPlayer);
      case "S":
        openShop();
      case "D":
        checkParty();
      case "F":
        currentPlayer.openInventory();
    }
  }
}

// simpler ones go first
// checking party
checkParty() {
  while (true) {
    print("\n\nParty: (A) Add, (S) Remove, (D) Menu");
    print(currentPlayer.party);
    String input = stdin.readLineSync().toString().toUpperCase();
    switch (input) {
      case "A":
        currentPlayer.addPartyMember();
      case "S":
        currentPlayer.removePartyMember();
      case "D":
        return;
    }
  }
}

// shop
openShop() {
  while (true) {
    print("\n\nShop: (A) Buy, (S) Sell, (D) Menu");
    print("Gold = ${currentPlayer.gold}");
    String input = stdin.readLineSync().toString().toUpperCase();
    switch (input) {
      case "A":
        print("Select which item to buy:");
        mainShop.showItemsOnSale();
        String input = stdin.readLineSync().toString();
        int? parsedInput = int.tryParse(input);
        if (parsedInput != null) {
          mainShop.buyItem(currentPlayer, parsedInput);
        }
      case "S":
        print("Select which item to sell:");
        currentPlayer.openInventory();
        String input = stdin.readLineSync().toString();
        int? parsedInput = int.tryParse(input);
        if (parsedInput != null) {
          mainShop.sellItem(currentPlayer, parsedInput);
        }
      case "D":
        return;
    }
  }
}