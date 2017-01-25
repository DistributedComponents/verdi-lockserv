Verdi LockServ
==============

[![Build Status](https://api.travis-ci.org/DistributedComponents/verdi-lockserv.svg?branch=master)](https://travis-ci.org/DistributedComponents/verdi-lockserv)

An implementation of a lock server, verified in Coq using the Verdi framework.

Requirements
------------

Definitions and proofs:

- [`Coq 8.5`](https://coq.inria.fr/download)
- [`Verdi`](https://github.com/uwplse/verdi)
- [`StructTact`](https://github.com/uwplse/StructTact)

Executable code:

- [`OCaml 4.02.3`](https://ocaml.org)
- [`OCamlbuild`](https://github.com/ocaml/ocamlbuild)
- [`ocamlfind`](http://projects.camlcity.org/projects/findlib.html)
- [`verdi-runtime`](https://github.com/DistributedComponents/verdi-runtime)

Building
--------

The recommended way to install the OCaml and Coq dependencies of Verdi LockServ is via [OPAM](https://coq.inria.fr/opam/www/using.html):

```
opam repo add coq-released https://coq.inria.fr/opam/released
opam repo add distributedcomponents http://opam.distributedcomponents.net
opam install verdi StructTact verdi-runtime
```

Then, run `./configure` in the root directory.  This will check for the appropriate version of Coq and ensure all necessary dependencies can be located.

By default, the script assumes that `Verdi` and `StructTact` are installed in Coq's `user-contrib` directory, but this can be overridden by setting the `Verdi_PATH` and `StructTact_PATH` environment variables.

Finally, run `make` in the root directory.
