# Read( Filename( [DirectoryDesktop(), DirectoryCurrent()], "one_fixed_point_init.g" ) );

modulesGivenDimension := [];
modulesNotExcludedOdd := [];
groupsExcludedOdd := [];
modulesNotExcludedOne := [];
index2Subgroups := [];
index2SubgroupIntersection := [];
subgroupTriplesTypeA := [];
subgroupTriplesTypeB := [];
rankD := [];
nontrivialRealIrreduciblesNumber := [];
oliverGroups := [];

quotientGroup := function( G, N )
	return Image( NaturalHomomorphismByNormalSubgroup( G, N ) );
end;

isOliver := function( G )
	local N, H;
	for H in NormalSubgroups( G ) do
		if IsPrimePowerInt( Order( G )/ Order( H ) ) or Order( G ) = Order( H ) then
			for N in NormalSubgroups( H ) do
				if IsPGroup( N ) and IsCyclic( quotientGroup( H, N ) ) then
					return false;
				fi;
			od;
		fi;
	od;
	return true;
end;

determineOliverGroupsUpToOrder := function( order )
	local G, n;
	for n in [60..order] do
		for G in AllSmallGroups( n ) do
			if isOliver( G ) then
				Add( oliverGroups, G );
			fi;
		od;
	od;
end;

complexEquivalent := NewDictionary( [], true );
realIrreducibles := [];
dimensionsRealModules := [];
realIrrOfDim := [];
numberRealIrrOfDim := [];
realIrrNr := NewDictionary( [], true );
realIrrNrReversed := NewDictionary( 1, true );
conjugacyClassesSubgroups := NewDictionary( SmallGroup( 1,1 ), true );

frobeniusSchurIndicator := function( chi, G )
	local result, cl, repr;
	result := 0;
	for cl in ConjugacyClasses( G ) do
		repr := Representative( cl );
		result := result+Size( cl )*( repr*repr )^chi;
	od;
	result := result/Order( G );
	return result;
end;

realIrr := function( G )
	local irr, ir, row, cl, ind, complexIrr, complexirr, check, n, considered, i, trivialModule;
	irr := Irr( G );
	complexIrr := [];
	complexEquivalent := NewDictionary( [], true );
	realIrreducibles := [];
	dimensionsRealModules := [];
	considered := [];
	realIrrOfDim := [];
	numberRealIrrOfDim := [];
	realIrrNr := NewDictionary( [], true );
	realIrrNrReversed := NewDictionary( 1, true );
	i := 1;
	trivialModule := [];
	for cl in ConjugacyClasses( G ) do
		Add( trivialModule, 1 );
	od;
	for ir in irr do
		row := [];
		ind := frobeniusSchurIndicator( ir, G );
		if ind = 1 then
			for cl in ConjugacyClasses( G ) do
				Add( row, Representative( cl )^ir );
			od;
			if row <> trivialModule then
				Add( realIrreducibles, row );
				AddDictionary( complexEquivalent, row, ir );
				realIrrOfDim[row[1]] := [];
				considered[row[1]] := false;
				numberRealIrrOfDim[row[1]] := 0;
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
			numberRealIrrOfDim[row[1]] := 0;
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
				numberRealIrrOfDim[row[1]] := 0;
				AddDictionary( realIrrNr, row, i );
				AddDictionary( realIrrNrReversed, i, row );
				i := i+1;
			fi;
		fi;
	od;
	for ir in realIrreducibles do
		Add( realIrrOfDim[ir[1]], ir );
		numberRealIrrOfDim[ir[1]] := numberRealIrrOfDim[ir[1]]+1;
		if considered[ir[1]] = false then
			Add( dimensionsRealModules, ir[1] );
			considered[ir[1]] := true;
		fi;
	od;
end;

realModuleCharacters := function( realModule, G )
	local irrComponent, result, temp, cl, g, i;
	result := [];
	for i in [1..Size( ConjugacyClasses( G ) )] do
		temp := 0;
		for irrComponent in realModule do
			temp := temp+irrComponent[1][i]*irrComponent[2];
		od;
		Add( result, temp );
	od;
	return result;
end;

isFaithful := function( realModule, G )
	local characters, i;
	characters := realModuleCharacters( realModule, G );
	for i in [2..Size( characters )] do
		if characters[i] = characters[1] then
			return false;
		fi;
	od;
	return true;
end;

realModuleDimension := function( realModule, G )
	local characters, result;
	characters := realModuleCharacters( realModule, G );
	result := characters[1];
	return result;
end;

restrictedTuples := function( restrictions )
	local result, tuple, finalTuple, res, coord, value, i, temp, tuple2;
	finalTuple := [];
	tuple := [];
	coord := Size( restrictions );
	value := 1;
	result := [];
	for res in restrictions do
		Add( finalTuple, res );
		Add( tuple, 1 );
	od;
	temp := 1;
	while tuple <> finalTuple and temp < 100 do
		tuple2 := [];
		for i in [1..Size( restrictions )] do
			Add( tuple2, tuple[i] );
		od;
		Add( result, tuple2 );
		while tuple[coord]+1 > restrictions[coord] do
			coord := coord-1;
		od;
		tuple[coord] := tuple[coord]+1;
		for i in [(coord+1)..Size(restrictions)] do
			tuple[i] := 1;
		od;
		coord := Size( restrictions );
		temp := temp+1;
	od;
	Add( result, finalTuple );
	return result;
end;

determineModules := function( dim, G )
	local restrictedPartitions, numberInPartitionDim, n, partition, summand, summands, 
		  restrictions, set, ir, resTup, restup, unTup, uT, result, realModule, 
		  multiplicities, tempModule, temp, temp2, i, modulesGivenDimensionTemp, groupId;
	numberInPartitionDim := [];
	restrictedPartitions := RestrictedPartitions( dim, dimensionsRealModules );
	modulesGivenDimensionTemp := [];
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
		resTup := restrictedTuples( restrictions );
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
			#if isFaithful( realModule, G ) = true then
			#	Add( result, realModule );
			#fi;
		od;
	od;
	modulesGivenDimensionTemp := result;
	groupId := IdGroup( G );
	modulesGivenDimension[groupId[1]][groupId[2]] := modulesGivenDimensionTemp;
end;

fixedPointDimensionIrr := function( ir, H, G )
	local result, h;
	result := 0;
	for h in H do
		result := result+h^ir;
	od;
	result := result/Order( H );
	if frobeniusSchurIndicator( ir, G ) <> 1 then
		result := result*2;
	fi;
	return result;
end;

fixedPointDimensionRealModule := function( realModule, H, G )
	local result, irrComponent;
	result := 0;
	for irrComponent in realModule do
		result := result+fixedPointDimensionIrr( LookupDictionary( complexEquivalent, irrComponent[1] ), H, G )*irrComponent[2];
	od;
	return result;
end;

tableFixedPointDimension := function( G )
	local H, row, ir, temp, temp2, text;
	row := [];
	Print( "      " );
	for H in ConjugacyClassesSubgroups( G ) do
		Print( LookupDictionary( conjugacyClassesSubgroups, H ), "  " );
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
			Add( row, fixedPointDimensionRealModule( temp2, Representative( H ), G ) );
		od;
		Print( "X.", LookupDictionary( realIrrNr, ir ), " " );
		Display( row );
	od;
	Print( "\n" );
	for H in ConjugacyClassesSubgroups( G ) do
		Print( LookupDictionary( conjugacyClassesSubgroups, H ), " = ", 
			   StructureDescription( Representative( H ) ), "\n" );
	od;
	Print( "\n\n" );
end;

determineIndex2Subgroups := function( G )
	local index2SubgroupsTemp, H, groupId;
	index2SubgroupsTemp := [];
	groupId := IdGroup( G );
	for H in NormalSubgroups( G ) do
		if Order( G )/Order( H ) = 2 then
			Add( index2SubgroupsTemp, H );
		fi;
	od;
	index2Subgroups[groupId[1]][groupId[2]] := index2SubgroupsTemp;
	if Size( index2SubgroupsTemp ) > 0 then
		index2SubgroupIntersection[groupId[1]][groupId[2]] := Intersection( index2SubgroupsTemp );
	else
		index2SubgroupIntersection[groupId[1]][groupId[2]] := [];
	fi;
end;

groupByGeneratingSubgroups := function( H1, H2 )
	local result, h, set;
	set := [];
	for h in H1 do
		Add( set, h );
	od;
	for h in H2 do
		Add( set, h );
	od;
	result := GroupByGenerators( set );
	return result;
end;

determineSubgroupTriples := function( G )
	local H1, H2, cl1, cl2, conjugacyClassesSubgroups, clP, H, P, temp, groupId;
	conjugacyClassesSubgroups := ConjugacyClassesSubgroups( G );
	groupId := IdGroup( G );
	subgroupTriplesTypeA[groupId[1]][groupId[2]] := [];
	subgroupTriplesTypeB[groupId[1]][groupId[2]] := [];
	for cl1 in conjugacyClassesSubgroups do
		for cl2 in conjugacyClassesSubgroups do
			for H1 in cl1 do
				for H2 in cl2 do
					if groupByGeneratingSubgroups( H1, H2 ) = G then
						H := Intersection( H1, H2 );
						for clP in ConjugacyClassesSubgroups( H ) do
							P := Representative( clP );
							if IsPGroup( P ) then
								if ( isOliver( H1 ) = false ) and ( isOliver( H2 ) = false ) then
									temp := [];
									Add( temp, cl1 );
									Add( temp, cl2 );
									Add( temp, clP );
									if ( temp in subgroupTriplesTypeA[groupId[1]][groupId[2]] ) = false then
										Add( subgroupTriplesTypeA[groupId[1]][groupId[2]], temp );
									fi;
								fi;
								temp := [];
								Add( temp, cl1 );
								Add( temp, cl2 );
								Add( temp, clP );
								if ( temp in subgroupTriplesTypeB[groupId[1]][groupId[2]] ) = false then
									Add( subgroupTriplesTypeB[groupId[1]][groupId[2]], temp );
								fi;
							fi;
						od;
					fi;
				od;
			od;
		od;
	od;
end;

determineRankD := function( G )
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
			Add( row, fixedPointDimensionRealModule( [[irrx,1]], P, G ) );
		od;
		Add( D, row );
	od;
	groupId := IdGroup( G );
	rankD[groupId[1]][groupId[2]] := RankMat( D );
end;

init := function( n, order )
	local GOli, groupId, i;
	
	modulesGivenDimension := [];
	modulesNotExcludedOdd := [];
	groupsExcludedOdd := [];
	modulesNotExcludedOne := [];
	index2Subgroups := [];
	index2SubgroupIntersection := [];
	subgroupTriplesTypeA := [];
	subgroupTriplesTypeB := [];
	rankD := [];
	nontrivialRealIrreduciblesNumber := [];
	oliverGroups := [];
	
	for i in [60..order] do
		modulesGivenDimension[i] := [];
		index2Subgroups[i] := [];
		index2SubgroupIntersection[i] := [];
		subgroupTriplesTypeA[i] := [];
		subgroupTriplesTypeB[i] := [];
		rankD[i] := [];
		nontrivialRealIrreduciblesNumber[i] := [];
		modulesNotExcludedOdd[i] := [];
		modulesNotExcludedOne[i] := [];
	od;
	determineOliverGroupsUpToOrder( order );
	for GOli in oliverGroups do
		Print( "Initializing SG", IdGroup( GOli ), " \n" );
		realIrr( GOli );
		determineModules( n, GOli );
		determineIndex2Subgroups( GOli );
		groupId := IdGroup( GOli );
		nontrivialRealIrreduciblesNumber[groupId[1]][groupId[2]] := Size( realIrreducibles );
		determineSubgroupTriples( GOli );
		determineRankD( GOli );
	od;
end;