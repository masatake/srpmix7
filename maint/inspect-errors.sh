DISTRO=$1
for x in $(journalctl -u srpmix7-$DISTRO.service | grep -v SUCC | grep -v succ | grep error | sed -n -e 's/.*error: //p'); do
	(
	cd $x
	bash
	)
done
