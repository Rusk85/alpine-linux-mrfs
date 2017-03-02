###DESCRIPTION
Docker Base Image created from latest [Alpine Linux Root Mini Filesystem (x86_64)](https://alpinelinux.org/downloads/). It's completely untouched. 
###USAGE
You can pull the latest image from Docker using: 
`docker run -ti -u root rusk85\alpine-base /bin/sh`
If you want to build it yourself using a different target platform run these commands in a linux shell:
    
    $ git clone https://github.com/Rusk85/alpine-linux-mrfs.git
    $ cd alpine-linux-mrfs
    $ ./build_alpine_mrfs_image.sh $TAG $ARCHITECTURE
