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
- [xi-mac](https://github.com/xi-editor/xi-mac) - fast, modern text editor with a backend written in rust
  - very alpha stage: doesn't have stable releases yet
- [infer](http://github.com/facebook/infer)
  - static analysis tool for c/++, objective c, and java
  - dependency: [fb-clang](http://github.com/facebook/facebook-clang-plugins/)
    - custom clang used for C analyzers in the [infer static analysis tool](http://github.com/facebook/infer)
    - bottle built for version used in infer v0.17.0 (clang 8.0.0)
    - possibly should be hosted as a bottle with homebrew to be used as a dependency with infer? would make recompilation of infer much faster
      - maintainers probably won't want that, so i'm hosting it here for now
- [endoh1](https://www.ioccc.org/2012/endoh1/hint.html)
  - neat IOCCC submission on fluid dynamics rendered as ascii

### Obsolete
- 04/06/2019: [Ghidra added to homebrew-cask](https://github.com/Homebrew/homebrew-cask/pull/59872)
