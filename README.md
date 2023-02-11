# .macsetup

This repro installs software from Homebrew, App Store, and updates System Preferences.

## Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Download and Run Shell Script

```bash
mkdir ~/repos
cd ~/repos
git clone https://github.com/jarossnd/.macsetup.git
cd ~/repos/.macsetup
chmod u+x install.sh
./install.sh
```