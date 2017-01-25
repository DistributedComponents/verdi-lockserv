OCAMLBUILD = ocamlbuild -use-ocamlfind -tag thread -package verdi-runtime -I ocaml -cflag -g
OCAMLBUILD_TEST = $(OCAMLBUILD) -package oUnit -I test

MLEXTRACTED = ocaml/LockServ.ml ocaml/LockServ.mli

MLFILES = 

MLFILES_TEST = 

default: LockServMain.native

$(MLEXTRACTED):
	+$(MAKE) -C ../.. extraction/lockserv/$@

LockServMain.native: $(MLEXTRACTED) $(MLFILES)
	$(OCAMLBUILD) LockServMain.native

clean:
	$(OCAMLBUILD) -clean

.PHONY: default clean $(MLEXTRACTED)

.NOTPARALLEL: $(MLEXTRACTED)
