# Contributing to Nomos

So you want to contribute to Nomos, you ~~poor poor sucker~~ awesome person you!

## Development Environment 

Note: Git must be installed.
`sudo apt-get install git` in Linux or [here](https://desktop.github.com/) for Windows/Mac.
Follow the GitHub tutorials for getting on board with revision control and setting up your SSH keys, etc.


##### In Linux:


1. Install Virtualbox

    sudo apt-get install virtualbox


2. Install [Vagrant](https://www.vagrantup.com/downloads.html). On some Linux distros, Apt has older versions of Vagrant that can cause problems, so:

For x64:

    wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
    sudo dpkg -i vagrant_1.8.1_x86_64.deb


For x86:

    wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_i686.deb
    sudo dpkg -i vagrant_1.8.1_i686.deb

4. Proceed to "setup" section below.


##### In Mac or Windows:

Install Virtualbox and then Vagrant (in that order) from their websites:

1. https://www.virtualbox.org/wiki/Downloads

2. https://www.vagrantup.com/downloads.html

3. Follow vendor directions for installation. Don't set up a VM just yet.

4. Restart your computer. Path variables aren't added until you do.

5. Proceed to "setup" section below.


#### Setup

1. In the terminal or gitshell:  

        git clone https://github.com/vhs/nomos.git
        cd nomos
        vagrant up --provision

2. Vagrant will now download and configure Virtualbox image (~1GB) so grab a coffee and/or beer.

3. Seriously, be patient. This takes a long time, initially. This will include some "timeout" messages, but that is just the VM booting up.


#### Explore

1. After you're done, navigate to http://192.168.38.10 on your host computer.

2. Default credentials for the web interface are **vhs** / **password**

3. If you need to log into the Vagrant VM at any point, use `vagrant ssh` for Linux. See [here](https://github.com/vhs/nomos/wiki/Vagrant-SSH-on-Windows) for Windows instructions.

#### Learn

Read about the overall structure of Nomos [here](https://github.com/vhs/nomos/wiki/Structure).

Contracts, Services, and Endpoints [here](https://github.com/vhs/nomos/wiki/Contracts,-Services-&-Endpoints).

Monitors and domain hooks [here](https://github.com/vhs/nomos/wiki/Monitors-&-Domain-Hooks).




#### Making changes (Git in 30 seconds)

Start by fetching the latest copy of master then create a branch for the feature or bugfix you are working on. If you have a few small bug fixes you can lump them together in one branch.

    git checkout -b my_awesome_branch

You don't have to push your branch to github but if you would like your work to be saved on github then push your branch there:

        git push --set-upstream origin my_awesome_branch
    
This command will push your changes but also set your local branch upstream to github (origin) using the branch name my_awesome_branch. --set-upstream is a one time command, future changes you can use "git push" like you normally would.

#### Submitting your changes

If someone else has made some changes to master branch it's a good idea to update your branch with the latest version of master:

    git fetch
    git merge origin/master
   
Fetch will fetch all the changes in github (called origin in this case) and "git merge origin/master" will merge any changes in master on github to the current branch you are working on.

When writing your commit messages, be sure to include what issues this relates to. See [Closing issues via commit messages](https://help.github.com/articles/closing-issues-via-commit-messages/)

Now you have two options to submit your changes, from the command line or via pull request.

#### Submitting a pull request

When everything is tested and you are ready to submit your changes to master then submit a pull request.

Start by pushing your branch to github as described above:

    git push --set-upstream origin my_awesome_branch
    
Then from github you will see your new branch with a button to create a new pull request. Hve someone review the pull request for you.

#### From the command line

If you are really hard core you can also merge from the command line. Since you are pretty hard core I don't have to explain how it's done because you know what you are doing.

#### Testing

First, before you merge in to master please test your code. Master should always be production ready.

ToDo: Set up a test instance at VHS

 `./vendor/phpunit/phpunit/phpunit `

Better yet, write a test case for your work before you write your code! Nothing attracts people of the opposite sex (or same sex) like a well written test case.

#### Deployment

ToDo: Two options here, we can tag versions to the code in the format of YY.MM.N eg, 15.01.01, 15.01.02 or we can have a stable branch that we can merge in to. Either work, stable branches work better when there are a lot of releases.

ToDo: Running migration scripts