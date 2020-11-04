# To run these tests separately, open gap in the directory where this file is located and run
# Test( Filename( DirectoryCurrent(), "level_0_functions.tst" ) );

gap> START_TEST( "Tests for level_0_functions" );

# OFPFrobeniusSchurIndicator test
gap> C4 := CyclicGroup( 4 );;
gap> for ir in Irr( C4 ) do
> Display( ir );
> Print( "Frobenius-Schur indicator of the irreducible character above: ", OFPFrobeniusSchurIndicator( ir, C4 ), "\n" );
> od;
CT1

     2  2  2  2  2

       1a 4a 2a 4b

Y.1     1  1  1  1
Frobenius-Schur indicator of the irreducible character above: 1
CT1

     2  2  2  2  2

       1a 4a 2a 4b

Y.1     1 -1  1 -1
Frobenius-Schur indicator of the irreducible character above: 1
CT1

     2  2  2  2  2

       1a 4a 2a 4b

Y.1     1  A -1 -A

A = E(4)
  = Sqrt(-1) = i
Frobenius-Schur indicator of the irreducible character above: 0
CT1

     2  2  2  2  2

       1a 4a 2a 4b

Y.1     1  A -1 -A

A = -E(4)
  = -Sqrt(-1) = -i
Frobenius-Schur indicator of the irreducible character above: 0
gap> Q8 := QuaternionGroup( 8 );;
gap> for ir in Irr( Q8 ) do
> Display( ir );
> Print( "Frobenius-Schur indicator of the irreducible character above: ", OFPFrobeniusSchurIndicator( ir, Q8 ), "\n" );
> od;
CT2

     2  3  2  2  3  2

       1a 4a 4b 2a 4c
    2P 1a 2a 2a 1a 2a
    3P 1a 4a 4b 2a 4c

Y.1     1  1  1  1  1
Frobenius-Schur indicator of the irreducible character above: 1
CT2

     2  3  2  2  3  2

       1a 4a 4b 2a 4c
    2P 1a 2a 2a 1a 2a
    3P 1a 4a 4b 2a 4c

Y.1     1 -1 -1  1  1
Frobenius-Schur indicator of the irreducible character above: 1
CT2

     2  3  2  2  3  2

       1a 4a 4b 2a 4c
    2P 1a 2a 2a 1a 2a
    3P 1a 4a 4b 2a 4c

Y.1     1 -1  1  1 -1
Frobenius-Schur indicator of the irreducible character above: 1
CT2

     2  3  2  2  3  2

       1a 4a 4b 2a 4c
    2P 1a 2a 2a 1a 2a
    3P 1a 4a 4b 2a 4c

Y.1     1  1 -1  1 -1
Frobenius-Schur indicator of the irreducible character above: 1
CT2

     2  3  2  2  3  2

       1a 4a 4b 2a 4c
    2P 1a 2a 2a 1a 2a
    3P 1a 4a 4b 2a 4c

Y.1     2  .  . -2  .
Frobenius-Schur indicator of the irreducible character above: -1

# OFPGroupGeneratedBySubgroups test
gap> S3 := SymmetricGroup( 3 );;
gap> for H1 in AllSubgroups( S3 ) do
> for H2 in AllSubgroups( S3 ) do
> if Order( H1 ) > 1 or Order( H2 ) > 1 then
> Print( StructureDescription( H1 ), " ", StructureDescription( H2 ), " ", StructureDescription( OFPGroupGeneratedBySubgroups( H1, H2 ) ), "\n" );
> fi;
> od;
> od;
1 C2 C2
1 C2 C2
1 C2 C2
1 C3 C3
1 S3 S3
C2 1 C2
C2 C2 C2
C2 C2 S3
C2 C2 S3
C2 C3 S3
C2 S3 S3
C2 1 C2
C2 C2 S3
C2 C2 C2
C2 C2 S3
C2 C3 S3
C2 S3 S3
C2 1 C2
C2 C2 S3
C2 C2 S3
C2 C2 C2
C2 C3 S3
C2 S3 S3
C3 1 C3
C3 C2 S3
C3 C2 S3
C3 C2 S3
C3 C3 C3
C3 S3 S3
S3 1 S3
S3 C2 S3
S3 C2 S3
S3 C2 S3
S3 C3 S3
S3 S3 S3

#
gap> C9 := SmallGroup( 9, 1 );
<pc group of size 9 with 2 generators>
gap> for H1 in AllSubgroups( C9 ) do
> for H2 in AllSubgroups( C9 ) do
> if Order( H1 ) > 1 or Order( H2 ) > 1 then
> Print( StructureDescription( H1 ), " ", StructureDescription( H2 ), " ", StructureDescription( OFPGroupGeneratedBySubgroups( H1, H2 ) ), "\n" );
> fi;
> od;
> od;
1 C3 C3
1 C9 C9
C3 1 C3
C3 C3 C3
C3 C9 C9
C9 1 C9
C9 C3 C9
C9 C9 C9

# OFPIndex2Subgroups test
gap> List( OFPIndex2Subgroups( CyclicGroup( 18 ) ), H -> StructureDescription( H ) );
[ "C9" ]
gap> List( OFPIndex2Subgroups( SymmetricGroup( 5 ) ), H -> StructureDescription( H ) );
[ "A5" ]
gap> List( OFPIndex2Subgroups( DirectProduct(CyclicGroup(2),CyclicGroup(2)) ), H -> StructureDescription( H ) );
[ "C2", "C2", "C2" ]

# OFPIsOliver test
gap> OFPIsOliver( AlternatingGroup( 5 ) );
true
gap> OFPIsOliver( SymmetricGroup( 5 ) );
true
gap> OFPIsOliver( SymmetricGroup( 4 ) );
false
gap> OFPIsOliver( CyclicGroup( 900 ) );
false
gap> OFPIsOliver( DirectProduct( CyclicGroup( 30 ), CyclicGroup( 30 ) ) );
true

# OFPLexSmallerTuples test
gap> OFPLexSmallerTuples( [2,3] );
[ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ] ]
gap> OFPLexSmallerTuples( [1,1,1] );
[ [ 1, 1, 1 ] ]

# OFPModuleKernel test
gap> C8 := CyclicGroup( 8 );;
gap> Display( CharacterTable( C8 ) );
CT3

     2  3   3  3  3   3   3  3   3

       1a  8a 4a 2a  8b  8c 4b  8d

X.1     1   1  1  1   1   1  1   1
X.2     1  -1  1  1  -1  -1  1  -1
X.3     1   A -1  1  -A   A -1  -A
X.4     1  -A -1  1   A  -A -1   A
X.5     1   B  A -1 -/B  -B -A  /B
X.6     1  -B  A -1  /B   B -A -/B
X.7     1 -/B -A -1   B  /B  A  -B
X.8     1  /B -A -1  -B -/B  A   B

A = E(4)
  = Sqrt(-1) = i
B = E(8)
gap> StructureDescription( OFPModuleKernel( [[[1,-1,1,1,-1,0,1,-1],1]], C8 ) );
"C4"
gap> StructureDescription( OFPModuleKernel( [[[1,-1,1,1,-1,0,1,1],1]], C8 ) );
"C8"
gap> StructureDescription( OFPModuleKernel( [[[1,-1,-1,1,-1,0,-1,-1],1]], C8 ) );
"C2"
gap> StructureDescription( OFPModuleKernel( [[[1,-1,-1,-1,-1,0,-1,-1],1]], C8 ) );
"1"

# OFPRealModuleCharacters test
gap> OFPRealModuleCharacters( [[[1,1,1],1]], CyclicGroup( 3 ) );
[ 1, 1, 1 ]
gap> OFPRealModuleCharacters( [[[1,1,1],1],[[-1,-1,-1],10]], CyclicGroup( 3 ) );
[ -9, -9, -9 ]
gap> OFPRealModuleCharacters( [[[100,1,1,0,0],1],[[0,0,-1,-1,-1],10],[[1,1,1,0,0],1]], CyclicGroup( 5 ) );
[ 101, 2, -8, -10, -10 ]

# OFPSatisfiesProposition29 test
gap> OFPSatisfiesProposition29( AlternatingGroup( 5 ) );
true
gap> OFPSatisfiesProposition29( CyclicGroup( 4 ) );
true
gap> OFPSatisfiesProposition29( CyclicGroup( 8 ) );
false
gap> OFPSatisfiesProposition29( CyclicGroup( 18 ) );
false
gap> OFPSatisfiesProposition29( QuaternionGroup( 8 ) );
true

#
gap> STOP_TEST( "level_0_functions.tst" );
