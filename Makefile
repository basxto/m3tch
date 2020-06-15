# gbdk-2020 automatically uses bin/ subdirectory
# use $(shell pwd)/dev/ if you don't use an installed sdcc
SDCCDIR=/usr/
ROM=main
BUILD=build
# can't handle trailing slash
GBDKBIN=dev/gbdk-2020/build/gbdk/bin
CC=$(GBDKBIN)/lcc -Wa-l -Wl-m -Wl-j
EMU?=sameboy


.PHONY:
build: $(BUILD)/ $(BUILD)/$(ROM).gb

%/:
	mkdir -p $@

# you've never seen this
.PHONY:
build-gbdk-2020: $(GBDKBIN)/SDCC/bin/
	ln -sf $(SDCCDIR)/bin/sdcpp  $(GBDKBIN)/SDCC/bin/
	ln -sf $(SDCCDIR)/bin/sdcc   $(GBDKBIN)/SDCC/bin/
	ln -sf $(SDCCDIR)/bin/sdasgb $(GBDKBIN)/SDCC/bin/
	make -C dev/gbdk-2020 gbdk-build linker-install gbdk-support-install gbdk-lib-install SDCCDIR="$(SDCCDIR)"

$(BUILD)/%.o: src/%.c
	$(CC) -c -o $@ $<

$(BUILD)/%.s: src/%.c
	$(CC) -S -o $@ $<

$(BUILD)/%.o: $(BUILD)/%.s
	$(CC) -c -o $@ $<

$(BUILD)/%.gb: $(BUILD)/%.o
	$(CC) -o $@ $<

.PHONY:
run:
	$(EMU) build/$(ROM).gb

clean:
	rm -r build