# My Nvim configuration

Initialy this was my [nvchad](https://github.com/NvChad/NvChad) configuration, but on v2.5 there were some changes that break my configuration and piss me off so I decided to make my own nvim configuration, to be as simple as possible for my needs, and leave it plublic if anyone wants to replicate it.

I don´t believe the v2.5 change was wrong, it was just a change and I´m still very grateful to Siduck for the amazing tool he made, and some configs are direct copies from their repo, like NvimTree configuration.

I´ll add more configuration as I need it.

## Config Structure

### Base

On base folder you will find the core configuration of nvim, like lazy installation and basic remappings.

### Configs

On configs folder you will find specific configuraton for each plugin of my setup.

## Prerequisites

Nvim >= [0.9.5](https://github.com/neovim/neovim/releases/tag/v0.9.5) (I´m currently using [0.10.3](https://github.com/neovim/neovim/releases/tag/v0.10.3))

[Ripgrep](https://github.com/BurntSushi/ripgrep) is optional but highly recommended

[Node](https://nodejs.org/en/download) min version 18. This is for some lsp languages

## Installation

### On Mac/Linux:

Delete or backup old nvim folder just in case. Below commands shows how to delete old configuration

```
rm -rf ~/.config/nvim

rm -rf ~/.local/share/nvim
```

Then, clone this repo

```
git clone https://github.com/FStanDev/myNvChadConfig.git ~/.config/nvim && nvim
```

### On Windows:

```
rm -Force ~\AppData\Local\nvim
rm -Force ~\AppData\Local\nvim-data
```

```
git clone https://github.com/FStanDev/myNvChadConfig.git $ENV:USERPROFILE\AppData\Local\nvim; if ($?) { nvim }
```

Then, after all plugins installs, execute `:MasonInstallAll` and is done 😀
