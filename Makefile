# gbdk-2020 automatically uses bin/ subdirectory
# use $(shell pwd)/dev/ if you don't use an installed sdcc
SDCCDIR=/usr/
ROM=main
BUILD=build
GBDKBIN=
CC=$(GBDKBIN)lcc -Wa-l -Wl-m -Wl-j
EMU?=sameboy


.PHONY:
build: $(BUILD)/ $(BUILD)/$(ROM).gb

%/:
	mkdir -p $@

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