import {
  map,
  rule,
  writeToProfile,
  mapSimultaneous,
  toKey,
  toSetVar,
  withCondition,
} from "karabiner.ts";

import {
  hyperKey,
  hyperMode,
  key1,
  key2,
  key3,
  key4,
  key23,
  key24,
  key34,
  key234,
} from "./const";

writeToProfile(
  "homerow",
  [
    // Map Caps Lock to Escape
    rule("Caps Lock to Escape").manipulators([
      map("caps_lock").to(toKey("escape")),
    ]),

    // Right Cmd as Hyper
    rule("Right Cmd as Hyper").manipulators([
      map("right_command")
        .toVar(hyperMode, 1)
        .to(hyperKey)
        .toAfterKeyUp(toSetVar(hyperMode, 0)),
    ]),

    // Home row mods
    rule("Home row mods - shift, ctrl, opt, cmd").manipulators([
      withCondition({
        type: "variable_unless",
        name: hyperMode,
        value: 1,
      })([
        //
        // Four - left hand
        mapSimultaneous(["a", "s", "d", "f"]).toIfHeldDown(`l${key1}`, [
          `l${key234}`,
        ]),
        //
        // Three - left hand
        mapSimultaneous(["a", "s", "d"]).toIfHeldDown(`l${key1}`, [
          `l${key23}`,
        ]),
        mapSimultaneous(["a", "s", "f"]).toIfHeldDown(`l${key1}`, [
          `l${key24}`,
        ]),
        mapSimultaneous(["a", "d", "f"]).toIfHeldDown(`l${key1}`, [
          `l${key34}`,
        ]),
        mapSimultaneous(["s", "d", "f"]).toIfHeldDown(`l${key2}`, [
          `l${key34}`,
        ]),
        //
        // Two - left hand
        mapSimultaneous(["a", "s"], { key_down_order: "strict" })
          .toIfAlone("a")
          .toIfAlone("s")
          .toIfHeldDown(`l${key1}`, `l${key2}`),
        mapSimultaneous(["s", "a"], { key_down_order: "strict" })
          .toIfAlone("s")
          .toIfAlone("a")
          .toIfHeldDown(`l${key1}`, `l${key2}`),
        mapSimultaneous(["a", "d"], { key_down_order: "strict" })
          .toIfAlone("a")
          .toIfAlone("d")
          .toIfHeldDown(`l${key1}`, `l${key3}`),
        mapSimultaneous(["d", "a"], { key_down_order: "strict" })
          .toIfAlone("d")
          .toIfAlone("a")
          .toIfHeldDown(`l${key1}`, `l${key3}`),
        mapSimultaneous(["a", "f"], { key_down_order: "strict" })
          .toIfAlone("a")
          .toIfAlone("f")
          .toIfHeldDown(`l${key1}`, `l${key4}`),
        mapSimultaneous(["f", "a"], { key_down_order: "strict" })
          .toIfAlone("f")
          .toIfAlone("a")
          .toIfHeldDown(`l${key1}`, `l${key4}`),
        mapSimultaneous(["s", "d"], { key_down_order: "strict" })
          .toIfAlone("s")
          .toIfAlone("d")
          .toIfHeldDown(`l${key2}`, `l${key3}`),
        mapSimultaneous(["d", "s"], { key_down_order: "strict" })
          .toIfAlone("d")
          .toIfAlone("s")
          .toIfHeldDown(`l${key2}`, `l${key3}`),
        mapSimultaneous(["s", "f"], { key_down_order: "strict" })
          .toIfAlone("s")
          .toIfAlone("f")
          .toIfHeldDown(`l${key2}`, `l${key4}`),
        mapSimultaneous(["f", "s"], { key_down_order: "strict" })
          .toIfAlone("f")
          .toIfAlone("s")
          .toIfHeldDown(`l${key2}`, `l${key4}`),
        mapSimultaneous(["d", "f"], { key_down_order: "strict" })
          .toIfAlone("d")
          .toIfAlone("f")
          .toIfHeldDown(`l${key3}`, `l${key4}`),
        mapSimultaneous(["f", "d"], { key_down_order: "strict" })
          .toIfAlone("f")
          .toIfAlone("d")
          .toIfHeldDown(`l${key3}`, `l${key4}`),
        //
        // One - left hand
        map("a")
          .toIfAlone("a", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("a"))
          .toIfHeldDown(`l${key1}`, {}, { halt: true }),
        map("s")
          .toIfAlone("s", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("s"))
          .toIfHeldDown(`l${key2}`, {}, { halt: true }),
        map("d")
          .toIfAlone("d", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("d"))
          .toIfHeldDown(`l${key3}`, {}, { halt: true }),
        map("f")
          .toIfAlone("f", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("f", {}, { halt: true }))
          .toIfHeldDown(`l${key4}`, {}, { halt: true }),
        //
        //
        // Four - right hand
        mapSimultaneous(["j", "k", "l", ";"]).toIfHeldDown(`r${key1}`, [
          `r${key234}`,
        ]),
        //
        // Three - right hand
        mapSimultaneous([";", "l", "k"]).toIfHeldDown(`r${key1}`, [
          `r${key23}`,
        ]),
        mapSimultaneous([";", "l", "j"]).toIfHeldDown(`r${key1}`, [
          `r${key24}`,
        ]),
        mapSimultaneous([";", "k", "j"]).toIfHeldDown(`r${key1}`, [
          `r${key34}`,
        ]),
        mapSimultaneous(["l", "k", "j"]).toIfHeldDown(`r${key2}`, [
          `r${key34}`,
        ]),
        //
        // Two - right hand
        mapSimultaneous([";", "l"], { key_down_order: "strict" })
          .toIfAlone(";")
          .toIfAlone("l")
          .toIfHeldDown(`r${key1}`, `r${key2}`),
        mapSimultaneous(["l", ";"], { key_down_order: "strict" })
          .toIfAlone("l")
          .toIfAlone(";")
          .toIfHeldDown(`r${key1}`, `r${key2}`),
        mapSimultaneous([";", "k"], { key_down_order: "strict" })
          .toIfAlone(";")
          .toIfAlone("k")
          .toIfHeldDown(`r${key1}`, `r${key3}`),
        mapSimultaneous(["k", ";"], { key_down_order: "strict" })
          .toIfAlone("k")
          .toIfAlone(";")
          .toIfHeldDown(`r${key1}`, `r${key3}`),
        mapSimultaneous([";", "j"], { key_down_order: "strict" })
          .toIfAlone(";")
          .toIfAlone("j")
          .toIfHeldDown(`r${key1}`, `r${key4}`),
        mapSimultaneous(["j", ";"], { key_down_order: "strict" })
          .toIfAlone("j")
          .toIfAlone(";")
          .toIfHeldDown(`r${key1}`, `r${key4}`),
        mapSimultaneous(["l", "k"], { key_down_order: "strict" })
          .toIfAlone("l")
          .toIfAlone("k")
          .toIfHeldDown(`r${key2}`, `r${key3}`),
        mapSimultaneous(["k", "l"], { key_down_order: "strict" })
          .toIfAlone("k")
          .toIfAlone("l")
          .toIfHeldDown(`r${key2}`, `r${key3}`),
        mapSimultaneous(["l", "j"], { key_down_order: "strict" })
          .toIfAlone("l")
          .toIfAlone("j")
          .toIfHeldDown(`r${key2}`, `r${key4}`),
        mapSimultaneous(["j", "l"], { key_down_order: "strict" })
          .toIfAlone("j")
          .toIfAlone("l")
          .toIfHeldDown(`r${key2}`, `r${key4}`),
        mapSimultaneous(["k", "j"], { key_down_order: "strict" })
          .toIfAlone("k")
          .toIfAlone("j")
          .toIfHeldDown(`r${key3}`, `r${key4}`),
        mapSimultaneous(["j", "k"], { key_down_order: "strict" })
          .toIfAlone("j")
          .toIfAlone("k")
          .toIfHeldDown(`r${key3}`, `r${key4}`),
        //
        // One - right hand
        map(";")
          .toIfAlone(";", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey(";"))
          .toIfHeldDown(`r${key1}`, {}, { halt: true }),
        map("l")
          .toIfAlone("l", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("l"))
          .toIfHeldDown(`r${key2}`, {}, { halt: true }),
        map("k")
          .toIfAlone("k", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("k"))
          .toIfHeldDown(`r${key3}`, {}, { halt: true }),
        map("j")
          .toIfAlone("j", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("j"))
          .toIfHeldDown(`r${key4}`, {}, { halt: true }),
      ]),
    ]),
    //
    // Meh
    rule("R_U = Meh ").manipulators([
      withCondition({
        type: "variable_unless",
        name: hyperMode,
        value: 1,
      })([
        map("r")
          .toIfAlone("r", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("r"))
          .toIfHeldDown(`l${key1}`, `l${key23}`, { halt: true })
          .parameters({ "basic.to_if_held_down_threshold_milliseconds": 220 }),
        map("u")
          .toIfAlone("u", {}, { halt: true })
          .toDelayedAction(toKey("vk_none"), toKey("u"))
          .toIfHeldDown(`r${key1}`, `r${key23}`, { halt: true })
          .parameters({ "basic.to_if_held_down_threshold_milliseconds": 220 }),
      ]),
    ]),
  ],

  {
    "basic.to_if_held_down_threshold_milliseconds": 250,
  },
);
