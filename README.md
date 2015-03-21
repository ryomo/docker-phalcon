## Summary
* Installs
    * Apache
        * SSL enabled.
    * MySQL
        * root password is `pass`.
    * phpMyAdmin
    * Phalcon

## How to use
### 1. git clone
```sh
git clone git@github.com:ryomo/docker_phalcon.git
cd docker_phalcon/
```

### 2. Change timezone and locale
*Default timezone is `Asia/Tokyo`*

To change timezone and locale, edit `Dockerfile`'s `# timezone` section and `# locale` section.

### 3. Build
```sh
sudo sh docker_build.sh
```

### 4. Start
```sh
sudo sh docker_startlast.sh
```

## Access URL
* http://localhost/
* https://localhost/
