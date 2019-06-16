Vagrant Windows mruby
===

For the non-windows user, to compile mruby for windows is a little hard to setup it. So I create this project to build zero-configure windows and allow us to compile mruby on windows super easy.

## Usage

Git clone this project

```
git clone https://github.com/elct9620/vagrant-win-mrb
```

And run it
```
vagrant up
```

We have to wait for Visual Studio to download the minimal necessary component for compile mruby, the total size is about 2GB so we can have a cup coffee and wait it downloaded.

After everything is done, we can ssh into it and use the powershell.

```
vagrant ssh
```

> Password is `vagrant`, I stil working for password-less login

## Roadmap

* [ ] Fix RDP blackscreen
* [ ] Allow ssh into machine without password
