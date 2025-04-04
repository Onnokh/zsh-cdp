# zsh-cdp plugin
The `zsh-cdp` plugin is a Zsh utility that helps you quickly navigate to project directories with autocomplete support.

## Installation

### 1. Clone the Repository

You can install the plugin manually by cloning the repository into your `~/.oh-my-zsh/custom/plugins/` directory.

```sh
git clone https://github.com/Onnokh/zsh-cdp ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cdp
```

### 2. Enable the Plugin in `~/.zshrc`

After cloning the repository, you need to enable the plugin in your Zsh configuration.

```sh
nano ~/.zshrc
```

#### Oh-my-zsh manager
Find the `plugins` section and add `cdp` to the list of plugins:

```
plugins=(<other plugins> cdp)
```

#### Manual
Add the following to your .zshrc:
```
source ~/.oh-my-zsh/custom/plugins/cdp/cdp.plugin.zsh
```

### 3. Reload ZSH configuration

After saving the changes to `.zshrc`, reload your Zsh configuration by running:

```sh
source ~/.zshrc
```

## Usage

This will enable the `cdp` plugin and any other plugins you added.

Usage

Once the plugin is installed, you can use it as follows:

1. Navigate to a project:

Use the `cdp` command followed by the project name to change directories:

```sh
cdp my-project
```

2. Autocomplete:
   Press `Tab` after typing `cdp` to autocomplete available project directories inside your `PROJECTS_DIR`.

## Customization

The plugin assumes that your projects are located under `~/dev/sites`. If your projects are in a different directory, you can customize the the folder with the following command:

```sh
cdp --folder ~/path/to/your/projects
```