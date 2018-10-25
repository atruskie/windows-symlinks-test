# Windows Symlinks Test

This repository shows how git symlinks can work in Windows

## Requirements

- I'm running Windows 10 Pro Version 1803 with developer mode enabled
- An elevated console if you're not in Windows 10 developer mode and running at least version 1709
    - with developer mode enabled I was able to run these tests in a normal console
- CMD to use MKLINK (it is an internal tool)
    - I still usually use PowerShell and only drop into CMD when I need to
- git for Windows (I was running v 2.19)
- set the `git config --global core.symlinks true`
- Vagrant SMB synced folders needs PowerShell v3 or greater

## Recommendations

- use `git ls-files -s` to see if symlinks are preserved. If the mode is
  `120000` then git recognizes it as a symlink
    ```
    > git ls-files -s
    100644 4e768b56d84e02be46b30d93be818972220b8462 0       README.md
    120000 7e04551bbc919229e952964ef21a091797111400 0       a/source_link_example.txt
    120000 7e04551bbc919229e952964ef21a091797111400 0       a/source_link_example_non_admin.txt
    100644 a520b053516e90e9328fb7278f1773b3f23dc006 0       b/content.txt
    120000 63d8dbd40c23542e740659a7168a0ce3138ea748 0       directory_link
    120000 63d8dbd40c23542e740659a7168a0ce3138ea748 0       directory_link_non_admin
    ```
- when working with another filesystem force line endings to be consistent. It endsm up being easier to
  choose `LF` always as most Windows IDEs support either `LF` or `CRLF` ending but most *NIX
  applications have limited or no support for `CRLF`
  - See the .gitattributes file for a demo

## Making links in Windows  

```cmd
# (Starting from PowerShell)
cd a
cmd
C:\...\windows-symlinks-test\a>mklink source_link_example_non_admin.txt ..\b\content.txt
symbolic link created for source_link_example_non_admin.txt <<===>> ..\b\content.txt

C:\Work\GitHub\windows-symlinks-test\a>cd ..

C:\Work\GitHub\windows-symlinks-test>ls
README.md  a  b  directory_link

C:\Work\GitHub\windows-symlinks-test>mklink /d directory_link_non_admin b
symbolic link created for directory_link_non_admin <<===>> b

# back to PowerShell
exit
```

## Working with Vagrant

- I recommend using Hyper-V wherever possible
    - Newer docker features depend on Hyper-V
    - Hyper-V is far more stable than VirtualBox
    - Hyper-V is a jealous piece of crap that demands control over 
      CPU Virtualization functions 😢
    - Warning: The Vagrant Hyper-v provider requires an elevated console
      to run!
- I used Vagrant 2.2 for these tests
- I recommend setting up a low-security local account that you can use
  to authenticate the SMB share with.
  - If you're security conscious your likely to have a strong password
    set for your default Windows account - this is a pain to type in
    on each `vagrant up`
  - Using a seperate local account for the share allows you to restrict
    SMB access to just that account and just your dev folder. Useful
    if there's ever an accidental misconfiguration.
- Note the option changes to the SMB synced folder in the Vagrantfile
- To start: `vagrant up` in this directory
    - If you have VirtualBox or another provider installed you may need
      to specify which provider you want to use:
      `vagrant up --provider=hyperv`
- The Vagrantfile in this repo run symlink_test.sh which should, as a 
  proof of concept, show symlinks being shared with the guest.
