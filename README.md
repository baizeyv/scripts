``` cmd
.\check_page_size_16kb_hudson.ps1 -sourceFile '.\MahjongVigor_1166.apk' -dump 'C:\Program Files\Unity\Hub\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\NDK\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-objdump.exe' -zipalign 'C:\Program Files\Unity\Hub\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\SDK\build-tools\35.0.0\zipalign.exe'
```
Commands arguments:

`check_page_size_16kb_hudson.ps1`
- `-sourceFile '.\MahjongVigor_1166.apk'`
- `-dump 'C:\foo\bar\windows-x86_64\llvm-objdump.exe'`
- `-zipalign 'C:\foo\bar\zipalign.exe'`
