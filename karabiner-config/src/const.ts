import {
  Modifier,
  ModifierKeyAlias,
  NamedMultiModifierAlias,
  modifierKeyAliases,
  multiModifierAliases,
} from "karabiner.ts";

// Defined and explained in hammerspoon/hyper/init.lua
export const hyperKey = "f18";
export const hyperMode = "hyper-mode";

// Will be used in the Karabiner rules
export const shiftKey: ModifierKeyAlias = "⇧";
export const ctrlKey: ModifierKeyAlias = "⌃";
export const optKey: ModifierKeyAlias = "⌥";
export const cmdKey: ModifierKeyAlias = "⌘";

// Needed to resolve key names for the multi-modifier cases
export const shiftName: Modifier = modifierKeyAliases[shiftKey];
export const ctrlName: Modifier = modifierKeyAliases[ctrlKey];
export const optName: Modifier = modifierKeyAliases[optKey];
export const cmdName: Modifier = modifierKeyAliases[cmdKey];

// Layout setup:
// GACS (Miryoku): https://precondition.github.io/home-row-mods#gacs
export const { key1, key1Name } = { key1: cmdKey, key1Name: cmdName };
export const { key2, key2Name } = { key2: optKey, key2Name: optName };
export const { key3, key3Name } = { key3: ctrlKey, key3Name: ctrlName };
export const { key4, key4Name } = { key4: shiftKey, key4Name: shiftName };

// Build aliases for multi-modifier keys

function getKeysByNames(
  keys: string[],
): Exclude<keyof typeof multiModifierAliases, NamedMultiModifierAlias> {
  // multiModifierAliases force us to use ordered hard-coded keys

  const sortedKeys = keys.sort().join("");

  for (const [alias, aliasKeys] of Object.entries(multiModifierAliases)) {
    if (aliasKeys.sort().join("") === sortedKeys) {
      return alias as Exclude<
        keyof typeof multiModifierAliases,
        NamedMultiModifierAlias
      >;
    }
  }

  throw new Error(`Alias not found for keys: ${keys.join(", ")}`);
}

export const key23 = getKeysByNames([key2Name, key3Name]);
export const key24 = getKeysByNames([key2Name, key4Name]);
export const key34 = getKeysByNames([key3Name, key4Name]);
export const key234 = getKeysByNames([key2Name, key3Name, key4Name]);
