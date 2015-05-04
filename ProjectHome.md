# MSN messenger library for actionscript 3.0 (Flex/AIR) #

![http://fs.textcube.com/blog/0/1908/attach/Xc7bqaDreJ.png](http://fs.textcube.com/blog/0/1908/attach/Xc7bqaDreJ.png)

## How to use ##

### 1. make an Account object ###
```
  var a:Account = new Account();
```
### 2. add eventlistener to account object ###
```
  a.addEventListener(AccountEvent.STATE_CHANGE, onStatusChange);
```
### 3. connect to notification server with email, pwd, init status ###
```
  a.connect('your_email', 'your_pwd', AccountState.ONLINE);
```
### 4. If the connection is opened, the account object dispatch event STATE\_CHANGE. ###
### And It will be hadled by onStatusChange function. ###
```
  function onStatusChange(event:AccountEvent):void
  {
    for each (var friend:Friend in a.data.friends)
    {
      trace(friend.data.email);
    }
  }
```

## Requirements ##

### 1. as3corelib ( http://code.google.com/p/as3corelib/ ) ###

### 2. as3httpclientlib ( http://code.google.com/p/as3httpclientlib/ ) ###


## Contact me ##

**buvlet@gmail.com** or **buzzler@hotmail.com** or **buzzler@mobswing.com**