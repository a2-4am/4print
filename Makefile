# https://sourceforge.net/projects/acme-crossass/
ACME=acme

# https://github.com/mach-kernel/cadius
CADIUS=cadius

BUILDDIR=build
SOURCES=$(wildcard src/*.a)
EXE=$(BUILDDIR)/REPRINT.SYSTEM\#FF2000
PRODOS=PRODOS
CLOCK=CLOCK
RES=RES
CONFIG=CONFIG
BORDERS=BORDERS
BORDERS3P=BORDERS3P
FONTS=FONTS
FONTS3P=FONTS3P
GRAPHICS=GRAPHICS
GRAPHICS3P=GRAPHICS3P
SCREENS=SCREENS
SCREENS3P=SCREENS3P
SAVED=SAVED.CREATIONS
DISKVOLUME=TOTAL.REPRINT
BUILDDISK=$(BUILDDIR)/$(DISKVOLUME).po
SOURCE_DATE := $(shell git log -1 --format=%cD | bin/rfc2822_to_touch.py)
export SOURCE_DATE_EPOCH = $(shell git log -1 --format=%ct)

.PHONY: asm clean mount all

asm: $(BUILDDIR)
	$(ACME) -r build/reprint.lst src/reprint.a

$(BUILDDISK): $(PRODOS) $(CLOCK) $(EXE) $(RES) $(CONFIG) $(GRAPHICS) $(GRAPHICS3P) $(FONTS) $(FONTS3P) $(BORDERS) $(BORDERS3P) $(SCREENS) $(SCREENS3P) $(SAVED)

$(BUILDDIR):
	mkdir -p "$@"
	$(CADIUS) CREATEVOLUME "$(BUILDDISK)" "$(DISKVOLUME)" 800KB -C

$(EXE): asm $(SOURCES) | $(BUILDDIR)
	touch -d"$(SOURCE_DATE)" "$@"
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@" -C
	@touch "$@"

# things that go in the root directory
$(PRODOS) $(CLOCK) $(RES) $(CONFIG): $(BUILDDIR)
	$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@" -C

# things that go in their own subdirectory
$(GRAPHICS) $(FONTS) $(BORDERS) $(SCREENS) $(SAVED): $(BUILDDIR)
	$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(DISKVOLUME)/$@/" "$@" -C

# things that go in other subdirectories
$(GRAPHICS3P): $(BUILDDIR)
	$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(DISKVOLUME)/$(GRAPHICS)/" "$@" -C

$(BORDERS3P): $(BUILDDIR)
	$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(DISKVOLUME)/$(BORDERS)/" "$@" -C

$(FONTS3P): $(BUILDDIR)
	$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(DISKVOLUME)/$(FONTS)/" "$@" -C

$(SCREENS3P): $(BUILDDIR)
	$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(DISKVOLUME)/$(SCREENS)/" "$@" -C

# things not included in this classification
#$(SAVED): $(BUILDDIR)
#	$(CADIUS) CREATEFOLDER "$(BUILDDISK)" "/$(DISKVOLUME)/$@/" -C

mount: $(BUILDDISK)
	@open "$(BUILDDISK)"

clean:
	rm -rf "$(BUILDDIR)"

all: clean mount

.NOTPARALLEL:
