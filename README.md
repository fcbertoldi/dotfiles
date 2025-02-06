Repo with my dotfile configurations for the following tools:

- emacs
- bash

We use the [chezmoi](https://www.chezmoi.io/) tool to manage the dotfiles.

# Installing

Based on <https://www.chezmoi.io/quick-start/>.


1. Make sure `chezmoi` is [installed](https://www.chezmoi.io/install/)


2. Clone the repo with chezmoi
    ```
    chezmoi init git@github.com:fcbertoldi/dotfiles.git
    ```

3. Check the diff between current config state and the repo state with `chezmoi diff`

4. Apply the changes with `chezmoi -v apply`


# References

<https://www.chezmoi.io/install/>

<http://dotfiles.github.io/>
