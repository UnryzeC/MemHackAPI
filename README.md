# MemHackAPI / Memory Hack API
Jass-language based API to enhance Warcraft 3

What is MemHack?
  - Memory Hack or its shorter name "MemHack" is a simple exploit that allows us to escape Jass Virtual Machine and gain access to game's memory directly. This means it's possible to roughly reach a C++ like access via Jass. However, the limitation is Jass itself and the necessity of using bytecode, as we can't really directly invoke C++ code, unless we compile a library (dll) and invoke its code.

What do I need to compile it?
  - https://www.hiveworkshop.com/threads/w3x2lni-v2-7-2.305201/
  - After you download JNPG, download pjass.exe from my project's folder JassHelper and replace it in JassHelper folder where JNPG was installed.

What World Editor do you suggest for it?
  - https://xgm.guru/p/wc3/jassnewgenpack-r

Which version of Warcraft 3 do you suggest?
  - 1.26a

Does it work on Reforged?
  - No

Will it ever work on Reforged?
  - Most likely no, unless someone is kind enough to help me disassemble it, so I can find the needed offsets. And if the memory "exploit" still works.

What's the point of MemHack?
  - It allows any developer to add new functions that do not exist in older versions of Warcraft 3, like the Effect API that I added, or changing unit's model in-game, and so on.

Credits:
  - Unryze
  - leandrotp (Hiveworkshop)
  - Dracol1ch
  - Karaul0v
  - ENAlexey
  - Lord of the Ding (Hiveworkshop)
  - Aniki (Hiveworkshop)
  - LeP (Hiveworkshop)
  - Vexorian (Hiveworkshop)
