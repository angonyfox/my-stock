#Usage
1. . ./setenv.sh
2. ./login_tisco.sh
3. ./login_set.sh
4. done - try
```
./fastquote.sh SYMC
./portfolio.sh
```

Note
1. use zsh (not fish)
2. requires reading/writing cookie.txt in working dir (for keeping session state)

Setup (first time only)
1. copy `setenv_template.sh` to `setenv.sh`
2. fill out your data according to instructions. leave SET_KEY blank for now
3. runs
```
./login_tisco.sh
./login_set.sh
./genkey.sh
```
4. you should get output like this
```
var aj = "<your key>";
```
5. copy `<your key>` and paste it to `SET_KEY` variable in `setenv.sh`. You only need this once.
6. done - follow instructions in Usage