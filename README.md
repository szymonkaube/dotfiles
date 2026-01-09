### Daily Usage
Using this is almost identical to standard Git. You just use `config` instead of `git`.

*   **Check changes:**
    ```bash
    config status
    ```
*   **Add a file (even outside .config):**
    ```bash
    config add .ssh/config
    ```
*   **See diffs:**
    ```bash
    config diff
    ```
*   **Pull updates:**
    ```bash
    config pull
    ```

**⚠️ Important Safety Rule:**
Never run `config add .` (dot). Since your work tree is your Home directory, `config add .` will attempt to add your **entire** home folder (Downloads, Documents, sensitive keys) to Git. Always add files specifically by name.

---

### Setting up on a NEW Machine
This is the only slightly complex part. When you pull your repo to a new computer, Git might complain because files like `.zshrc` or `.bashrc` *already exist* (created by the OS default installation).

Here is the "One-Liner" logic to set up a new machine:

1.  **Clone as bare:**
    ```bash
    git clone --bare <your-git-url> $HOME/.cfg
    ```

2.  **Define the alias (temporarily):**
    ```bash
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    ```

3.  **Try to Checkout:**
    ```bash
    config checkout
    ```

**The Conflict:**
If step 3 gives an error like `error: The following untracked working tree files would be overwritten by checkout`, it means the new machine already has default config files.

**The Fix:**
You need to move the existing default files out of the way. You can run this quick snippet to back them up:
```bash
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```
*This script looks at the error message, finds the conflicting files, and moves them to a `.config-backup` folder.*

4.  **Checkout again:**
    ```bash
    config checkout
    ```

5.  **Configure visibility (again):**
    ```bash
    config config --local status.showUntrackedFiles no
    ```

---

### Summary Cheat Sheet

| Action | Command |
| :--- | :--- |
| **Status** | `config status` |
| **Add File** | `config add <path/to/file>` |
| **Commit** | `config commit -m "message"` |
| **Push** | `config push` |
| **Safety** | **NEVER** run `config add .` |

