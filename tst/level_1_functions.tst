# To run these tests separately, open gap in the directory where this file is located and run
# Test( Filename( DirectoryCurrent(), "level_1_functions.tst" ) );

gap> START_TEST( "Tests for level_1_functions" );

# OFPFixedPointDimensionIrr test
gap> S5 := SymmetricGroup( 5 );;
gap> sub := AllSubgroups( S5 );;
gap> Order(sub[1]);
1
gap> Order(sub[2]);
2
gap> for ir in Irr( S5 ) do
> Display( ir );
> Print( OFPFixedPointDimensionIrr( ir, sub[1], S5 ), " ", OFPFixedPointDimensionIrr( ir, sub[2], S5 ), " ", OFPFixedPointDimensionIrr( ir, S5, S5 ), "\n" );
> od;
CT1

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     1 -1  1  1 -1 -1  1
1 0 0
CT1

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     4 -2  .  1  1  . -1
4 1 0
CT1

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     5 -1  1 -1 -1  1  .
5 2 0
CT1

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     6  . -2  .  .  .  1
6 3 0
CT1

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     5  1  1 -1  1 -1  .
5 3 0
CT1

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     4  2  .  1 -1  . -1
4 3 0
CT1

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     1  1  1  1  1  1  1
1 1 1

# OFPIndex2SubgroupsSatisfyingProposition29 test
gap> OFPIndex2SubgroupsSatisfyingProposition29( SymmetricGroup( 5 ) );
[ Alt( [ 1 .. 5 ] ) ]
gap> OFPIndex2SubgroupsSatisfyingProposition29( SL( 2, 5 ) );
[  ]
gap> OFPIndex2SubgroupsSatisfyingProposition29( SymmetricGroup( 6 ) );
[ Alt( [ 1 .. 6 ] ) ]

# OFPIsFaithful test
gap> OFPIsFaithful( [[[1,1],1]], CyclicGroup( 2 ) );
false
gap> OFPIsFaithful( [[[1,-1,2],1]], CyclicGroup( 3 ) );
true
gap> OFPIsFaithful( [[[1,-1,2],1],[[1,3,2],1]], CyclicGroup( 3 ) );
false
gap> OFPIsFaithful( [[[1,-1,2],1],[[1,4,2],1]], CyclicGroup( 3 ) );
true

# OFPOliverGroupsUpToOrder test
gap> List( OFPOliverGroupsUpToOrder( 120 ), G -> StructureDescription( G ) );
[ "A5", "C3 x S4", "(C3 x A4) : C2", "A4 x S3", "SL(2,5)", "S5", "C2 x A5" ]

# OFPRealIrreducibles test
gap> realIrr := OFPRealIrreducibles( SymmetricGroup( 5 ) );;
gap> Display( realIrr.realIrreducibles );
[ [   1,  -1,   1,   1,  -1,  -1,   1 ],
  [   4,  -2,   0,   1,   1,   0,  -1 ],
  [   5,  -1,   1,  -1,  -1,   1,   0 ],
  [   6,   0,  -2,   0,   0,   0,   1 ],
  [   5,   1,   1,  -1,   1,  -1,   0 ],
  [   4,   2,   0,   1,  -1,   0,  -1 ] ]
gap> Display( realIrr.dimensionsRealModules );
[ 1, 4, 5, 6 ]
gap> Display( realIrr.realIrrOfDim[1] );
[ [   1,  -1,   1,   1,  -1,  -1,   1 ] ]
gap> Display( realIrr.realIrrOfDim[4] );
[ [   4,  -2,   0,   1,   1,   0,  -1 ],
  [   4,   2,   0,   1,  -1,   0,  -1 ] ]
gap> Display( realIrr.realIrrOfDim[5] );
[ [   5,  -1,   1,  -1,  -1,   1,   0 ],
  [   5,   1,   1,  -1,   1,  -1,   0 ] ]
gap> Display( realIrr.realIrrOfDim[6] );
[ [   6,   0,  -2,   0,   0,   0,   1 ] ]
gap> Display( realIrr.complexEquivalent );
<object>
gap> Display( LookupDictionary( realIrr.complexEquivalent, [[[1,1,1,1,1,1,1],1]] ) );
fail
gap> Display( LookupDictionary( realIrr.complexEquivalent, [[[1,-1,1,1,-1,-1,1],1]] ) );
fail
gap> Display( LookupDictionary( realIrr.complexEquivalent, realIrr.realIrreducibles[1] ) );
CT2

     2  3  2  3  1  1  2  .
     3  1  1  .  1  1  .  .
     5  1  .  .  .  .  .  1

       1a 2a 2b 3a 6a 4a 5a
    2P 1a 1a 1a 3a 3a 2b 5a
    3P 1a 2a 2b 1a 2a 4a 5a
    5P 1a 2a 2b 3a 6a 4a 1a

Y.1     1 -1  1  1 -1 -1  1
gap> Display( LookupDictionary( realIrr.realIrrNr, realIrr.realIrreducibles[4] ) );
4
gap> Display( LookupDictionary( realIrr.realIrrNrReversed, 4 ) );
[ 6, 0, -2, 0, 0, 0, 1 ]

#
gap> STOP_TEST( "level_1_functions.tst" );
