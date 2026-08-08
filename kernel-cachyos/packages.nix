{
  inputs,
  callPackage,
  lib,
  linuxKernel,
  ...
}:
let
  helpers = callPackage ../helpers.nix { };
  inherit (helpers) kernelModuleLLVMOverride;

  kernels = lib.filterAttrs (_: lib.isDerivation) (callPackage ./. { inherit inputs; });
in
lib.mapAttrs' (
  n: v:
  let
    packages = kernelModuleLLVMOverride (
      (linuxKernel.packagesFor v).extend (
        final: prev:
        let
          variant = v.zfsVariant;
        in
        {
          zfs_cachyos = final.callPackage ../zfs-cachyos {
            inherit inputs variant;
          };

          # VirtualBox host module doesn't pass kernel specific makeflags
          virtualbox = prev.virtualbox.overrideAttrs (old: {
            makeFlags = (old.makeFlags or [ ]) ++ final.kernel.commonMakeFlags;
          });
        }
      )
    );
  in
  lib.nameValuePair "linuxPackages-${lib.removePrefix "linux-" n}" packages
) kernels
