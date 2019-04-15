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
- [libguestfs](http://libguestfs.org/), a library for editing VM disk images
  - should be added to homebrew after some options are tested/removed
  - related: [cmake, cdrtools, hivex issue](https://github.com/Homebrew/legacy-homebrew/pull/2765) in `legacy-homebrew`
- automake-1.15, (autotools)
  - this version was a build dep for older versions of libguestfs
  - current homebrew version >= 1.16
- [matterhorn](https://github.com/matterhorn-chat/matterhorn) terminal mattermost client
  - i don't feel like building it from source right now
  - [homebrew issue](https://github.com/Homebrew/homebrew-core/pull/36196)

### Obsolete
- 04/06/2019: [Ghidra added to homebrew-cask](https://github.com/Homebrew/homebrew-cask/pull/59872)
