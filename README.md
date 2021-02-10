# homebrew formulae

### Usage
```bash
brew tap amar1729/formulae
brew install <formula>
```

### Formulae
- [browserpass](https://github.com/browserpass/browserpass-native) native binary for browserpass web extension
  - homebrew-core won't accept as a formula, but might not work as cask
  - [homebrew issue](https://github.com/Homebrew/homebrew-core/pull/21039)
- [matterhorn](https://github.com/matterhorn-chat/matterhorn) terminal mattermost client
  - i don't feel like building it from source right now
  - [homebrew issue](https://github.com/Homebrew/homebrew-core/pull/36196)
- [xi-mac](https://github.com/xi-editor/xi-mac) - fast, modern text editor with a backend written in rust
  - very alpha stage: doesn't have stable releases yet
- [endoh1](https://www.ioccc.org/2012/endoh1/hint.html)
  - neat IOCCC submission on fluid dynamics rendered as ascii

### Obsolete
- 04/06/2019: [Ghidra added to homebrew-cask](https://github.com/Homebrew/homebrew-cask/pull/59872)
- 02/10/2021: [libguestfs](http://libguestfs.org/) (`:osxfuse` deprecated)
- 02/10/2021: automake-1.15 (libguestfs removed)
