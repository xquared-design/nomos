See https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Connect-to-Your-Vagrant-Virtual-Machine-with-PuTTY

#### In Summary

The `vagrant ssh` command requires a local install of some sort of terminal ssh command or the easier route is to use Putty.

Install the [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) suite. You need putty.exe, pageant.exe and puttygen.exe.

After you provision vagrant open path from your repo root: .vagrant\machines\default\virtualbox

Open the private_key file with puttygen.exe via the Conversions->Import key menu

Click Save private key (you don't really need a passphrase for this but if you really want, create one).

Save the file whereever you like. The same folder as above is a good place. Double click the file to load it into pageant.

Open putty and connect to localhost:2222, username vagrant.


