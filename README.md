#Forward

Born
-------------------------------------------------------------------------------------------
此版本修改自sanikoyes/skynet：
- sproto修改，添加了real（双精度浮点数double）的支持，以及variant类型（可以是real/int/string/bool）的支持
- windows下不支持epoll，故采用event-select网络模型模拟epoll来保证最小改动skynet源码的情况下，实现网络通讯
- windows平台下没有pipe兼容的接口，采用了socket api来模拟这一机制
- 控制台输入，hack修改了read函数来模拟读取fd 0(stdin)


Difference between offical skynet
```
1.sproto support real(double)/variant(real/int/string) field type
2.used event-select to simulate epoll
3.use socket api to simulate pipe()
4.hack read fd(0) for console input
```

Develop Environment
- windows
- visual studio 2013，with SP4

Start
-------------------------------------------------------------------------------------------
Build
For windows, open build/vs2013/skynet.sln and build all


Running：
```
1、工作目录设置为skynet.exe所在目录，默认为 $(ProjectDir)..\..\
2、命令参数设置为config文件的相对路径，如 examples/config
```

Thirdparty
-------------------------------------------------------------------------------------------

### Skynet

* Read Wiki https://github.com/cloudwu/skynet/wiki
* The FAQ in wiki https://github.com/cloudwu/skynet/wiki/FAQ

###Lua
Skynet now use a modify version of lua 5.3.2 ( http://www.lua.org/ftp/lua-5.3.2.tar.gz )
For detail : http://lua-users.org/lists/lua-l/2014-03/msg00489.html
You can also use the other official Lua version , edit the makefile by yourself .

###Redis
[Now use Redis3.0](http://github.com/MSOpenTech/redis/releases/download/win-3.0.503/Redis-x64-3.0.503.msi)

###redis-rdb-tools
https://github.com/sripathikrishnan/redis-rdb-tools
-Install
pip install rdbtools

###ConEmu
https://conemu.github.io/
[Download ConEmu Stable, Installer](https://www.fosshub.com/ConEmu.html/ConEmuSetup.161022.exe)

-Use
rdb --command json dump.rdb

-With Python 2.7

<hr>

#Enjoy
![If you can't explain it simply, you don't understand it well enough.](https://upload.wikimedia.org/wikipedia/en/1/13/Albert_Einstein_violin.jpg)


<HR>


<p><p><p>
Nov 19,2016