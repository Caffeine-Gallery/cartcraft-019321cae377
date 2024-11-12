import Bool "mo:base/Bool";

import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";

actor {
    // Type definition for a shopping list item
    public type ShoppingItem = {
        id: Nat;
        text: Text;
        completed: Bool;
    };

    private stable var nextId: Nat = 0;
    private stable var itemsEntries: [(Nat, ShoppingItem)] = [];
    
    // Initialize HashMap with stable items
    private var items = HashMap.HashMap<Nat, ShoppingItem>(
        10, 
        Nat.equal, 
        Hash.hash
    );

    // System functions for upgrades
    system func preupgrade() {
        itemsEntries := Iter.toArray(items.entries());
    };

    system func postupgrade() {
        items := HashMap.fromIter<Nat, ShoppingItem>(
            itemsEntries.vals(),
            10,
            Nat.equal,
            Hash.hash
        );
        itemsEntries := [];
    };

    // Add a new shopping item
    public func addItem(text: Text) : async ShoppingItem {
        let id = nextId;
        nextId += 1;
        
        let item: ShoppingItem = {
            id;
            text;
            completed = false;
        };
        
        items.put(id, item);
        return item;
    };

    // Get all shopping items
    public query func getAllItems() : async [ShoppingItem] {
        Iter.toArray(items.vals())
    };

    // Toggle item completion status
    public func toggleItem(id: Nat) : async ?ShoppingItem {
        switch (items.get(id)) {
            case (null) { null };
            case (?item) {
                let updatedItem: ShoppingItem = {
                    id = item.id;
                    text = item.text;
                    completed = not item.completed;
                };
                items.put(id, updatedItem);
                ?updatedItem
            };
        };
    };

    // Delete an item
    public func deleteItem(id: Nat) : async Bool {
        switch (items.remove(id)) {
            case (null) { false };
            case (?_) { true };
        };
    };
}
