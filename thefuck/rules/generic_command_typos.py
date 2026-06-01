from difflib import SequenceMatcher, get_close_matches
from shlex import quote


COMMANDS = {
    "bun": [
        "add",
        "build",
        "create",
        "dev",
        "install",
        "pm",
        "remove",
        "run",
        "start",
        "test",
        "upgrade",
        "x",
    ],
    "pnpm": [
        "add",
        "approve-builds",
        "build",
        "create",
        "dev",
        "dlx",
        "exec",
        "install",
        "lint",
        "remove",
        "run",
        "start",
        "test",
        "up",
        "update",
    ],
    "npm": [
        "add",
        "build",
        "ci",
        "create",
        "exec",
        "install",
        "link",
        "publish",
        "run",
        "start",
        "test",
        "uninstall",
        "update",
    ],
    "yarn": [
        "add",
        "build",
        "create",
        "dev",
        "install",
        "remove",
        "run",
        "start",
        "test",
        "upgrade",
    ],
    "git": [
        "add",
        "branch",
        "checkout",
        "commit",
        "diff",
        "fetch",
        "log",
        "merge",
        "pull",
        "push",
        "rebase",
        "reset",
        "restore",
        "stash",
        "status",
        "switch",
    ],
    "brew": [
        "cleanup",
        "info",
        "install",
        "list",
        "reinstall",
        "search",
        "services",
        "uninstall",
        "update",
        "upgrade",
    ],
    "docker": [
        "build",
        "compose",
        "container",
        "exec",
        "image",
        "images",
        "logs",
        "network",
        "ps",
        "pull",
        "push",
        "restart",
        "rm",
        "rmi",
        "run",
        "start",
        "stop",
        "volume",
    ],
    "docker-compose": [
        "build",
        "down",
        "exec",
        "logs",
        "ps",
        "pull",
        "restart",
        "run",
        "start",
        "stop",
        "up",
    ],
    "gh": [
        "auth",
        "browse",
        "issue",
        "pr",
        "repo",
        "run",
        "workflow",
    ],
    "opencode": [],
    "code": [],
    "nvim": [],
    "tmux": [],
    "lazygit": [],
    "node": [],
    "deno": [],
    "cargo": ["add", "build", "check", "clippy", "install", "run", "test", "update"],
    "go": ["build", "env", "fmt", "get", "install", "mod", "run", "test", "version"],
    "uv": ["add", "init", "install", "lock", "pip", "run", "sync", "tool", "venv"],
    "uvx": [],
    "make": [],
}


COMMAND_ALIASES = {
    "g": "git",
    "gti": "git",
    "ppnm": "pnpm",
    "pnmp": "pnpm",
    "pmnp": "pnpm",
    "npn": "npm",
    "nmp": "npm",
    "brwe": "brew",
    "dcoker": "docker",
    "docer": "docker",
    "dockre": "docker",
}


COMMAND_CUTOFF = 0.72
SHORT_COMMAND_CUTOFF = 0.80
SUBCOMMAND_CUTOFF = 0.66
COMBINED_CUTOFF = 0.78


def _score(left, right):
    return SequenceMatcher(None, left, right).ratio()


def _quote_parts(parts):
    return " ".join(quote(part) for part in parts)


def _dedupe(commands):
    seen = set()
    deduped = []
    for command in commands:
        if command not in seen:
            deduped.append(command)
            seen.add(command)
    return deduped


def _closest_command(token):
    if token in COMMAND_ALIASES:
        return COMMAND_ALIASES[token]

    cutoff = SHORT_COMMAND_CUTOFF if len(token) <= 2 else COMMAND_CUTOFF
    matches = get_close_matches(token, COMMANDS.keys(), n=1, cutoff=cutoff)
    return matches[0] if matches else None


def _closest_subcommand(command, token):
    subcommands = COMMANDS.get(command, [])
    if not subcommands or token in subcommands:
        return None

    matches = get_close_matches(token, subcommands, n=1, cutoff=SUBCOMMAND_CUTOFF)
    return matches[0] if matches else None


def _split_first_two(parts):
    if len(parts) < 2:
        return []

    first, second = parts[0], parts[1]
    corrections = []

    for command, subcommands in COMMANDS.items():
        if command.startswith(first):
            remainder = command[len(first):]
            if remainder and second.startswith(remainder):
                glued_subcommand = second[len(remainder):]
                subcommand = (
                    glued_subcommand
                    if glued_subcommand in subcommands
                    else _closest_subcommand(command, glued_subcommand)
                )
                if subcommand:
                    corrections.append(_quote_parts([command, subcommand] + parts[2:]))
                elif not glued_subcommand:
                    corrections.append(_quote_parts([command] + parts[2:]))

    joined = first + second
    for command, subcommands in COMMANDS.items():
        if joined == command:
            corrections.append(_quote_parts([command] + parts[2:]))

        # Only treat the first two tokens as accidentally split when the first
        # token is not already a valid command.
        if first in COMMANDS:
            continue

        for subcommand in subcommands:
            if _score(joined, command + subcommand) >= COMBINED_CUTOFF:
                corrections.append(_quote_parts([command, subcommand] + parts[2:]))

    return corrections


def _split_first_token(parts):
    first = parts[0]
    if first in COMMANDS:
        return []

    corrections = []

    for command, subcommands in COMMANDS.items():
        if first.startswith(command):
            glued_subcommand = first[len(command):]
            subcommand = (
                glued_subcommand
                if glued_subcommand in subcommands
                else _closest_subcommand(command, glued_subcommand)
            )
            if subcommand:
                corrections.append(_quote_parts([command, subcommand] + parts[1:]))

        for subcommand in subcommands:
            if _score(first, command + subcommand) >= COMBINED_CUTOFF:
                corrections.append(_quote_parts([command, subcommand] + parts[1:]))

    return corrections


def _correct_command_and_subcommand(parts):
    corrections = []
    command = parts[0] if parts[0] in COMMANDS else _closest_command(parts[0])

    if not command:
        return corrections

    corrected = [command] + parts[1:]

    if command != parts[0]:
        corrections.append(_quote_parts(corrected))

    if len(parts) > 1:
        subcommand = _closest_subcommand(command, parts[1])
        if subcommand:
            corrections.append(_quote_parts([command, subcommand] + parts[2:]))

    return corrections


def _corrections(command):
    parts = command.script_parts
    if not parts:
        return []

    split_corrections = _split_first_two(parts) + _split_first_token(parts)
    if split_corrections:
        return _dedupe(split_corrections)

    return _dedupe(_correct_command_and_subcommand(parts))


def match(command):
    return bool(_corrections(command))


def get_new_command(command):
    corrections = _corrections(command)
    return corrections if len(corrections) > 1 else corrections[0]


enabled_by_default = True
priority = 100
