# To load this file from the project directory (assuming GAP is launched in this directory), call
# Read( Filename( [DirectoryCurrent()], "level_1_functions.g" ) );

Read( Filename( [DirectoryCurrent()], "level_0_functions.g" ) );


# Let ir be the irreducible character of a group G (that is, the element of Irr(G)) and H<=G.
# Suppose V is the irreducible real G-module with character ir.
# The function below computes the dimension of the fixed point set V^H.
FixedPointDimensionIrr := function( ir, H, G )
	local result;
	result := Sum( H, h-> h^ir / Order( H ) )
    if FrobeniusSchurIndicator( ir, G ) <> 1 then
        return 2*result;
    else
        return result;
    fi;
end;

# Let groupList be a list of groups ordered increasingly according to the order.
# The function below computes the list of the following 4 objects (in that order):
# - index2Subgroups - the list of lists of index 2 subgroups of the groups from groupList, which satisfy
#		the assumptions of Proposition 2.9 from [1] - for a given group id, it contains the list
#		of index 2 subgroups of the corresponding groups,
# - index2SubgroupIntersection - the list of subgroups which are the intersections of index 2 subgroups of groups
#		from groupList - for a given group id, it contains the subgroup being the intersection
#		of index 2 subgroups of the corresponding group from gropList,
# - groupsOddList2 - the list of groups containing the groups from groupList and their index 2 subgroups
#		satisying the assumptions of Proposition 2.9 from [1],
# - groupsOddListId - the SmallGroup library ids of the groups from the list above.

# TODO: record
#     gap> r := rec( a := 1, b := 2 );;
#     gap> r.a;
#     1
#     gap> r.b;
#     2

Index2StrategyData := function( groupList )
	local index2SubgroupsTemp, H, groupId, G,
				index2Subgroups, index2SubgroupIntersection, groupsOddList, groupsOddList2;
	index2Subgroups := [];
	index2SubgroupIntersection := [];
	groupsOddList := [];
	groupsOddList2 := [];
	for G in groupList do
		groupId := IdGroup( G );
		index2Subgroups[groupId[1]] := [];
		index2SubgroupIntersection[groupId[1]] := [];
	od;
	for G in groupList do
		index2SubgroupsTemp := [];
		groupId := IdGroup( G );
		for H in NormalSubgroups( G ) do
			if Order( G )/Order( H ) = 2 then
				Add( index2SubgroupsTemp, H );
			fi;
		od;
		if (IdGroup( G ) in groupsOddList) = false then
			Add( groupsOddList, IdGroup( G ) );
			Add( groupsOddList2, G );
		fi;
		if Size( index2SubgroupsTemp ) > 0 then
			index2SubgroupIntersection[groupId[1]][groupId[2]] := Intersection( index2SubgroupsTemp );
		else
			index2SubgroupIntersection[groupId[1]][groupId[2]] := [];
		fi;
		index2Subgroups[groupId[1]][groupId[2]] := [];
		for H in index2SubgroupsTemp do
			if SatisfiesProposition29( H ) then
				Add( index2Subgroups[groupId[1]][groupId[2]], H );
				if (IdGroup( H ) in groupsOddList) = false then
					Add( groupsOddList, IdGroup( H ) );
					Add( groupsOddList2, H );
				fi;
			fi;
		od;
	od;
	SortBy( groupsOddList, First );

	return [index2Subgroups, index2SubgroupIntersection, groupsOddList2, groupsOddList];
# 	return rec( index2Subgroups := index2Subgroups,
#       index2SubgroupIntersection := index2SubgroupIntersection, 
#       groupsOddList2 := groupsOddList2,
#       groupsOddListId := groupsOddList );
end;

# Let G be a group and realModule be a list of pairs representing characters of a given real G-module:
# - the first coordinate of the i-th pair is the list of characters evaluated on conjugacy classes of G
#   of the i-th irreducible real G-module,
# - the second coordinate of the i-th pair is the number of copies of the i-th irreducible real G-module
#   which occur in realModule.
# The function below checks whether realModule is faithful.
IsFaithful := function( realModule, G )
	local characters;
	characters := RealModuleCharacters( realModule, G );
    trivialchar := TrivialCharacter( G );
    
    # TODO: fix the return statement
    
	return not ForAny(characters{[2..Size( characters )]}, chi -> chi = trivialchar );
end;

# The function below checks whether a group G is an Oliver group. The reference to the algebraic
#	characterization of Oliver groups from my PhD thesis [2] is Theorem 4.1. The characterization is
# as follows. G is an Oliver group iff it does not contain a sequence of sbgroups P<=H<=G such that:
# - P is normal in H and H is normal in G,
# - P and G/H are groups of prime power order (possibly one),
# - H/P is cyclic.
IsOliver := function( G )
	local N, H;
	for H in NormalSubgroups( G ) do
		if IsPrimePowerInt( Order( G )/ Order( H ) ) or Order( G ) = Order( H ) then
			for N in NormalSubgroups( H ) do
				if IsPGroup( N ) and IsCyclic( QuotientGroup( H, N ) ) then
					return false;
				fi;
			od;
		fi;
	od;
	return true;
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
ModulesGivenDimension := function( dim, G, realIrreducibles, dimensionsRealModules, realIrrOfDim, realIrrNr, realIrrNrReversed )
  local restrictedPartitions, numberInPartitionDim, n, partition, summand, summands,
	      restrictions, set, ir, resTup, restup, unTup, uT, result, realModule,
	      multiplicities, tempModule, temp, temp2, i, groupId;
  numberInPartitionDim := [];
  restrictedPartitions := RestrictedPartitions( dim, dimensionsRealModules );
  result := [];
  for partition in restrictedPartitions do
    for n in dimensionsRealModules do
      numberInPartitionDim[n] := 0;
    od;
    summands := [];
    for summand in partition do
      numberInPartitionDim[summand] := numberInPartitionDim[summand]+1;
        if ( summand in summands ) = false then
          Add( summands, summand );
        fi;
    od;
    restrictions := [];
    unTup := [];
    for summand in summands do
      set := [];
      for ir in realIrrOfDim[summand] do
        Add( set, ir );
      od;
      uT := [];
      uT := UnorderedTuples( set, numberInPartitionDim[summand] );
      unTup[summand] := uT;
      Add( restrictions, Size( unTup[summand] ) );
    od;
    resTup := RestrictedTuples( restrictions );
    for restup in resTup do
      multiplicities := [];
      realModule := [];
      for ir in realIrreducibles do
        Add( multiplicities, 0 );
      od;
      for i in [1..Size(summands)] do
        for tempModule in unTup[summands[i]][restup[i]] do
          temp := LookupDictionary( realIrrNr, tempModule );
          multiplicities[temp] := multiplicities[temp]+1;
        od;
      od;
      for i in [1..Size(realIrreducibles)] do
        if multiplicities[i] > 0 then
          temp2 := [];
          Add( temp2, LookupDictionary( realIrrNrReversed, i ) );
          Add( temp2, multiplicities[i] );
          Add( realModule, temp2 );
        fi;
      od;
      Add( result, realModule );
    od;
  od;
  return result;
end;

# Let G be a group.
# The function below computes the list of the following 6 objects (in that order):
# - realIrreducibles -  the list of the characters of the real irreducible representations of G,
# - dimensionsRealModules - the set containing the dimensions of the real irreducible representations of G (saved in a list),
# - realIrrOfDim - the list conatining real irreducible characters of G of given dimension (for all dimensions) - when
#   the dimension given, gives all the irreducible characters of this dimension,
# - complexEquivalent - the dictionary containing complex irreducible characters of G corresponding to the real ones,
# - realIrrNr - the dictionary containing the numbers of real irreducible characters of G (we mark them by indices) -
#   when the irreducible character is given (that is a list of characters for each conjugacy class of G),
#   the dictionary returns its number,
# - realIrrNrReversed - the inverse dictionary to the dictionary above (once the number is given, it returns the character).
RealIrreducibles := function( G )
	local irr, ir, row, cl, ind, complexIrr, complexirr, check, n, considered, i, trivialModule,
        realIrreducibles, dimensionsRealModules, realIrrOfDim, complexEquivalent, realIrrNr,
        realIrrNrReversed, result;
  realIrreducibles := [];
  dimensionsRealModules := [];
  realIrrOfDim := [];
  complexEquivalent := NewDictionary( [], true );
  realIrrNr := NewDictionary( [], true );
  realIrrNrReversed := NewDictionary( 1, true );
	irr := Irr( G );
	complexIrr := [];
	considered := [];
	i := 1;
	trivialModule := [];
	for cl in ConjugacyClasses( G ) do
		Add( trivialModule, 1 );
	od;
	for ir in irr do
		row := [];
		ind := FrobeniusSchurIndicator( ir, G );
		if ind = 1 then
			for cl in ConjugacyClasses( G ) do
				Add( row, Representative( cl )^ir );
			od;
			if row <> trivialModule then
				Add( realIrreducibles, row );
				AddDictionary( complexEquivalent, row, ir );
				realIrrOfDim[row[1]] := [];
				considered[row[1]] := false;
				AddDictionary( realIrrNr, row, i );
				AddDictionary( realIrrNrReversed, i, row );
				i := i+1;
			fi;
		elif ind = -1 then
			for cl in ConjugacyClasses( G ) do
				Add( row, 2*RealPart( Representative( cl )^ir ) );
			od;
			Add( realIrreducibles, row );
			AddDictionary( complexEquivalent, row, ir );
			realIrrOfDim[row[1]] := [];
			considered[row[1]] := false;
			AddDictionary( realIrrNr, row, i );
			AddDictionary( realIrrNrReversed, i, row );
			i := i+1;
		else
			for cl in ConjugacyClasses( G ) do
				Add( row, 2*RealPart( Representative( cl )^ir ) );
			od;
			check := true;
			for complexirr in complexIrr do
				if complexirr = row then
					check := false;
					break;
				fi;
			od;
			if check = true then
				Add( realIrreducibles, row );
				Add( complexIrr, row );
				AddDictionary( complexEquivalent, row, ir );
				realIrrOfDim[row[1]] := [];
				considered[row[1]] := false;
				AddDictionary( realIrrNr, row, i );
				AddDictionary( realIrrNrReversed, i, row );
				i := i+1;
			fi;
		fi;
	od;
	for ir in realIrreducibles do
		Add( realIrrOfDim[ir[1]], ir );
		if considered[ir[1]] = false then
			Add( dimensionsRealModules, ir[1] );
			considered[ir[1]] := true;
		fi;
	od;
  return [realIrreducibles, dimensionsRealModules, realIrrOfDim, complexEquivalent, realIrrNr, realIrrNrReversed]
end;
