## Initialization 
Hosts must be configured beforehand. Each host must contain an init.nix (plain attribute set) similar to the one  
in ./host/onyx with these attributes to make for an easy initialization of the host configuration:

> { `sysAdmin`, `system`, `timezone`, `locale`, `keyLayout`, `keyMap` }

### Secret management with sops-nix

User passwords, SSH private keys, and similar credentials are managed with [sops-nix](https://github.com/Mic92/sops-nix). Secrets are stored in  
a SOPS-encrypted `secrets.yaml` file and decrypted at activation time, with the plaintext placed transiently  
under `/run/secrets/`.

The current implementation stores `secrets.yaml` in a separate private repository, pulled in as a flake input.  
This keeps all secrets entirely outside the dotfiles repo, with SSH key access controlling who can fetch it.  

Alternatively, if you are comfortable enough, you can commit the SOPS-encrypted `secrets.yaml` directly  
into this repo. Since the file is encrypted, it is safe to version-control. Whether or not you store the encrypted  
file in a private repository is entirely up to you.

The expected structure of `secrets.yaml` is documented in `example_setup/example-secrets.yaml`,  
covering user passwords and SSH key pairs.

### Private data (git-crypt)

Per-host private data (network config, SSH hosts, user info) lives in `hosts/<hostname>/private-data/`  
as JSON files:

- `network.json` — defaultGateway, staticIp, dnsServers
- `users.json`   — per-user fullname, email
- `ssh.json`     — SSH host addresses, users, ports

These files are encrypted at rest with **git-crypt**. The repo will
evaluate and build correctly only after unlocking.   
Examples of the structure of these files are in the /example_setup directory.

### Bootstrapping on a new machine

1. Download your Nixos iso image [from here](https://nixos.org/download/#nixos-iso) and install Nixos using a liveusb.  
   Change the hostname to your preference and reboot. 

2. Install the necessary packages (not in PATH by default on NixOS):
   ```
   $ nix-shell -p age git git-crypt sops vim wget
   ```
3. Generate a new age key for sops for your hosts, this creates a sops public key (detailed instructions [here](https://unmovedcentre.com/posts/secrets-management/#initializing-secrets-and-keys)):
   ```
   $ cd && mkdir -p .config/sops/age
   $ age-keygen -o ~/.config/sops/age/keys.txt
   ```
4. Create a .sops.yaml file outside your dotfiles directory. Add the ssh host key and sops public key.
   ```
   $ nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
   $ vim ~/path/to/.sops.yaml
   ```
6. Clone this repository into your dotfiles directory:
   ```
   $ mkdir -p .dotfiles/nixos
   $ git clone https://github.com/Medeon/Nixos-flakes-config.git -b main --depth=1 ~/.dotfiles/nixos
   $ cd ~/.dotfiles/nixos
   ```

6. Create your minimal host directory at `./hosts/<hostname>` with at least these modules: init.nix, users.nix,  
   configuration.nix, default.nix and copy `/etc/nixos/hardware-configuration` in the root of your host  
   directory. (A minimal default host configuration will be added to hosts in the near future)
   ```
   $ sudo -i
   $ cp /etc/nixos/hardware-configuration/ /path/to/.dotfiles/nixos/host/<hostname>
   $ exit
   ```   
7. Create a sops encrypted secrets.yaml file in your prefered directory according to the structure  
   given in the `example-secrets.yaml` file.
   ```
   $ sops secrets.yaml
   ```
8. Obtain the git-crypt key from your secure backup or create one from scratch (see: [git-crypt documentation](https://www.agwa.name/projects/git-crypt/)).  
   If you reuse an existing git-crypt key, copy it to the .git folder in the root of your dotfiles & unlock the repo:
   ```
   $ git-crypt unlock /path/to/key
   ```

9. If you start from scratch [create a .gitattributes file](https://www.agwa.name/projects/git-crypt/) along with the JSON files in the `private-data` directory.  
   Either way make sure your init.nix file contains the correct values. Verify the JSON files are readable plaintext.  
   Then proceed with:
   ```
   $ nixos-rebuild switch --flake .#<hostname>
   ```


