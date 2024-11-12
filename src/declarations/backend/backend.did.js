export const idlFactory = ({ IDL }) => {
  const ShoppingItem = IDL.Record({
    'id' : IDL.Nat,
    'text' : IDL.Text,
    'completed' : IDL.Bool,
  });
  return IDL.Service({
    'addItem' : IDL.Func([IDL.Text], [ShoppingItem], []),
    'deleteItem' : IDL.Func([IDL.Nat], [IDL.Bool], []),
    'getAllItems' : IDL.Func([], [IDL.Vec(ShoppingItem)], ['query']),
    'toggleItem' : IDL.Func([IDL.Nat], [IDL.Opt(ShoppingItem)], []),
  });
};
export const init = ({ IDL }) => { return []; };
