# To run these tests separately, open gap in the directory where this file is located and run
# Test( Filename( DirectoryCurrent(), "level_2__3_4_5_functions.tst" ) );

gap> START_TEST( "Tests for level_2_3_4_5_functions" );

# OFPFixedPointDimensionRealModule and OFPTableFixedPointDimension test
gap> S5 := SymmetricGroup( 5 );;
gap> OFPTableFixedPointDimension( S5 );
      1  2  3  4  5  6  7  8  9  10  11  12  13  14  15  16  17  18  19

X.1 [ 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0 ]
X.2 [ 4, 1, 2, 2, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0 ]
X.3 [ 5, 2, 3, 1, 2, 2, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0 ]
X.4 [ 6, 3, 2, 2, 0, 1, 1, 2, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 ]
X.5 [ 5, 3, 3, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0 ]
X.6 [ 4, 3, 2, 2, 1, 1, 2, 0, 2, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0 ]

1 = 1
2 = C2
3 = C2
4 = C3
5 = C2 x C2
6 = C4
7 = C2 x C2
8 = C5
9 = S3
10 = S3
11 = C6
12 = D8
13 = D10
14 = A4
15 = D12
16 = C5 : C4
17 = S4
18 = A5
19 = S5


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
      1  2  3  4  5  6

X.1 [ 1, 1, 0, 1, 0, 0 ]
X.2 [ 1, 1, 1, 0, 0, 0 ]
X.3 [ 1, 1, 0, 0, 1, 0 ]
X.4 [ 4, 0, 0, 0, 0, 0 ]

1 = 1
2 = C2
3 = C4
4 = C4
5 = C4
6 = Q8


gap> Size( OFPModulesGivenDimension( 4, Q8 ) );
16
gap> S4 := SymmetricGroup( 4 );;
gap> OFPTableFixedPointDimension( S4 );
      1  2  3  4  5  6  7  8  9  10  11

X.1 [ 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0 ]
X.2 [ 3, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0 ]
X.3 [ 2, 2, 1, 0, 2, 1, 1, 0, 1, 0, 0 ]
X.4 [ 3, 1, 2, 1, 0, 1, 0, 1, 0, 0, 0 ]

1 = 1
2 = C2
3 = C2
4 = C3
5 = C2 x C2
6 = C2 x C2
7 = C4
8 = S3
9 = D8
10 = A4
11 = S4


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
      1  2  3  4  5  6  7  8  9

X.1 [ 3, 1, 1, 0, 1, 0, 0, 0, 0 ]
X.2 [ 3, 1, 1, 0, 1, 0, 0, 0, 0 ]
X.3 [ 4, 2, 2, 1, 0, 1, 0, 1, 0 ]
X.4 [ 5, 3, 1, 2, 1, 1, 1, 0, 0 ]

1 = 1
2 = C2
3 = C3
4 = C2 x C2
5 = C5
6 = S3
7 = D10
8 = A4
9 = A5


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

#
gap> STOP_TEST( "level_2_3_4_5_functions.tst" );
