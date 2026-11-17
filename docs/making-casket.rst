Preparation
=================================================
At sources, we assume the contents are exported via
/srv/sources8.

Do the following steps as preparation at sources:

0. Copy the scripts /srv/sources8/_tools as executable.

  * lsiso
  * lsmodsrpm
  * mkcasket
  * srpmix7

1. Ensure the isos are downloaded to /srv/sources8/isos.

   e.g.

	./lsiso download rhel9.4 && ./lsiso download -b rhel9.4 

2. Ensure the following commands are installed:

  * isoinfo (in genisoimage package)
  * mksquashfs (in squashfs-tools package)

Make a casket
=================================================
Do the following steps as preparation at a NFS client.

  
0. Ensure sources is mounted to /srv/sources8.
   Using RO,NOATIME options may be better.

1. Ensure /root has enough space (> 250G).
   
2. Weave a working directory (_rhel9) at /root:
   e.g.

	bash /srv/sources8/_tools/mkcasket weave rhel9

3. (optional) Umount the directories that you don't want to include to the casket
   e.g.

	findmnt -n -Q 'TARGET =~ ".*dotnet.*' -o TARGET | xargs umount

4. Generate scripts for making symlinks.
   e.g.

	/srv/sources8/_tools/lsiso lslink-l --cache-dir /srv/sources8/isos --sources-dir /root/_rhel9 rhel9.4 > link-alias-rhel9-4.sh 

   Do the same for all rhel 9.x.

5. Run the generated scripts.
   e.g
   
	for i in 0 1 2 3 4  ; do bash link-alias-rhel9-$i.sh > link-alias-rhel9-$i.log 2>&1; done

6. Remove packages that you don't include to the casket

7. Copy README to the top dir.
   
8. Make the casket.
   e.g.
   
	bash /srv/sources8/_tools/mkcasket make casket-20240504-rhel9-no-dotnet.sqfs.xz rhel9

8. Remove README from the top dir.

9. Desolve the working directory.
   e.g.

	bash /srv/sources8/_tools/mkcasket desolve rhel9

