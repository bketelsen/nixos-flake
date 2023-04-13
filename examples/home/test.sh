set -euo pipefail

USER="john"
HOSTNAME="myhost"

set -x
nix build \
  --override-input nixos-flake ../.. \
  .#activate-home
nix build \
  --override-input nixos-flake ../.. \
  .#update
nix build \
  --override-input nixos-flake ../.. \
  .#homeConfigurations.${USER}@${HOSTNAME}.activationPackage
ls result/
rm -f result

# Actually run 'home-manager switch' and look for installed programs.
mkdir tmp
HOME=$(pwd)/tmp/home USER=john HOSTNAME=myhost nix run \
  --override-input nixos-flake ../.. \
  .#activate-home
ls -la ./tmp/home
ls ./tmp/home/.nix-profile/bin/git
ls ./tmp/home/.nix-profile/bin/starship
ls ./tmp/home/.bash_profile
rm -rf ./tmp

set +x


rm -f flake.lock