.ONESHELL:

release:
		cd ./ui 
		flutter build apk --obfuscate --split-debug-info=./app/build/debuginfo --split-per-abi
		cd ..
		mkdir -p ./release/$(tag)
		mkdir ./release/$(tag)/app
		cp ./LICENSE bin/*.bin ./.pio/build/wemosbat/firmware.bin ./.pio/build/wemosbat/partitions.bin ./release/$(tag)
		cp ./ui/build/app/outputs/apk/release/*.apk ./release/$(tag)/app
		cd ./release/$(tag)
		zip -r plant-sense-$(tag).zip ./*
		cd ../../
ifdef tag
		gh release create $(tag) ./release/$(tag)/plant-sense-$(tag).zip
else
		@echo 'Add the tag argument, i.e. `make release tag=v1.0.0`'
endif
	
%:
	@: 

.PHONY: release