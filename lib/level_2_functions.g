# To load this file from the project directory (assuming GAP is launched in this directory), call
# Read( Filename( [DirectoryCurrent()], "level_2_functions.g" ) );

Read( Filename( [DirectoryCurrent()], "level_1_functions.g" ) );


# Let realModule be the real G-module (written in the same format as the parameter
#	in the level 0 function RealModuleCharacters) and H<=G.
# Requires additionally the parameter complexEquivalent for G to be given,
# see the output of RealIrreducibles.
# The function below computes the dimension of the fixed point set realModule^H.
FixedPointDimensionRealModule := function( realModule, H, G, complexEquivalent )
	return Sum( realModule,
	 						irrComponent -> FixedPointDimensionIrr( LookupDictionary( complexEquivalent,
																																				irrComponent[1] ), H, G )
															*irrComponent[2] );
end;

# The function below computes the list of real G-modules of dimension dim.
# It requires additionally the following parameters:
# - realIrreducibles - the list of the characters of the real irreducible representations of G,
# - dimensionsRealModules - the set containing the dimensions of the real irreducible
#		representations of G (saved in a list),
# - realIrrOfDim - the list conatining real irreducible characters of G of given dimension
#		(for all dimensions) - when the dimension given, gives all the irreducible characters of this dimension,
# - realIrrNr - the dictionary containing numbers of irreducible characters of G,
# - realIrrNrReversed - the dictionary containing irreducible characters of G - once the id of
#		the character is given, it returns the character.
# The parameters above are also the ingredients of the output of RealIrreducibles function.
ModulesGivenDimension := function( dim, G )
  local summandOccurrencesInGivenPartition, partition, summand, summands, restrictions,
				ir, restup, unorderedTuples, result, multiplicities, tempModule, temp, i, realIrr;
  summandOccurrencesInGivenPartition := [];
  result := [];
	realIrr := RealIrreducibles( G );
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
    for restup in LexSmallerTuples( restrictions ) do
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
end;

# The function below computes all the Oliver groups of orders up to a given order.
OliverGroupsUpToOrder := function( order )
	local G, n, result;
  result := [];
	for n in [60..order] do
		if IsPrimePowerInt( n ) = false then
			for G in AllSmallGroups( n ) do
				if IsOliver( G ) then
					Add( result, G );
				fi;
			od;
		fi;
	od;
  return result;
end;

# Let G be a group.
# The function below computes good subgroup triples of G of type A and B
# and returns them in the record containing these triples in two separate lists.
# For the explanation, see my PhD thesis [2], Definition 5.18 and Definition 5.19.
# Remark: the order in the triples is different than in my PhD thesis - the first
# and the third component are switched.
SubgroupTriples := function( G )
	local subgroupTriplesTypeA, subgroupTriplesTypeB, H1, H2, clP, P;
	subgroupTriplesTypeA := [];
	subgroupTriplesTypeB := [];
			for H1 in AllSubgroups( G ) do
				for H2 in Filtered( AllSubgroups( G ), H -> Order( H )<=Order( H1 ) ) do
					if GroupByGeneratingSubsets( H1, H2 ) = G then
						for clP in ConjugacyClassesSubgroups( Intersection( H1, H2 ) ) do
							P := Representative( clP );
							if IsPGroup( P ) then
								if ( IsOliver( H1 ) = false ) and ( IsOliver( H2 ) = false ) then
									Add( subgroupTriplesTypeA, Immutable( [ConjugacyClassSubgroups( G, H1 ),
																												 ConjugacyClassSubgroups( G, H2 ),
																												 ConjugacyClassSubgroups( G, P )] ) );
								fi;
								if (Order( P ) mod 2) = 0 or ((Order( H1 ) mod 2) = 1 and (Order( H2 ) mod 2) = 1) or
									 (IsNormal( H1, P ) and IsNormal( H2, P ) and (IndexNC( H1, P ) mod 2 = 1) and
									   (IndexNC( H2, P ) mod 2 = 1)) then
									Add( subgroupTriplesTypeB, Immutable( [ConjugacyClassSubgroups( G, H1 ),
																												 ConjugacyClassSubgroups( G, H2 ),
																												 ConjugacyClassSubgroups( G, P )] ) );
								fi;
							fi;
						od;
					fi;
				od;
			od;
	return rec( subgroupTriplesTypeA := Set( subgroupTriplesTypeA ),
							subgroupTriplesTypeB := Set( subgroupTriplesTypeB ) );
end;
