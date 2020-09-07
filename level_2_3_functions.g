# To load this file from the project directory (assuming GAP is launched in this directory), call
# Read( Filename( [DirectoryCurrent()], "level_2_3_functions.g" ) );

Read( Filename( [DirectoryCurrent()], "level_1_functions.g" ) );


# Let realModule be the real G-module (written in the same format as the parameter
#	in the level 0 function RealModuleCharacters) and H<=G.
# Requires additionally the parameter complexEquivalent for G to be given,
# see the output of RealIrreducibles.
# The function below computes the dimension of the fixed point set realModule^H.
FixedPointDimensionRealModule := function( realModule, H, G, complexEquivalent )
	return Sum(realModule, 
      irrComponent -> FixedPointDimensionIrr( LookupDictionary( complexEquivalent, First(irrComponent)), H, G)*Last(irrComponent));
end;

# Let G be a group.
# The function below computes the list (stored as a set) NAZWA of real G-modules - for the explanation,
# see my PhD thesis [2], ODNOSNIK. We know that the modules in that list cannot occur at tangent
# spaces at fixed point for odd fixed point actions of G on spheres of the same dimension (implicitly given).
# Apart from G, the additional parameters are:
#	- modulesGivenDimension - the list of real G-modules (intentionally of the same dimension),
# - groupsExcludedOdd - the list of groups (intentionally not admitting one fixed point acgtions on spheres),
# - index2Subgroups - the list of subgroups of G (intentionally the index 2 subgroups satisfying
#		the assumptions of Proposition 2.9 from [1]),
# - rankD - the rank of the matrix D_G - for the explanation see my PhD thesis [2], pp. 40 ODNOSNIK
# - nontrivialRealIrreduciblesNumber - an integer (intentionally the number
#		of real irreducible representations of G minus one - the trivial character),
# - subgroupTriplesTypeA - the first list from the output of the level 2 function SubgroupTriples,
# - subgroupTriplesTypeB - the second list from the output of the level 2 function SubgroupTriples.
ModulesNotExcludedOdd := function( G, modulesGivenDimension, groupsExcludedOdd, index2Subgroups, rankD, nontrivialRealIrreduciblesNumber, subgroupTriplesTypeA, subgroupTriplesTypeB )
	local groupId, V, triple, dimH1, dimH2, dimP, H, i, j, check, modulesNotExcludedOdd, realIrr,
				complexEquivalent;
	groupId := IdGroup( G );
	realIrr := RealIrreducibles( G );
	complexEquivalent := realIrr[4];
	modulesNotExcludedOdd := Set( modulesGivenDimension );
	i := 1;
	for V in modulesGivenDimension do
		check := false;
		#Print( "Excluding odd fixed point actions: analyzing module no ", i, " for SG", IdGroup( G ), " out of ",
		#		Size( modulesGivenDimension ), " modules of given dimension\n" );
		for triple in subgroupTriplesTypeA do
			if FixedPointDimensionRealModule( V, Representative( triple[3] ), G, complexEquivalent ) = 0 then
				#Print( "odd type A\n" );
				RemoveSet( modulesNotExcludedOdd, V );
				check := true;
				break;
			fi;
		od;
		if check = false and rankD = nontrivialRealIrreduciblesNumber then
			#Print( "odd type B1\n" );
			for triple in subgroupTriplesTypeB[groupId[1]][groupId[2]] do
				dimH1 := FixedPointDimensionRealModule( V, Representative( triple[1] ), G, complexEquivalent );
				dimH2 := FixedPointDimensionRealModule( V, Representative( triple[2] ), G, complexEquivalent );
				dimP := FixedPointDimensionRealModule( V, Representative( triple[3] ), G, complexEquivalent );
				if dimH1+dimH2 = dimP and dimH1*dimH2 > 0 then
					#Print( "odd type B2\n" );
					RemoveSet( modulesNotExcludedOdd, V );
					break;
				fi;
			od;
		fi;
		i := i+1;
	od;
	for H in index2Subgroups do
		if H in groupsExcludedOdd then
			#Print( "odd index 2\n" );
			modulesNotExcludedOdd := [];
			break;
		fi;
	od;
	return modulesNotExcludedOdd;
end;

# Let G be a group.
# The function below computes the list NAZWA of real G-modules - for the explanation,
# see my PhD thesis [2], ODNOSNIK. We know that the modules in that list cannot occur at tangent
# spaces at fixed point for one fixed point actions of G on spheres of the same dimension (implicitly given).
# Apart from G, the additional parameters are:
#	- modulesNotExcludedOdd - list NAZWA of real G-modules of the same dimension (implicitly given),
# - index2SubgroupIntersection - the intersection of all the index 2 subgroups of G,
# - subgroupTriplesTypeB - the second list from the output of SubgroupTriples.
ModulesNotExcludedOne := function( G, modulesNotExcludedOdd, index2SubgroupIntersection, subgroupTriplesTypeB )
	local groupId, V, triple, dimH1, dimH2, dimP, i, realIrr, complexEquivalent, modulesNotExcludedOne;
	groupId := IdGroup( G );
	realIrr := RealIrreducibles( G );
	complexEquivalent := realIrr[4];
	modulesNotExcludedOne := Set( modulesNotExcludedOdd );
	i := 1;
	for V in modulesNotExcludedOdd do
		#Print( "Excluding one fixed point actions: analyzing module no ", i, " for SG", IdGroup( G ), " out of ",
		#		Size( modulesNotExcludedOdd ), " modules of not excluded odd\n" );
		for triple in subgroupTriplesTypeB do
			dimH1 := FixedPointDimensionRealModule( V, Representative( triple[1] ), G, complexEquivalent );
			dimH2 := FixedPointDimensionRealModule( V, Representative( triple[2] ), G, complexEquivalent );
			dimP := FixedPointDimensionRealModule( V, Representative( triple[3] ), G, complexEquivalent );
			if dimH1+dimH2 = dimP and dimH1*dimH2 > 0 then
				#Print( "one type B\n" );
				RemoveSet( modulesNotExcludedOne, V );
				break;
			fi;
		od;
		if Size( index2SubgroupIntersection ) > 0 then
			if FixedPointDimensionRealModule( V, index2SubgroupIntersection, G, complexEquivalent ) > 0 then
				#Print( "one index 2\n" );
				RemoveSet( modulesNotExcludedOne, V );
			fi;
		fi;
		i := i+1;
	od;
	return modulesNotExcludedOne;
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

# Let G be a group and realIrreducibles be
#	the list of the characters of the real irreducible representations of G.
# The function below computes the rank of the matrix D_G,
#	for the explanation see my PhD thesis [2], pp. 40 ODNOSNIK.
RankD := function( G, realIrreducibles, complexEquivalent )
	local D, row, P, cl, pSubgroups, irrx, groupId;
	D := [];
	pSubgroups := [];
	for cl in ConjugacyClassesSubgroups( G ) do
		P := Representative( cl );
		if IsPGroup( P ) then
			Add( pSubgroups, P );
		fi;
	od;
	for P in pSubgroups do
		row := [];
		for irrx in realIrreducibles do
			Add( row, FixedPointDimensionRealModule( [[irrx,1]], P, G, complexEquivalent ) );
		od;
		Add( D, row );
	od;
	return RankMat( D );
end;

# Let G be a group.
# The function below computes good subgroup triples of G of type A and B
# and returns them in the object containing these triples (in that order)
# in two separate lists.
# For the explanation, see my PhD thesis [2], Definition 5.18 and Definition 5.19.
SubgroupTriples := function( G )
	local H1, H2, cl1, cl2, conjugacyClassesSubgroups, clP, H, P, temp, groupId,
				subgroupTriplesTypeA, subgroupTriplesTypeB, result;
	conjugacyClassesSubgroups := ConjugacyClassesSubgroups( G );
	groupId := IdGroup( G );
	subgroupTriplesTypeA := [];
	subgroupTriplesTypeB := [];
	result := [];
	for cl1 in conjugacyClassesSubgroups do
		for cl2 in conjugacyClassesSubgroups do
			for H1 in cl1 do
				for H2 in cl2 do
					if GroupByGeneratingSubsets( H1, H2 ) = G then
						H := Intersection( H1, H2 );
						for clP in ConjugacyClassesSubgroups( H ) do
							P := Representative( clP );
							if IsPGroup( P ) then
								if ( IsOliver( H1 ) = false ) and ( IsOliver( H2 ) = false ) then
									temp := [];
									Add( temp, cl1 );
									Add( temp, cl2 );
									Add( temp, clP );
									if ( temp in subgroupTriplesTypeA ) = false then
										Add( subgroupTriplesTypeA, temp );
									fi;
								fi;
								if ((Order(P) mod 2) = 0) or ((Order(H1) mod 2) = 1 and (Order(H2) mod 2) = 1) or
									 (IsNormal(H1,P) and IsNormal(H2,P) and ((Order(H1)/Order(P)) mod 2 = 1) and ((Order(H1)/Order(P)) mod 2 = 1)) then
									temp := [];
									Add( temp, cl1 );
									Add( temp, cl2 );
									Add( temp, clP );
									if ( temp in subgroupTriplesTypeB ) = false then
										Add( subgroupTriplesTypeB, temp );
									fi;
								fi;
							fi;
						od;
					fi;
				od;
			od;
		od;
	od;
	result[1] := subgroupTriplesTypeA;
	result[2] := subgroupTriplesTypeB;
	return result;
end;

# Let G be a group.
# The procedure below (which is not a function in the mathematical sense)
# prints the fixed point dimensions for sugroups of G acting on real irreducible G-modules.
# Additional parameters are:
# - realIrreducibles - the list of the characters of the real irreducible representations of G,
# - realIrrNr - the dictionary containing the numbers of real irreducible characters of G
#		(we mark them by indices) - when the irreducible character is given
#		(that is a list of characters for each conjugacy class of G), the dictionary returns its number.
TableFixedPointDimension := function( G, realIrreducibles, realIrrNr )
	local H, row, ir, temp, temp2, text, i;
	row := [];
	Print( "      " );
	i := 1;
	for H in ConjugacyClassesSubgroups( G ) do
		Print( i, "  " );
		i := i+1;
	od;
	Print( "\n\n" );
	for ir in realIrreducibles do
		row := [];
		temp := [];
		temp2 := [];
		Add( temp, ir );
		Add( temp, 1 );
		Add( temp2, temp );
		for H in ConjugacyClassesSubgroups( G ) do
			Add( row, FixedPointDimensionRealModule( temp2, Representative( H ), G ) );
		od;
		Print( "X.", LookupDictionary( realIrrNr, ir ), " " );
		Display( row );
	od;
	Print( "\n" );
	i := 1;
	for H in ConjugacyClassesSubgroups( G ) do
		Print( i, " = ", StructureDescription( Representative( H ) ), "\n" );
		i := i+1;
	od;
	Print( "\n\n" );
end;
