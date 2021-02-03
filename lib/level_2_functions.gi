# Let realModule be the real G-module (written in the same format as the parameter
#	in the level 0 function RealModuleCharacters) and H<=G.
# Requires additionally the parameter complexEquivalent for G to be given,
# see the output of RealIrreducibles.
# The function below computes the dimension of the fixed point set realModule^H.
InstallGlobalFunction( OFPFixedPointDimensionRealModule, function( realModule, H, G, complexEquivalent )
  return Sum( realModule,
              irrComponent -> OFPFixedPointDimensionIrr( LookupDictionary( complexEquivalent,
                                                                        irrComponent[1] ), H, G )
                              *irrComponent[2] );
end );

# The function below computes the list of real G-modules of dimension dim.
InstallGlobalFunction( OFPModulesGivenDimension, function( dim, G )
  local summandOccurrencesInGivenPartition, partition, summand, summands, restrictions,
  ir, restup, unorderedTuples, result, multiplicities, tempModule, temp, i, realIrr;
  summandOccurrencesInGivenPartition := [];
  result := [];
  realIrr := OFPRealIrreducibles( G );
  for partition in RestrictedPartitions( dim, realIrr.dimensionsRealModules ) do
    for i in realIrr.dimensionsRealModules do
      summandOccurrencesInGivenPartition[i] := 0;
    od;
    for summand in partition do
      summandOccurrencesInGivenPartition[summand] := summandOccurrencesInGivenPartition[summand]+1;
    od;
    restrictions := [];
    unorderedTuples := [];
    summands := Set( partition );
    for summand in summands do
      unorderedTuples[summand] := UnorderedTuples( realIrr.realIrrOfDim[summand],
      summandOccurrencesInGivenPartition[summand] );
      Add( restrictions, Size( unorderedTuples[summand] ) );
    od;
    for restup in OFPLexSmallerTuples( restrictions ) do
      multiplicities := List( realIrr.realIrreducibles, x -> 0 );
      for i in [1..Size( summands )] do
        for tempModule in unorderedTuples[summands[i]][restup[i]] do
          temp := LookupDictionary( realIrr.realIrrNr, tempModule );
          multiplicities[temp] := multiplicities[temp]+1;
        od;
      od;
      Add( result, Filtered( List( [1..Size( realIrr.realIrreducibles )],
      i -> [LookupDictionary( realIrr.realIrrNrReversed, i ),
      multiplicities[i]] ),
      x -> x[2]>0 ) );
    od;
  od;
  return result;
end );

# Let G be a group.
# The function below computes good subgroup triples of G of type A and B
# and returns them in the record containing these triples in two separate lists.
# For the explanation, see my PhD thesis [2], Definition 5.18 and Definition 5.19.
# Remark: the order in the triples is different than in my PhD thesis - the first
# and the third component are switched.
InstallGlobalFunction( OFPSubgroupTriples, function( G )
  local subgroupTriplesTypeA, subgroupTriplesTypeB, H1, H2, clP, P;
  subgroupTriplesTypeA := [];
  subgroupTriplesTypeB := [];
  for H1 in AllSubgroups( G ) do
    if Order( H1 ) > 1 then
      for H2 in Filtered( AllSubgroups( G ), H -> Order( H )<=Order( H1 ) ) do
        if Order( OFPGroupGeneratedBySubgroups( H1, H2 ) ) = Order( G ) then
          for clP in ConjugacyClassesSubgroups( Intersection( H1, H2 ) ) do
            P := Representative( clP );
            if IsPGroup( P ) then
              if not OFPIsOliver( H1 ) and not OFPIsOliver( H2 ) then
                Add(
                subgroupTriplesTypeA,
                Immutable( [ConjugacyClassSubgroups( G, H1 ),
                ConjugacyClassSubgroups( G, H2 ),
                ConjugacyClassSubgroups( G, P )] )
                );
              fi;
              if IsEvenInt( Order( P ) ) or # ie. order(P)=2^k since we know that P is prime power group
                (IsOddInt( Order( H1 ) ) and IsOddInt( Order( H2 ) )) or
                (IsNormal( H1, P ) and IsNormal( H2, P ) and IsOddInt( IndexNC( H1, P ) ) and
                IsOddInt( IndexNC( H2, P ) )) then
                Add(
                subgroupTriplesTypeB,
                Immutable( [ConjugacyClassSubgroups( G, H1 ),
                ConjugacyClassSubgroups( G, H2 ),
                ConjugacyClassSubgroups( G, P )] )
                );
              fi;
            fi;
          od;
        fi;
      od;
    fi;
  od;
  return rec( subgroupTriplesTypeA := Set( subgroupTriplesTypeA ),
              subgroupTriplesTypeB := Set( subgroupTriplesTypeB ) );
end );
