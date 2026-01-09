**To install on a new machine:**
```bash
echo ".cfg" >> .gitignore
git clone --bare <your-repo-url> $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
```
*(Note: If `checkout` fails because default config files already exist on the new machine, just back them up/delete them and run checkout again).*

**To add files on new machine**:
1.  **Create an alias** (add this to your shell profile later):
    ```bash
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    ```

2.  **Hide untracked files** (so `config status` doesn't show your whole Desktop):
    ```bash
    config config --local status.showUntrackedFiles no
    ```

3.  **Add your files:**
    ```bash
    config add .zshrc
    config add .config/nvim/init.lua
    config add .some/weird/location/config.file
    config commit -m "Initial commit"
    config push
    ```
