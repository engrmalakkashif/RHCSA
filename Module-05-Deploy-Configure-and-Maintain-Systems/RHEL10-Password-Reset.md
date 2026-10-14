# RHEL 10 Root Password Reset Guide (VMware)

**Target OS:** Red Hat Enterprise Linux 10 (RHEL 10)
**Environment:** VMware Virtual Machine
**Purpose:** Reset the root password when the standard `rd.break` method fails due to the `vmwgfx` graphics driver error.

---

## ⚠️ Important Notes (Read Before Starting)

1. **Console access required:** You need access to the VM console (VMware Workstation, ESXi, or vSphere console) to interact with the GRUB menu.
2. **Password quality:** RHEL's default policy expects a password of at least 8 characters. As root, a weak password only triggers a `BAD PASSWORD` warning. Entering the same password again at the prompt will usually still apply it, but a strong password of 8+ characters is recommended.
3. **SELinux relabeling (mandatory):** You **must** run `touch /.autorelabel` before rebooting. SELinux is not active in these recovery shells, so the changed `/etc/shadow` file gets the wrong security context. Without a relabel, logins may fail after reboot.
4. **Long reboot time:** The first boot afterwards can take 5–15 minutes (longer on large disks) while SELinux relabels all files. The screen may look frozen. Do not force a shutdown.
5. **Encrypted disks / GRUB password:** If the disk is LUKS-encrypted, you will still need the disk passphrase at boot. If GRUB is password-protected, you will need that password to edit boot entries.
6. **Changes are temporary:** Edits made in the GRUB menu apply to a single boot only and are not saved.

---

## Method 1: Using `init=/bin/bash` (Recommended)

This method skips the normal boot process and drops you directly into a root shell, which avoids the `vmwgfx` error.

### Step 1: Edit GRUB
1. Reboot the virtual machine.
2. At the GRUB boot menu, highlight the first entry (`Red Hat Enterprise Linux...`).
3. Press **`e`** to edit the boot parameters.

### Step 2: Modify the Kernel Line
1. Use the arrow keys to find the line that starts with `linux` (or `linuxefi`).
2. Move the cursor to the **end** of that line.
3. Delete `rhgb quiet`.
4. Append the following at the very end:
   ```text
   rw init=/bin/bash
   ```

### Step 3: Boot into the Shell
1. Press **`Ctrl + X`** (or **`F10`**) to boot with the modified parameters.
2. The system will drop you into a `bash-5.2#` prompt.

### Step 4: Reset the Root Password
1. Run:
   ```bash
   passwd root
   ```
2. Enter the new password and confirm it.
3. You should see: `passwd: all authentication tokens updated successfully.`

### Step 5: Schedule SELinux Relabel (Crucial)
```bash
touch /.autorelabel
```

### Step 6: Reboot
Because `systemd` is not running, a normal `reboot` command will not work. Use:
```bash
exec /sbin/reboot -f
```

---

## Method 2: Using `rd.break` with `vmwgfx` Blacklisted

This uses the traditional `rd.break` approach, but blacklists the problematic VMware graphics driver so the system does not fall into emergency mode before you can reset the password.

### Step 1: Edit GRUB
1. Reboot the virtual machine.
2. At the GRUB boot menu, highlight the first entry.
3. Press **`e`** to edit.

### Step 2: Modify the Kernel Line
1. Find the line that starts with `linux`.
2. Move the cursor to the **end** of that line.
3. Delete `rhgb quiet`.
4. Append the following at the very end:
   ```text
   rd.break rd.driver.blacklist=vmwgfx modprobe.blacklist=vmwgfx
   ```

### Step 3: Boot into the Emergency Shell
1. Press **`Ctrl + X`** (or **`F10`**) to boot.
2. You should land at the `switch_root:/#` prompt.

### Step 4: Remount and Change Root
1. Remount the system root as read-write:
   ```bash
   mount -o remount,rw /sysroot
   ```
2. Enter the real system:
   ```bash
   chroot /sysroot
   ```

### Step 5: Reset the Root Password
```bash
passwd root
```
Enter the new password and confirm it.

### Step 6: Schedule SELinux Relabel (Crucial)
```bash
touch /.autorelabel
```

### Step 7: Exit and Reboot
1. Type `exit` to leave the chroot environment.
2. Type `exit` again. The system will continue booting/reboot.

---

## 📌 What to Expect After Rebooting (Both Methods)

1. **Do not panic:** The system may take 5–15 minutes to boot and may look frozen.
2. **SELinux relabeling:** The system is scanning and fixing security labels on every file. This is normal. Do not force a shutdown.
3. **Automatic second reboot:** When relabeling finishes, the system reboots once more automatically.
4. **Login:** You can then log in as `root` with your new password.

---

## 🛠️ Troubleshooting

| Problem | Fix |
|---|---|
| `BAD PASSWORD` warning | Use 8+ characters, or re-enter the same password to override as root. |
| `passwd` fails with "Authentication token manipulation error" | The filesystem is still read-only. In Method 1, make sure `rw` was added; in Method 2, rerun `mount -o remount,rw /sysroot`. |
| Cannot log in after reboot | `/.autorelabel` was likely skipped. Repeat the procedure and run `touch /.autorelabel`. |
| Stuck at emergency mode again | Try Method 1, or add `nomodeset` to the kernel line. |
