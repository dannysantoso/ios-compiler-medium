# ------------- #
# Predefine Variable
# ------------- #
# SDK Variable #
SDK_PATH = $(shell xcrun --show-sdk-path -sdk macosx)
SWIFT_PATH = $(shell xcrun --show-sdk-path)/usr/lib/swift
TOOLCHAIN_PATH = $(shell xcode-select --print-path)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx

# Compiler Variable #
SWF_C = swiftc -frontend
SWF_C_ARGS = -sdk $(SDK_PATH)

# Linker Variable #
LD_ARGS = -syslibroot $(SDK_PATH) -lSystem -arch arm64 -L $(TOOLCHAIN_PATH) -L $(SWIFT_PATH)
# ------------- #
# ------------- #

# linker process, kalo ada changes di parameter ini bakal di run ulang lagi linkernya
main: main.o John.o Bob.o People.o
	ld main.o John.o Bob.o People.o /Library/Developer/CommandLineTools/usr/lib/swift/clang/lib/darwin/libclang_rt.osx.a -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -lobjc -lSystem -arch arm64 -force_load /Library/Developer/CommandLineTools/usr/lib/swift/macosx/libswiftCompatibilityConcurrency.a -L /Library/Developer/CommandLineTools/usr/lib/swift/macosx -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/swift -rpath /usr/lib/swift -platform_version macos 11.0.0 12.1.0 -no_objc_category_merging -o Executable.out

# main: main.o John.o Bob.o People.o
# 	ld main.o John.o Bob.o People.o $(LD_ARGS) -o Executable.out

# main: main.o John.o Bob.o People.o
# 	swiftc main.o John.o Bob.o People.o -o Executable.out

main.o: main.swift
	$(SWF_C) -c People.swift John.swift Bob.swift -primary-file main.swift -module-name mainModule -o main.o $(SWF_C_ARGS)

# SWIFT_C_ARGS manggil SDK nya
# why adding people.swift it because when there is a changes in parent which is people, so the Bob and John must be recompile
Bob.o: Bob.swift People.swift
	$(SWF_C) -c People.swift -primary-file Bob.swift -module-name BobModule -o Bob.o $(SWF_C_ARGS)

John.o: John.swift People.swift
	$(SWF_C) -c People.swift -primary-file John.swift -module-name JohnModule -o John.o $(SWF_C_ARGS)
# why People need main, bob, and john. this is for fast checking so we don't need to recheck again to avoid the duplicate compile
People.o: People.swift
	$(SWF_C) -c main.swift John.swift Bob.swift -primary-file People.swift -module-name PeopleModule -o People.o $(SWF_C_ARGS)

clean: 
	rm *.out *.o