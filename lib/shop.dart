import 'items.dart';
import 'player.dart';

Shop mainShop = Shop([
  // list of items to be on sale
  HealingItem("Berry", 10, 15),
  HealingItem("Vegetable Soup", 30, 40),
  HealingItem("Health Potion", 50, 60),
  HealingItem("Elixir of Life", 100, 100)
]);

class Shop {
  List<Item> _stock = [];

  void showItemsOnSale() {
    int startingIndex = 1;
    for (Item i in _stock) {
      print("${startingIndex}. $i - ${i.basePrice} Gold");
      startingIndex++;
    }
  }

  void buyItem(Player player, int relativeIndex) {
    if (relativeIndex > 0 && relativeIndex <= _stock.length) {
      Item targetItem = _stock[relativeIndex - 1];
      if (player.gold < targetItem.basePrice) {
        print("Not enough gold to buy selected item!");
      } else {
        print("Bought item: $targetItem");
        player.gold -= targetItem.basePrice;
        player.addToIventory(targetItem);
      }
    }
  }

  void sellItem(Player player, int relativeIndex) {
    if (relativeIndex > 0 && relativeIndex <= player.inventory.length) {
      Item targetItem = player.inventory[relativeIndex - 1];
      print("Sold item: $targetItem");
      player.gold += (targetItem.basePrice ~/ 2);
      targetItem.uses--;
      if (targetItem.uses == 0) {
        player.inventory.remove(targetItem);
      };
    }
  }

  Shop(this._stock);
}
