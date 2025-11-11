# Replication details for *Nonexistence of One-Fixed-Point Actions on Spheres of Direct Products Possessing a Cyclic Group as a Factor*  by P. Mizerka and K. Śmietaniak

This code can be used to replicate the fixed point dimension tables from ``TYTUL'', [ARXIV](ARXIV LINK), more precisely tables TOFILLL from this paper.

For the computations we used GAP in version `1.14.0`. One can download gap from its [official website](https://www.gap-system.org/install/).

## Obtaining the code
In order to get the replication code, either download it directly from this page via "Code --> Dwonload ZIP" and then unpack it in a desired location or issue the following command in the terminal (note that git must be installed in this case):
```bash
git clone https://github.com/piotrmizerka/one_fixed_point_spheres_scripts.git
```

## Setting up the environment
Copy the contents of the repository into `pkg` folder of one of GAP installation paths (they can be checked in the GAP session by issuing the command `GAPInfo.RootPaths;`).

Next, run in the gap session the following command which loads `OneFPActions` package:
```bash
LoadPackage("OneFPActions");
```

## Running the actual replication
In order to obtain tables no UZUPELNIC from our paper, define first (in the GAP session after loading `OneFPActions` package) the groups SL(2,5), TL(2,5), and $S_5$ via the following commands:
```bash
sl_2_5 := SL(2,5);; tl_2_5 := SmallGroup( 240, 89 );; s_5 := SymmetricGroup(5);;
```

Finally, in order to get the fixed point dimension tables, run subsequently the following commands:
```bash
OFPTableFixedPointDimension( sl_2_5 );
```
```bash
OFPTableFixedPointDimension( tl_2_5 );
```
```bash
OFPTableFixedPointDimension( s_5 );
```
