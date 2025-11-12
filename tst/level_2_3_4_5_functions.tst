# To run these tests separately, open gap in the directory where this file is located and run
# Test( Filename( DirectoryCurrent(), "level_2__3_4_5_functions.tst" ) );

gap> START_TEST( "Tests for level_2_3_4_5_functions" );

# OFPFixedPointDimensionRealModule and OFPTableFixedPointDimension test
gap> S5 := SymmetricGroup( 5 );;
gap> OFPTableFixedPointDimension( S5 );

Nontrivial real irreducible character table of G = SmallGroup(
[ 120, 34 ]) = S5

 |g| 1  2  2  3  6  4  5
|(g)| 1  10  15  20  20  30  24
X.1 [ 1, -1, 1, 1, -1, -1, 1 ]
X.2 [ 4, -2, 0, 1, 1, 0, -1 ]
X.3 [ 5, -1, 1, -1, -1, 1, 0 ]
X.4 [ 6, 0, -2, 0, 0, 0, 1 ]
X.5 [ 5, 1, 1, -1, 1, -1, 0 ]
X.6 [ 4, 2, 0, 1, -1, 0, -1 ]


Fixed point dimension table for nontrivial real irreducible characters (which \
are listed above):

      1  2  3  4  5  6  7  8  9  10  11  12  13  14  15  16  17  18
19 ((*) - see the legend below the table)

X.1 [ 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0 ]
X.2 [ 4, 1, 2, 2, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0 ]
X.3 [ 5, 2, 3, 1, 2, 2, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0 ]
X.4 [ 6, 3, 2, 2, 0, 1, 1, 2, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 ]
X.5 [ 5, 3, 3, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0 ]
X.6 [ 4, 3, 2, 2, 1, 1, 2, 0, 2, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0 ]

The legend to (*):
1 = SmallGroup([ 1, 1 ]) = 1 number of subgroups in the class = 1
2 = SmallGroup([ 2, 1 ]) = C2 number of subgroups in the class = 10
3 = SmallGroup([ 2, 1 ]) = C2 number of subgroups in the class = 15
4 = SmallGroup([ 3, 1 ]) = C3 number of subgroups in the class = 10
5 = SmallGroup([ 4, 2 ]) = C2 x C2 number of subgroups in the class = 5
6 = SmallGroup([ 4, 1 ]) = C4 number of subgroups in the class = 15
7 = SmallGroup([ 4, 2 ]) = C2 x C2 number of subgroups in the class = 15
8 = SmallGroup([ 5, 1 ]) = C5 number of subgroups in the class = 6
9 = SmallGroup([ 6, 1 ]) = S3 number of subgroups in the class = 10
10 = SmallGroup([ 6, 1 ]) = S3 number of subgroups in the class = 10
11 = SmallGroup([ 6, 2 ]) = C6 number of subgroups in the class = 10
12 = SmallGroup([ 8, 3 ]) = D8 number of subgroups in the class = 15
13 = SmallGroup([ 10, 1 ]) = D10 number of subgroups in the class = 6
14 = SmallGroup([ 12, 3 ]) = A4 number of subgroups in the class = 5
15 = SmallGroup([ 12, 4 ]) = D12 number of subgroups in the class = 10
16 = SmallGroup([ 20, 3 ]) = C5 : C4 number of subgroups in the class = 6
17 = SmallGroup([ 24, 12 ]) = S4 number of subgroups in the class = 5
18 = SmallGroup([ 60, 5 ]) = A5 number of subgroups in the class = 1
19 = SmallGroup([ 120, 34 ]) = S5 number of subgroups in the class = 1


gap> realIrr := OFPRealIrreducibles( S5 );;
gap> sub := AllSubgroups( S5 );;
gap> Order( sub[1] );
1
gap> Order( sub[2] );
2
gap> V := [[realIrr.realIrreducibles[2],1],[realIrr.realIrreducibles[3],1],[realIrr.realIrreducibles[4],1],[realIrr.realIrreducibles[5],1],[realIrr.realIrreducibles[6],1]];;
gap> OFPFixedPointDimensionRealModule( V, sub[1], S5, realIrr.complexEquivalent );
24
gap> OFPFixedPointDimensionRealModule( V, sub[2], S5, realIrr.complexEquivalent );
12
gap> OFPFixedPointDimensionRealModule( V, S5, S5, realIrr.complexEquivalent );
0

# OFPModulesGivenDimension and OFPTableFixedPointDimension test
gap> Q8 := QuaternionGroup( 8 );;
gap> OFPTableFixedPointDimension( Q8 );

Nontrivial real irreducible character table of G = SmallGroup([ 8, 4 ]) = Q8

 |g| 1  4  4  2  4
|(g)| 1  2  2  1  2
X.1 [ 1, -1, -1, 1, 1 ]
X.2 [ 1, -1, 1, 1, -1 ]
X.3 [ 1, 1, -1, 1, -1 ]
X.4 [ 4, 0, 0, -4, 0 ]


Fixed point dimension table for nontrivial real irreducible characters (which \
are listed above):

      1  2  3  4  5  6 ((*) - see the legend below the table)

X.1 [ 1, 1, 0, 0, 1, 0 ]
X.2 [ 1, 1, 0, 1, 0, 0 ]
X.3 [ 1, 1, 1, 0, 0, 0 ]
X.4 [ 4, 0, 0, 0, 0, 0 ]

The legend to (*):
1 = SmallGroup([ 1, 1 ]) = 1 number of subgroups in the class = 1
2 = SmallGroup([ 2, 1 ]) = C2 number of subgroups in the class = 1
3 = SmallGroup([ 4, 1 ]) = C4 number of subgroups in the class = 1
4 = SmallGroup([ 4, 1 ]) = C4 number of subgroups in the class = 1
5 = SmallGroup([ 4, 1 ]) = C4 number of subgroups in the class = 1
6 = SmallGroup([ 8, 4 ]) = Q8 number of subgroups in the class = 1


gap> Size( OFPModulesGivenDimension( 4, Q8 ) );
16
gap> S4 := SymmetricGroup( 4 );;
gap> OFPTableFixedPointDimension( S4 );

Nontrivial real irreducible character table of G = SmallGroup([ 24, 12 ]) = S4

 |g| 1  2  2  3  4
|(g)| 1  6  3  8  6
X.1 [ 1, -1, 1, 1, -1 ]
X.2 [ 3, -1, -1, 0, 1 ]
X.3 [ 2, 0, 2, -1, 0 ]
X.4 [ 3, 1, -1, 0, -1 ]


Fixed point dimension table for nontrivial real irreducible characters (which \
are listed above):

      1  2  3  4  5  6  7  8  9  10  11 ((*) - see the legend below the table)

X.1 [ 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0 ]
X.2 [ 3, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0 ]
X.3 [ 2, 2, 1, 0, 2, 1, 1, 0, 1, 0, 0 ]
X.4 [ 3, 1, 2, 1, 0, 1, 0, 1, 0, 0, 0 ]

The legend to (*):
1 = SmallGroup([ 1, 1 ]) = 1 number of subgroups in the class = 1
2 = SmallGroup([ 2, 1 ]) = C2 number of subgroups in the class = 3
3 = SmallGroup([ 2, 1 ]) = C2 number of subgroups in the class = 6
4 = SmallGroup([ 3, 1 ]) = C3 number of subgroups in the class = 4
5 = SmallGroup([ 4, 2 ]) = C2 x C2 number of subgroups in the class = 1
6 = SmallGroup([ 4, 2 ]) = C2 x C2 number of subgroups in the class = 3
7 = SmallGroup([ 4, 1 ]) = C4 number of subgroups in the class = 3
8 = SmallGroup([ 6, 1 ]) = S3 number of subgroups in the class = 4
9 = SmallGroup([ 8, 3 ]) = D8 number of subgroups in the class = 3
10 = SmallGroup([ 12, 3 ]) = A4 number of subgroups in the class = 1
11 = SmallGroup([ 24, 12 ]) = S4 number of subgroups in the class = 1


gap> Size( OFPModulesGivenDimension( 4, S4 ) );
5

# OFPSubgroupTriples test
gap> A5 := AlternatingGroup( 5 );;
gap> subgroupTriples := OFPSubgroupTriples( A5 );;
gap> Size( subgroupTriples.subgroupTriplesTypeA );
36
gap> Size( subgroupTriples.subgroupTriplesTypeB );
19

# OFPModulesNotExcludedOdd test
gap> modules := OFPModulesGivenDimension( 6, A5 );;
gap> modulesNotExcludedOdd := OFPModulesNotExcludedOdd( A5, modules, [], subgroupTriples );;
gap> Size( modulesNotExcludedOdd );
3

# OFPModulesNotExcludedOne test
gap> Size( OFPModulesNotExcludedOne( A5, modulesNotExcludedOdd, subgroupTriples.subgroupTriplesTypeB ) );
3

# OFPRankD and OFPTableFixedPointDimension test
gap> realIrr := OFPRealIrreducibles( A5 );;
gap> OFPTableFixedPointDimension( A5 );
Nontrivial real irreducible character table of G = SmallGroup([ 60, 5 ]) = A5

 |g| 1  2  3  5  5
|(g)| 1  15  20  12  12
X.1 [ 3, -1, 0, -E(5)-E(5)^4, -E(5)^2-E(5)^3 ]
X.2 [ 3, -1, 0, -E(5)^2-E(5)^3, -E(5)-E(5)^4 ]
X.3 [ 4, 0, 1, -1, -1 ]
X.4 [ 5, 1, -1, 0, 0 ]


Fixed point dimension table for nontrivial real irreducible characters (which \
are listed above):

      1  2  3  4  5  6  7  8  9 ((*) - see the legend below the table)

X.1 [ 3, 1, 1, 0, 1, 0, 0, 0, 0 ]
X.2 [ 3, 1, 1, 0, 1, 0, 0, 0, 0 ]
X.3 [ 4, 2, 2, 1, 0, 1, 0, 1, 0 ]
X.4 [ 5, 3, 1, 2, 1, 1, 1, 0, 0 ]

The legend to (*):
1 = SmallGroup([ 1, 1 ]) = 1 number of subgroups in the class = 1
2 = SmallGroup([ 2, 1 ]) = C2 number of subgroups in the class = 15
3 = SmallGroup([ 3, 1 ]) = C3 number of subgroups in the class = 10
4 = SmallGroup([ 4, 2 ]) = C2 x C2 number of subgroups in the class = 5
5 = SmallGroup([ 5, 1 ]) = C5 number of subgroups in the class = 6
6 = SmallGroup([ 6, 1 ]) = S3 number of subgroups in the class = 10
7 = SmallGroup([ 10, 1 ]) = D10 number of subgroups in the class = 6
8 = SmallGroup([ 12, 3 ]) = A4 number of subgroups in the class = 5
9 = SmallGroup([ 60, 5 ]) = A5 number of subgroups in the class = 1
gap> OFPRankD( A5, realIrr.realIrreducibles, realIrr.complexEquivalent );
3

# OFPModulesNotExcludedOneOliverGroupsUpToOrder test
gap> result := OFPModulesNotExcludedOneOliverGroupsUpToOrder( 6, 72 );;
gap> Size( result.modulesGivenDimension[72][42] );
37
gap> Size( result.modulesNotExcludedOdd[72][42] );
12
gap> Size( result.modulesNotExcludedOne[72][42] );
0
gap> Size( result.faithfulModulesNotExcludedOne[72][42] );
0
gap> Size( result.modulesGivenDimension[72][43] );
49
gap> Size( result.modulesNotExcludedOdd[72][43] );
9
gap> Size( result.modulesNotExcludedOne[72][43] );
0
gap> Size( result.faithfulModulesNotExcludedOne[72][43] );
0
gap> Size( result.modulesGivenDimension[72][44] );
36
gap> Size( result.modulesNotExcludedOdd[72][44] );
12
gap> Size( result.modulesNotExcludedOne[72][44] );
0
gap> Size( result.faithfulModulesNotExcludedOne[72][44] );
0

gap> STOP_TEST( "level_2_3_4_5_functions.tst" );
