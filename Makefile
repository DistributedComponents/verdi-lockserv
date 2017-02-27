COQVERSION := $(shell coqc --version|grep "version 8.5")

ifeq "$(COQVERSION)" ""
$(error "Verdi LockServ is only compatible with Coq version 8.5")
endif

COQPROJECT_EXISTS=$(wildcard _CoqProject)
ifeq "$(COQPROJECT_EXISTS)" ""
$(error "Run ./configure before running make")
endif

CHECKPATH := $(shell ./script/checkpaths.sh)

ifneq ("$(CHECKPATH)","")
$(info $(CHECKPATH))
$(warning checkpath reported an error)
endif

default: Makefile.coq
	$(MAKE) -f Makefile.coq
	+$(MAKE) -C extraction/lockserv

LOCKSERV_MLFILES = extraction/lockserv/ocaml/LockServ.ml extraction/lockserv/ocaml/LockServ.mli

Makefile.coq: _CoqProject
	coq_makefile -f _CoqProject -o Makefile.coq -no-install \
          -extra '$(LOCKSERV_MLFILES)' \
	    'extraction/lockserv/coq/ExtractLockServ.v systems/LockServ.vo' \
	    '$$(COQC) $$(COQDEBUG) $$(COQFLAGS) extraction/lockserv/coq/ExtractLockServ.v' \
          -extra-phony 'distclean' 'clean' \
	    'rm -f $$(join $$(dir $$(VFILES)),$$(addprefix .,$$(notdir $$(patsubst %.v,%.aux,$$(VFILES)))))'

$(LOCKSERV_MLFILES): Makefile.coq
	$(MAKE) -f Makefile.coq $@

lockserv:
	+$(MAKE) -C extraction/lockserv

clean:
	if [ -f Makefile.coq ]; then \
	  $(MAKE) -f Makefile.coq distclean; fi
	rm -f Makefile.coq
	$(MAKE) -C extraction/lockserv clean

lint:
	@echo "Possible use of hypothesis names:"
	find . -name '*.v' -exec grep -Hn 'H[0-9][0-9]*' {} \;

distclean: clean
	rm -f _CoqProject

.PHONY: default clean lint $(LOCKSERV_MLFILES) lockserv
