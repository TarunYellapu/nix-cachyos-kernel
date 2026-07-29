import functools
import json
import subprocess
import tempfile
from pathlib import Path

REPO = "https://github.com/CachyOS/linux-cachyos.git"


@functools.lru_cache(None)
def nix_sha256_to_sri(hash: str) -> str:
    cmd = ["nix", "hash", "to-sri", "--type", "sha256", hash]

    print(f"Running command: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)

    if result.returncode != 0:
        raise RuntimeError(f"nix hash command failed with return code: {result.returncode}")

    output = result.stdout.strip()
    if not output:
        raise RuntimeError("nix hash output is empty")

    return output


@functools.lru_cache(None)
def run_nix_prefetch_url(url: str) -> str:
    cmd = ["nix-prefetch-url", url]

    print(f"Running command: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)

    if result.returncode != 0:
        raise RuntimeError(f"nix-prefetch-url command failed with return code: {result.returncode}")

    output = result.stdout.strip()
    if not output:
        raise RuntimeError("nix-prefetch-url output is empty")

    return output


def get_srcname(pkgbuild_text: str) -> str:
    script = pkgbuild_text + "\necho $_srcname"
    result = subprocess.run(
        ["bash"],
        input=script,
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


def srcname_to_version(srcname: str) -> str:
    return "-".join(srcname.split("-")[1:-1])


def find_variants(repo_dir: Path) -> list[str]:
    return [
        p.name
        for p in repo_dir.iterdir()
        if p.is_dir()
        and p.name.startswith("linux-cachyos")
        and (p / "PKGBUILD").exists()
        and (p / "config").exists()
    ]


if __name__ == "__main__":
    with tempfile.TemporaryDirectory(ignore_cleanup_errors=True) as dir:
        dir = Path(dir)
        subprocess.run(
            ["git", "clone", "--depth", "1", REPO, str(dir)],
            check=True,
        )
        commit = subprocess.run(
            ["git", "-C", str(dir), "rev-parse", "HEAD"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout.strip()
        print(f"{commit=}")

        variants = {}
        for variant in find_variants(dir):
            print(f"Variant {variant}")
            pkgbuild = (dir / variant / "PKGBUILD").read_text()
            srcname = get_srcname(pkgbuild)
            version = srcname_to_version(srcname)
            url = f"https://github.com/CachyOS/linux/releases/download/{srcname}/{srcname}.tar.gz"
            hash = nix_sha256_to_sri(run_nix_prefetch_url(url))
            print(f"  kernel: {srcname=} {version=} {hash=}")

            config_url = (
                f"https://raw.githubusercontent.com/CachyOS/linux-cachyos/{commit}/{variant}/config"
            )
            config_hash = nix_sha256_to_sri(run_nix_prefetch_url(config_url))
            print(f"  config: {config_hash=}")

            variants[variant] = {
                "version": version,
                "url": url,
                "hash": hash,
                "configUrl": config_url,
                "configHash": config_hash,
            }

    current = Path.cwd()
    while not (current / "flake.lock").exists():
        if current == current.parent:
            raise RuntimeError("Could not find flake.lock in any parent directory, exiting")
        current = current.parent

    output_file = current / "kernel-cachyos" / "version.json"
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(variants, f, indent=2, sort_keys=True)
