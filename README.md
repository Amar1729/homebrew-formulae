# homebrew formulae

### Usage
```bash
brew tap amar1729/formulae
brew install <formula>
```

### Formulae
- [browserpass](https://github.com/browserpass/browserpass-native) native binary for browserpass web extension
  - homebrew-core won't accept as a formula, but might not work as cask
  - [homebrew-core issue](https://github.com/Homebrew/homebrew-core/pull/21039)
  - [homebrew-cask issue](https://github.com/Homebrew/homebrew-cask/issues/99519)
- [matterhorn](https://github.com/matterhorn-chat/matterhorn) terminal mattermost client
  - i don't feel like building it from source right now
  - [homebrew issue](https://github.com/Homebrew/homebrew-core/pull/36196)
- [endoh1](https://www.ioccc.org/2012/endoh1/hint.html)
  - neat IOCCC submission on fluid dynamics rendered as ascii

### Obsolete
- 04/06/2019: [Ghidra added to homebrew-cask](https://github.com/Homebrew/homebrew-cask/pull/59872)
- 02/10/2021: [libguestfs](http://libguestfs.org/) (`:osxfuse` deprecated)
  - see my [separate tap](https://github.com/Amar1729/homebrew-libguestfs/) for libguestfs
  - 02/10/2021: automake-1.15 (libguestfs removed)
