.ONESHELL:

release:
		mkdir -p ./release/$(tag)
		cp ./LICENSE bin/*.bin ./.pio/build/wemosbat/firmware.bin ./.pio/build/wemosbat/partitions.bin ./release/$(tag)
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