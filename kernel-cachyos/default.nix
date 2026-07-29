{
  inputs,
  callPackage,
  lib,
  fetchurl,
  ...
}:
let
  mkCachyKernel = callPackage ./mkCachyKernel.nix { inherit inputs; };

  linuxSources = lib.mapAttrs (_: v: {
    inherit (v) version;
    src = fetchurl {
      inherit (v) url hash;
    };
    cachyosConfigFile = fetchurl {
      url = v.configUrl;
      hash = v.configHash;
    };
  }) (lib.importJSON ./version.json);
in
builtins.listToAttrs (
  builtins.map (v: lib.nameValuePair v.pname v) [
    # Latest kernel, provide all LTO and v2/v3/v4/zen4 arch variants
    (mkCachyKernel {
      pname = "linux-cachyos-latest";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-x86_64-v2";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      processorOpt = "x86_64-v2";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-x86_64-v3";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      processorOpt = "x86_64-v3";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-x86_64-v4";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      processorOpt = "x86_64-v4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-zen4";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      processorOpt = "zen4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-lto";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-lto-x86_64-v2";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      processorOpt = "x86_64-v2";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-lto-x86_64-v3";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      processorOpt = "x86_64-v3";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-lto-x86_64-v4";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      processorOpt = "x86_64-v4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-latest-lto-zen4";
      inherit (linuxSources.linux-cachyos) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      processorOpt = "zen4";
    })

    # LTS kernel
    (mkCachyKernel {
      pname = "linux-cachyos-lts";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-x86_64-v2";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      processorOpt = "x86_64-v2";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-x86_64-v3";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      processorOpt = "x86_64-v3";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-x86_64-v4";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      processorOpt = "x86_64-v4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-zen4";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      processorOpt = "zen4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-lto";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      lto = "thin";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-lto-x86_64-v2";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      lto = "thin";
      processorOpt = "x86_64-v2";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-lto-x86_64-v3";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      lto = "thin";
      processorOpt = "x86_64-v3";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-lto-x86_64-v4";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      lto = "thin";
      processorOpt = "x86_64-v4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-lts-lto-zen4";
      inherit (linuxSources.linux-cachyos-lts) version src cachyosConfigFile;
      zfsVariant = "lts";
      lto = "thin";
      processorOpt = "zen4";
    })

    # BORE variant
    (mkCachyKernel {
      pname = "linux-cachyos-bore";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "bore";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-x86_64-v2";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "bore";
      processorOpt = "x86_64-v2";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-x86_64-v3";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "bore";
      processorOpt = "x86_64-v3";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-x86_64-v4";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "bore";
      processorOpt = "x86_64-v4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-zen4";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "bore";
      processorOpt = "zen4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-lto";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      cpusched = "bore";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-lto-x86_64-v2";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      cpusched = "bore";
      processorOpt = "x86_64-v2";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-lto-x86_64-v3";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      cpusched = "bore";
      processorOpt = "x86_64-v3";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-lto-x86_64-v4";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      cpusched = "bore";
      processorOpt = "x86_64-v4";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bore-lto-zen4";
      inherit (linuxSources.linux-cachyos-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      cpusched = "bore";
      processorOpt = "zen4";
    })

    # Additional CachyOS provided variants
    (mkCachyKernel {
      pname = "linux-cachyos-bmq";
      inherit (linuxSources.linux-cachyos-bmq) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "bmq";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-bmq-lto";
      inherit (linuxSources.linux-cachyos-bmq) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      cpusched = "bmq";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-deckify";
      inherit (linuxSources.linux-cachyos-deckify) version src cachyosConfigFile;
      zfsVariant = "latest";
      acpiCall = true;
      handheld = true;
    })
    (mkCachyKernel {
      pname = "linux-cachyos-deckify-lto";
      inherit (linuxSources.linux-cachyos-deckify) version src cachyosConfigFile;
      zfsVariant = "latest";
      lto = "thin";
      acpiCall = true;
      handheld = true;
    })
    (mkCachyKernel {
      pname = "linux-cachyos-eevdf";
      inherit (linuxSources.linux-cachyos-eevdf) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "eevdf";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-eevdf-lto";
      inherit (linuxSources.linux-cachyos-eevdf) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "eevdf";
      lto = "thin";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-hardened";
      inherit (linuxSources.linux-cachyos-hardened) version src cachyosConfigFile;
      zfsVariant = "hardened";
      hardened = true;
    })
    (mkCachyKernel {
      pname = "linux-cachyos-hardened-lto";
      inherit (linuxSources.linux-cachyos-hardened) version src cachyosConfigFile;
      zfsVariant = "hardened";
      hardened = true;
      lto = "thin";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-rc";
      inherit (linuxSources.linux-cachyos-rc) version src cachyosConfigFile;
      zfsVariant = "rc";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-rc-lto";
      inherit (linuxSources.linux-cachyos-rc) version src cachyosConfigFile;
      zfsVariant = "rc";
      lto = "thin";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-rt-bore";
      inherit (linuxSources.linux-cachyos-rt-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      rt = true;
      cpusched = "rt-bore";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-rt-bore-lto";
      inherit (linuxSources.linux-cachyos-rt-bore) version src cachyosConfigFile;
      zfsVariant = "latest";
      rt = true;
      cpusched = "rt-bore";
      lto = "thin";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-server";
      inherit (linuxSources.linux-cachyos-server) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "eevdf";
      hzTicks = "300";
      preemptType = "none";
    })
    (mkCachyKernel {
      pname = "linux-cachyos-server-lto";
      inherit (linuxSources.linux-cachyos-server) version src cachyosConfigFile;
      zfsVariant = "latest";
      cpusched = "eevdf";
      hzTicks = "300";
      preemptType = "none";
      lto = "thin";
    })
  ]
)
