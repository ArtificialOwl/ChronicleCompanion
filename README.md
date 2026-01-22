# ChronicleCompanion

A World of Warcraft addon that enhances combat logging with additional unit metadata for use with [Chronicle](https://github.com/Emyrk/chronicle).

Upload your enriched combat logs at [chronicleclassic.com](https://chronicleclassic.com).

## Features

- **Extended Unit Tracking** — Automatically logs unit GUIDs, names, levels, owners (for pets/minions), and buff information to your combat log
- **Challenge Mode Detection** — Detects and logs player challenge modes (Hardcore, Level One Lunatic, Exhaustion, etc.)
- **Combat Log Reminder** — When entering/exiting instances, the addon will remind you to turn on/off combat logging.

## Requirements

- [SuperWoW](https://github.com/balakethelock/SuperWoW) — Required for extended API functions
- [SuperWowCombatLogger](https://github.com/pepopo978/SuperWowCombatLogger) — Required dependency for combat log additions

## Installation

1. Download the latest release
2. Extract to your `Interface/AddOns/` folder
3. Ensure the folder is named `ChronicleCompanion`
4. Restart WoW

## Usage

ChronicleCompanion works automatically when combat logging is enabled. It intercepts combat log events and enriches them with additional unit metadata.

### Slash Commands

| Command           | Description                 |
| ----------------- | --------------------------- |
| `/chronicle help` | Show all available commands |

You can also use `/chron` as a shorthand.

## Logged Data Format

The addon appends `UNIT_INFO` lines to your combat log with the following format:

```
UNIT_INFO: <timestamp>&<guid>&<is_player>&<name>&<can_cooperate>&<owner_guid>&<buffs>&<level>&<challenges>
```

| Field           | Description                                                         |
| --------------- | ------------------------------------------------------------------- |
| `timestamp`     | Date/time in `DD.MM.YY HH:MM:SS` format                             |
| `guid`          | Unit's unique identifier (e.g., `0x0000000000001234`)               |
| `is_player`     | `1` if this is the player, `0` otherwise                            |
| `name`          | Unit name                                                           |
| `can_cooperate` | `1` if friendly, `0` if hostile                                     |
| `owner_guid`    | Owner's GUID for pets/minions, empty otherwise                      |
| `buffs`         | Comma-separated buff IDs with stack counts (e.g., `,1234=2,5678=1`) |
| `level`         | Unit level                                                          |
| `challenges`    | Player challenge modes (comma-separated) or `na`                    |

## Supported Challenge Modes

- Hardcore
- Level One Lunatic
- Exhaustion
- Slow & Steady
- Boaring Adventure
- Path of the Brewmaster
- Traveling Craftmaster
- Vagrant's Endeavor

## Localization

Currently supports English (`enUS`) for challenge mode detection. Contributions for other locales are welcome! See `units.lua` for the `CHALLENGE_SPELLS` table.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)

## Author

**Emyrk**

---

_Made for [Chronicle](https://chronicleclassic.com)_ 📜
