import os
import subprocess

def run_command(command, **kwargs):
    subprocess.run(command, check=True, **kwargs)

def read_config(config_file):
    config = {}
    with open(config_file, "r") as file:
        for line in file:
            key, value = line.strip().split("=")
            config[key] = value
    return config

def setup_mirrorlist(mirror_url):
    run_command(["rm", "-f", "/etc/pacman.d/mirrorlist"])
    with subprocess.Popen(["tee", "/etc/pacman.d/mirrorlist"], stdin=subprocess.PIPE, text=True) as process:
        process.communicate(f"Server = {mirror_url}\n")

def update_pacman_config():
    run_command(["sed", "-i", r"/^\s*#\(ParallelDownloads\|Color\)/ s/#//", "/etc/pacman.conf"])

def install_packages(packages):
    run_command(["pacman", "-Sy"] + packages)

def format_partitions(root_partition, boot_partition, format_root, format_boot):
    if format_root:
        run_command(["mkfs.ext4", root_partition])
    if format_boot:
        run_command(["mkfs.fat", "-F32", boot_partition])

def mount_partitions(root_partition, boot_partition):
    run_command(["mount", root_partition, "/mnt"])
    run_command(["mkdir", "-p", "/mnt/boot"])
    run_command(["mount", boot_partition, "/mnt/boot"])

def install_base_system(packages):
    run_command(["pacstrap", "/mnt"] + packages)

def generate_fstab():
    run_command(["genfstab", "-U", "/mnt"])

def copy_and_run_chroot_setup(script_path):
    chroot_cmd = f'cp -r {script_path} /mnt && arch-chroot /mnt /bin/bash -c "cd / && chmod +x chroot-setup.sh && ./chroot-setup.sh"'
    run_command(chroot_cmd, shell=True)

def main():
    config_file = "config"
    config = read_config(config_file)

    mirror_url = config["mirror_url"]
    root_partition = config["root_partition"]
    boot_partition = config["boot_partition"]
    base_packages = config["base_packages"].split(",")
    format_boot = config.get("format_boot", "false").lower() == "true"
    format_root = config.get("format_root", "false").lower() == "true"

    script_dir = os.path.dirname(os.path.abspath(__file__))
    chroot_setup_script = os.path.join(script_dir, "chroot-setup.sh")

    setup_mirrorlist(mirror_url)
    update_pacman_config()
    install_packages(["btrfs-progs", "dosfstools"])
    run_command(["timedatectl", "set-ntp", "true"])
    format_partitions(root_partition, boot_partition, format_root, format_boot)
    mount_partitions(root_partition, boot_partition)
    install_base_system(base_packages)
    generate_fstab()
    copy_and_run_chroot_setup(chroot_setup_script)

    print("Done! You can now reboot.")

if __name__ == "__main__":
    main()