# CloudApp CLI

Experience all the pleasures of sharing with [CloudApp][] from your terminal
using a gorgeous and cutting-edge ncurses text user interface.

[cloudapp]: http://getcloudapp.com


## Requirements

`cloudapp-cli` requires Ruby 1.9.2 or greater.


## Getting Started

``` bash
gem install cloudapp
cloudapp
```

## Wish List

Along with the ncurses interface, a few simple commands to allow scripting and
input from other Unix programs would be ideal.

### Phase: One

 - Bookmark a link: `cloudapp bookmark http://getcloudapp.com`
 - Bookmark several links: `cloudapp bookmark http://douglasadams.com http://zombo.com`
 - Share a file: `cloudapp upload screenshot.png`
 - Share several files: `cloudapp upload *.png`

### Phase: Two

 - Handle bookmarks from STDIN: `pbpaste | cloudapp bookmark`
 - Handle files from STDIN: `find *.png | cloudapp upload`
 - Download a drop: `cloudapp download http://cl.ly/abc123`

### Phase: Unstoppable

 - Archive and share several files: `cloudapp upload --archive *.png`
 - Encrypt and share a file: `cloudapp upload --encrypt launch_codes.txt`
 - Download and decrypt and encrypted drop: `cloudapp download --key=def456 http://cl.ly/abc123`

### Phase: World Domination

While we're dreaming, what could you do if `cloudapp` had a database of all your
drops? Bonus points for a light weight daemon that kept everything in sync at
all times.

 - Find all your screen shots: `cloudapp list /^screen ?shot.*\.png$/`
 - Trash all your stale drops: `cloudapp delete --last-viewed="> 1 month ago"`
 - See your drop views in real time: `cloudapp --tail`

There's bound to be a better way to express some of these commands, but you get
the picture.
