# To load this file from the project directory (assuming GAP is launched in this directory), call
# Read( Filename( [DirectoryCurrent()], "level_1_functions.g" ) );

Read( Filename( [DirectoryCurrent()], "level_0_functions.g" ) );


# Let ir be the irreducible character of a group G (that is, the element of Irr(G)) and H<=G.
# Suppose V is the irreducible real G-module with character ir.
# The function below computes the dimension of the fixed point set V^H.
FixedPointDimensionIrr := function( ir, H, G )
	local result, h;
	result := Sum( H, h-> h^ir )/ Order( H );
  if FrobeniusSchurIndicator( ir, G ) <> 1 then
    return 2*result;
  else
    return result;
  fi;
end;

# Let G be a group.
# The function below computes the list of index 2 subgroups of G the groups from groupList,
# which satisfy the assumptions of Proposition 2.9 from [1].
Index2SubgroupsSatisfyingProposition29 := function( G )
		return Filtered( Index2Subgroups( G ), H -> SatisfiesProposition29( H ) );
end;

# Let G be a group and realModule be a list of pairs representing characters of a given real G-module:
# - the first coordinate of the i-th pair is the list of characters evaluated on conjugacy classes of G
#   of the i-th irreducible real G-module,
# - the second coordinate of the i-th pair is the number of copies of the i-th irreducible real G-module
#   which occur in realModule.
# The function below checks whether realModule is faithful.
IsFaithful := function( realModule, G )
	local characters, i;
	characters := RealModuleCharacters( realModule, G );
	for i in [2..Size( characters )] do
		if characters[i] = characters[1] then
			return false;
		fi;
	od;
	return true;
end;

# The function below checks whether a group G is an Oliver group. The reference to the algebraic
#	characterization of Oliver groups from my PhD thesis [2] is Definition 4.1. The characterization is
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

# Let G be a group.
# The function below computes the record of the following 6 objects:
# - realIrreducibles -  the list of the characters of the real irreducible representations of G,
# - dimensionsRealModules - the set containing the dimensions of the real irreducible representations of G
#		(saved in a list),
# - realIrrOfDim - the list conatining real irreducible characters of G of given dimension
#		(for all dimensions) - when the dimension given, gives all the irreducible characters of this dimension,
# - complexEquivalent - the dictionary containing complex irreducible characters of G corresponding
#		to the real ones,
# - realIrrNr - the dictionary containing the numbers of real irreducible characters of G
#		(we mark them by indices) - when the irreducible character is given (that is a list of characters
#		for each conjugacy class of G),
#   the dictionary returns its number,
# - realIrrNrReversed - the inverse dictionary to the dictionary above (once the number is given,
#		it returns the character).
RealIrreducibles := function( G )
	local realIrreducibles, dimensionsRealModules, realIrrOfDim, complexEquivalent,
				realIrrNr, realIrrNrReversed, i, trivialModule, ir, row;
  realIrreducibles := [];
  dimensionsRealModules := [];
  realIrrOfDim := [];
  complexEquivalent := NewDictionary( [], true );
  realIrrNr := NewDictionary( [], true );
  realIrrNrReversed := NewDictionary( 1, true );
	i := 1;
	trivialModule := List( ConjugacyClasses( G ), cl -> 1 );
	for ir in Irr( G ) do
		if FrobeniusSchurIndicator( ir, G ) = 1 then
			row := List( ConjugacyClasses( G ), cl -> Representative( cl )^ir );
		else
			row := List( ConjugacyClasses( G ), cl -> 2*RealPart( Representative( cl )^ir ) );
		fi;
		if row <> trivialModule then
			Add( realIrreducibles, row );
			AddDictionary( complexEquivalent, row, ir );
			realIrrOfDim[row[1]] := [];
			AddDictionary( realIrrNr, row, i );
			AddDictionary( realIrrNrReversed, i, row );
			i := i+1;
		fi;
	od;
	dimensionsRealModules := Set( List( realIrreducibles, ir -> ir[1] ) );
	for ir in realIrreducibles do
		Add( realIrrOfDim[ir[1]], ir );
	od;
  return rec( realIrreducibles := realIrreducibles, dimensionsRealModules := dimensionsRealModules,
	 						realIrrOfDim := realIrrOfDim, complexEquivalent := complexEquivalent,
							realIrrNr := realIrrNr, realIrrNrReversed := realIrrNrReversed );
end;
