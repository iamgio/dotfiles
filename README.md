# Dotfiles

My personal dotfiles and setup scripts. Mainly for macOS. Also Linux-compatible, with limitations.

With cURL:

```shell
cd ~
curl -L https://github.com/iamgio/dotfiles/archive/refs/heads/main.zip -o dotfiles.zip
unzip dotfiles.zip && rm dotfiles.zip && mv dotfiles-main dotfiles
cd dotfiles
./install.sh
```

Or with git:

```shell
cd ~
git clone https://github.com/iamgio/dotfiles.git
cd dotfiles
./install.sh
```