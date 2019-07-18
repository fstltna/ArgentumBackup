# ArgentumBackup - backup script for the Argentum Age Card Game (1.0)
Creates a hot backup of your Argentum Ages installation and optionally copies it to a offsite server.

Official support sites: [Official Github Repo](https://github.com/fstltna/ArgentumBackup) - [Official Forum](https://argentumage.gameplayer.club/index.php/forum/argentum-age-utilities)

---

1. Make sure ssh-keygen is installed: "apt install ssh-keygen"
2. Run "ssh-keygen" and when asked for the password just press enter twice
3. Run "ssh-copy-id -i ~/.ssh/id_rsa.pub your-destination-server" - This will ask you for your remote password. This is normal.
4. Edit the settings at the top of argentumbackup.pl if needed
5. After the first run edit the ~/.argbackuprc and change your settings if you want to use the offsite backup feature. The next run it should save to your remote host.
6. create a cron job like this:

        1 1 * * * /root/ArgentumBackup/argentumbackup.pl

7. This will back up your Argentum installation at 1:01am each day, and keep the last 5 backups.

If you need more help visit https://ArgentumAge.GamePlayer.club/ and check out this website: https://superuser.com/questions/555799/how-to-setup-rsync-without-password-with-ssh-on-unix-linux

