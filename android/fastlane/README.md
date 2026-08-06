fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android build

```sh
[bundle exec] fastlane android build
```

Compila l'AAB di release

### android metadata

```sh
[bundle exec] fastlane android metadata
```

Carica solo la scheda dello Store: testi, icona, grafica, screenshot

### android beta

```sh
[bundle exec] fastlane android beta
```

Compila e carica sul canale di test interno

### android release

```sh
[bundle exec] fastlane android release
```

Compila e carica in produzione

### android promote

```sh
[bundle exec] fastlane android promote
```

Promuove il test interno in produzione

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
