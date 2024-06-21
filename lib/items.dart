import 'characters.dart';
import 'player.dart';

abstract class Item {
  int uses = 1;
  late int basePrice;
  late String name;

  void use(Player player, Character targetCharacter); // sole abstract method
  void incrementUses() => uses++;
  void _decrementUses(Player player) {
    uses--;

    /// will just change [item.name] to null, let inventory code do the deletion
    if (uses == 0) {
      print("${name} has been fully depleted!");
      player.inventory.remove(this);
    }
  }

  @override
  String toString() => name;

  Item(this.name, this.basePrice);
}

class HealingItem extends Item {
  int healAmount = 0;

  HealingItem(super.name, super.basePrice, this.healAmount);

  @override
  void use(Player player, Character targetCharacter) {
    targetCharacter.health += healAmount;
    _decrementUses(player);
  }

  @override
  String toString() => "$name[+$healAmount HP]";
}
