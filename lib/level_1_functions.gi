# Let ir be the irreducible character of a group G (that is, the element of Irr(G)) and H<=G.
# Suppose V is the irreducible complex G-module with character ir.
# The function below computes the dimension of the fixed point set V^H.
InstallGlobalFunction( OFPFixedPointDimensionComplexIrr, function( ir, H, G )
  local h;
  return Sum( H, h-> h^ir )/ Order( H );
end );

# Let ir be the irreducible character of a group G (that is, the element of Irr(G)) and H<=G.
# Suppose V is the irreducible real G-module with character ir.
# The function below computes the dimension of the fixed point set V^H.
InstallGlobalFunction( OFPFixedPointDimensionIrr, function( ir, H, G )
  if OFPFrobeniusSchurIndicator( ir, G ) <> 1 then
    return 2*OFPFixedPointDimensionComplexIrr( ir, H, G );
  else
    return OFPFixedPointDimensionComplexIrr( ir, H, G );
  fi;
end );

# Let G be a group.
# The function below computes the list of index 2 subgroups of G the groups from groupList,
# which satisfy the assumptions of Proposition 2.9 from [1].
InstallGlobalFunction( OFPIndex2SubgroupsSatisfyingProposition29, function( G )
  return Filtered( OFPIndex2Subgroups( G ), H -> OFPSatisfiesProposition29( H ) );
end );

# Let G be a group and realModule be a list of pairs representing characters of a given real G-module:
# - the first coordinate of the i-th pair is the list of characters evaluated on conjugacy classes of G
#   of the i-th irreducible real G-module,
# - the second coordinate of the i-th pair is the number of copies of the i-th irreducible real G-module
#   which occur in realModule.
# The function below checks whether realModule is faithful.
InstallGlobalFunction( OFPIsFaithful, function( realModule, G )
  local characters, i;
  characters := OFPRealModuleCharacters( realModule, G );
  for i in [2..Size( characters )] do
    if characters[i] = characters[1] then
      return false;
    fi;
  od;
  return true;
end );

# The function below computes all the Oliver groups of orders up to a given order.
InstallGlobalFunction( OFPOliverGroupsUpToOrder, function( order )
  local G, n, result;
  result := [];
  for n in [60..order] do
    if not IsPrimePowerInt( n ) then
      Append( result, Filtered( AllSmallGroups( n ), OFPIsOliver ) );
    fi;
  od;
  return result;
end );

# Let G be a group.
# The function below computes the record of the following 6 objects:
# - realIrreducibles -  the list of the characters of the nontrivial real irreducible representations of G,
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
InstallGlobalFunction( OFPRealIrreducibles, function( G )
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
    if OFPFrobeniusSchurIndicator( ir, G ) = 1 then
      row := List( ConjugacyClasses( G ), cl -> Representative( cl )^ir );
    else
      row := List( ConjugacyClasses( G ), cl -> 2*RealPart( Representative( cl )^ir ) );
    fi;
    if row <> trivialModule and not (row in realIrreducibles) then
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
end );
