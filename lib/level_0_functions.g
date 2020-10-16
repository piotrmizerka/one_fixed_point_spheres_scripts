# To load this file from the project directory (assuming GAP is launched in this directory), call
# Read( Filename( [DirectoryCurrent()], "level_0_functions.g" ) );


# Let chi be the irreducible character of a group G (that is, the element of Irr(G)).
# The function below computes the Frobenius-Schur indicator of chi.
FrobeniusSchurIndicator := function( chi, G )
	return Sum( ConjugacyClasses( G ),
      cl -> ( Size( cl ) * ( Representative(cl)^2 )^chi ) / Order( G ) );
end;

GroupGeneratedBySubgroups := function( G1, G2 )
    return Group( Union( GeneratingSetOfGroup( G1 ), GeneratingSetOfGroup( G2 ) ) );
end;

# The function below returns the list of all index two subgroups of G
Index2Subgroups := function( G )
    return Filtered( MaximalNormalSubgroups( G ), H -> IndexNC( G, H ) = 2 );
end;

# Let N be a normal subgroup of G.
# The function below computes the quotient group G/N.
QuotientGroup := function( G, N )
	return Image( NaturalHomomorphismByNormalSubgroup( G, N ) );
end;

# Let G be a group and realModule be a list of pairs representing characters of a given real G-module:
# - the first entry of the i-th pair is the list of characters evaluated on conjugacy classes of G
#   of the i-th irreducible real G-module,
# - the second entry of the i-th pair is the multiplicity of the i-th irreducible real G-module
#   in realModule.
# The function below computes the values of characters of realModule evaluated on conjugacy classes of G.
RealModuleCharacters := function( realModule, G )
	return List( [1..NrConjugacyClasses( G )],
      idx -> Sum( realModule, irrComponent -> First( irrComponent)[idx]*Last( irrComponent ) ) );
end;

# Let 'tuple' be a list of length n of positive integers.
# The function below computes the list of tuples t[1..n] such that
# t[i] <= tuple[i] for 1<=i<=n.
LexSmallerTuples := function( tuple )
    local result, tempTuple, coordinateToChange, sizeT;
		tempTuple := List( tuple, x -> 1 );
		result := [];
		sizeT := Size( tuple );
		while tempTuple <> tuple do
			Add( result, Immutable( tempTuple ) );
			coordinateToChange := sizeT;
			while tempTuple[coordinateToChange]+1 > tuple[coordinateToChange] do
				coordinateToChange := coordinateToChange-1;
			od;
			tempTuple[coordinateToChange] := tempTuple[coordinateToChange]+1;
			tempTuple{[(coordinateToChange+1)..sizeT]} := List( [(coordinateToChange+1)..sizeT], x -> 1 );
		od;
		Add( result, tuple );
    return result;
end;

# Checks whether the group G satisifes the assumptions of Proposition 2.9 from [1].
SatisfiesProposition29 := function( G )
	local g, ordg, isppo;
	for g in List( ConjugacyClasses( G ), Representative ) do
	    ordg := Order( g );
	    isppo := IsPrimePowerInt( ordg );
		if (ordg <> 1 and not isppo) or (isppo and ordg > 4 and IsEvenInt(ordg)) then
			 return false;
		fi;
	od;
	return true;
end;
