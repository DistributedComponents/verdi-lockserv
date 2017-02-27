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
opam repo add distributedcomponents-dev http://opam-dev.distributedcomponents.net
opam install verdi StructTact verdi-runtime ocamlbuild
```

Then, run `./configure` in the root directory.  This will check for the appropriate version of Coq and ensure all necessary dependencies can be located.

By default, the script assumes that `Verdi` and `StructTact` are installed in Coq's `user-contrib` directory, but this can be overridden by setting the `Verdi_PATH` and `StructTact_PATH` environment variables.

Finally, run `make` in the root directory. This will compile the lock server definitions, check the proofs, and finally build an OCaml program from the extracted code called called `LockServMain` in the `extraction/lockserv` directory.

Running LockServ on a cluster
-----------------------------

`LockServMain` accepts the following command-line options:

```
-me NAME             name for this node
-port PORT           port for inputs
-node NAME,IP:PORT   node in the cluster
-debug               run in debug mode
```

Possible node names are `Server`, `Client-0`, `Client-1`, etc.

For example, to run `LockServMain` on a cluster with IP addresses
`192.168.0.1`, `192.168.0.2`, `192.168.0.3`, input port 8000,
and port 9000 for inter-node communication, use the following:

    # on 192.168.0.1
    $ ./LockServMain.native -port 8000 -me Server -node Server,192.168.0.1:9000 \
                    -node Client-0,192.168.0.2:9000 -node Client-1,192.168.0.3:9000

    # on 192.168.0.2
    $ ./LockServMain.native -port 8000 -me Client-0 -node Server,192.168.0.1:9000 \
                    -node Client-0,192.168.0.2:9000 -node Client-1,192.168.0.3:9000

    # on 192.168.0.3
    $ ./LockServMain.native -port 8000 -me Client-1 -node Server,192.168.0.1:9000 \
                    -node Client-0,192.168.0.2:9000 -node Client-1,192.168.0.3:9000

There is a simple client in the directory `extraction/lockserv/script` that can be used as follows:

    python -i client.py
    >>> c=Client('192.168.0.2', 8000)
    >>> c.send_lock()
    'Locked'
    >>> c.send_unlock()
