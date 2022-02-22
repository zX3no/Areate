<h1 align="center" style="font-size: 55px">Areate</h1>

<div align="center" style="display:inline">
      <img src="media/1.jpg" width="49%">
      <img src="media/2.jpg" width="49%">
</div>
<div align="center" style="display:inline">
      <img src="media/3.jpg" width="49%">
      <img src="media/4.jpg" width="49%">
</div>


I would like some nicer pictures here ^

Screenshots of Areate inside the editor

what is printl( scope.userid )?

update the map to work with the new files names | hammer is currently not opening (thanks valve)

I want to change from CamelCase to snake_case in my scripts.

## Scripts
```
📦vscripts
 ┣ 📜main.nut
 ┣ 📜globals.nut
 ┣ 📜vs_eventlistener.nut
 ┣ 📜vs_events.nut
 ┗ 📜vs_library.nut
 ```

### main.nut

Called from hammer with a Script Node?

Entry point which handles most of the logic.

#### Callbacks

- round_start
  - If it's round 0 the help menu is printed
  - Bots will be kicked each round if they're not enabled.
  - Iterate over every player and give them their weapons.
  - A new player class will be created if their id hasn't been assigned to one.

- player_say
  - Parses the players input and executes the corresponding commands

### globals.nut

Holds the state of the players while the server is running.

This is possible due to some hack using the `rope magic`. Whatever that means.

### vs_eventlistener | vs_events | vs_library

Used for listening to in-game events.
The library can be found at [samisalreadytaken/vs_library](https://github.com/samisalreadytaken/vs_library).

I may be using an old version of this library so things may be different.

## Commands

> ❗ All chat commands start with an exclamation mark

> ❗ Commands have many abbreviations, you can find them [here](vscripts/ChatCommands.nut#L96).

| Command     | Function                                  | Parameters                                    | Example    |
|-------------|-------------------------------------------|-----------------------------------------------|------------|
| weapon/w    | Gives the player any weapon               | [Weapon Name](vscripts/ChatCommands.nut#L313) | !w m4a4    |
| random/r    | Randomizes the weapons given              | Primary, Secondary, Knife, Competitive        | !r primary |
| armor       | Toggles armor                             |                                               |            |
| headshot/hs | Toggles headshot only                     |                                               |            |
| bumpmines/b | Gives bumpmines at the start of the round |                                               |            |
| bot         | Toggles bots                              |                                               |            |
| reset       | Legacy command to fix userid errors       |                                               |            |

## Adding to your map
