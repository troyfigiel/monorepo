---
title: "Nix"
date: 2022-10-02T15:03:48+02:00
---

[Nix config](https://gitlab.com/troy.figiel/nixos-config).

## Decoupling my configuration from my machine

My workflow on other distros has always been to manually change config files. This inevitably puts me in a position where I have to change a piece of software and I do not remember the specifics of its installation and configuration.

Nix circumvents this problem by creating the appropriate symlinks for me. This means that if some configuration does not work, I can rollback to a previous configuration without any pain.

## But grokking Nix is also difficult

The biggest downside to Nix is its learning curve: Not only do you need to know the Nix language, you also need to be familiar with the program you are configuring in case you need to debug your code.

In my opinion, the best way to figure out which options and configurations are possible, is by using the Nix REPL and reading the source code of nixpkgs.

## Hermetic sealing

Because Nix is so strict on reproducibility and hermetically sealing your environment, you end up having to bring dependencies close together.

For example, if I want to add a blog and create that as a separate repository, that is not going to work nicely. If I update the blog I expect the changes to be visible instanteneously, but this will not happen with Nix since it will pull in a specific git revision and not the latest.

I am not sure if there is a nice solution to this problem while maintaining my blog in a separate repository.

I can think of either:
- I trigger a nixos-config pipeline from a blog pipeline to rebuild my website and update it.
- I treat the website as state on my server, but then there is no guarantee I get exactly what I want.

Overall, I would say, Nix does a great job keeping all of the related code in a single repository. Dependencies between Nix flakes will be loosely coupled by design.