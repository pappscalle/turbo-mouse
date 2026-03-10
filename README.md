## Template usage & submodules

This repository was created from a template.

### External dependncies

This project uses external Turbo Pascal Unit (`.tpu`) files, included via a Git subtree.

The units are located at `src/external/src/units`

### Creating a new repository from this template and initializing the subtree

After creating a new repository from this template, clone it:

```
git clone git@github.com:pappscalle/my-cloned-repo.git
```

and run

```
./init-units.sh
```

### Updating the subtree to the latest version

If you want the newest version of the units, you can update them by running:

```
./update-units.sh
```
