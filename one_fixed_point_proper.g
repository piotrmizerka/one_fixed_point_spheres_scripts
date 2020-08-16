# Read( Filename( [DirectoryDesktop(), DirectoryCurrent()], "one_fixed_point_proper.g" ) );

Read( Filename( [DirectoryDesktop(), DirectoryCurrent()], "one_fixed_point_init.g" ) );

computeModulesNotExcludedOdd := function( G )
	local groupId, V, triple, dimH1, dimH2, dimP, H, i, j, check;
	groupId := IdGroup( G );
	realIrr( G );
	modulesNotExcludedOdd[groupId[1]][groupId[2]] := Set( modulesGivenDimension[groupId[1]][groupId[2]] );
	i := 1;
	for V in modulesGivenDimension[groupId[1]][groupId[2]] do
		check := false;
		#Print( "Excluding odd fixed point actions: analyzing module no ", i, " for SG", IdGroup( G ), " out of ",
		#		Size( modulesGivenDimension[groupId[1]][groupId[2]] ), " modules of given dimension\n" );
		for triple in subgroupTriplesTypeA[groupId[1]][groupId[2]] do
			if fixedPointDimensionRealModule( V, Representative( triple[3] ), G ) = 0 then
				Print( "odd type A\n" );
				RemoveSet( modulesNotExcludedOdd[groupId[1]][groupId[2]], V );
				check := true;
				break;
			fi;
		od;
		if check = false and rankD[groupId[1]][groupId[2]] = nontrivialRealIrreduciblesNumber[groupId[1]][groupId[2]] then
			Print( "odd type B1\n" );
			for triple in subgroupTriplesTypeB[groupId[1]][groupId[2]] do
				dimH1 := fixedPointDimensionRealModule( V, Representative( triple[1] ), G );
				dimH2 := fixedPointDimensionRealModule( V, Representative( triple[2] ), G );
				dimP := fixedPointDimensionRealModule( V, Representative( triple[3] ), G );
				if dimH1+dimH2 = dimP and dimH1*dimH2 > 0 then
					Print( "odd type B2\n" );
					RemoveSet( modulesNotExcludedOdd[groupId[1]][groupId[2]], V );
					break;
				fi;
			od;
		fi;
		i := i+1;
	od;
	for H in index2Subgroups[groupId[1]][groupId[2]] do
		if H in groupsExcludedOdd then
			Print( "odd index 2\n" );
			modulesNotExcludedOdd[groupId[1]][groupId[2]] := [];
			break;
		fi;
	od;
	if Size( modulesNotExcludedOdd[groupId[1]][groupId[2]] ) = 0 then
		Print( "odd all excluded\n" );
		Add( groupsExcludedOdd, G );
	fi;
end;

computeModulesNotExcludedOddGivenList := function( groupList )
	local G;
	for G in groupList do
		computeModulesNotExcludedOdd( G );
	od;
end;

computeModulesNotExcludedOne := function( G )
	local groupId, V, triple, dimH1, dimH2, dimP, i;
	groupId := IdGroup( G );
	realIrr( G );
	modulesNotExcludedOne[groupId[1]][groupId[2]] := Set( modulesNotExcludedOdd[groupId[1]][groupId[2]] );
	i := 1;
	for V in modulesNotExcludedOdd[groupId[1]][groupId[2]] do
		#Print( "Excluding one fixed point actions: analyzing module no ", i, " for SG", IdGroup( G ), " out of ",
		#		Size( modulesNotExcludedOdd[groupId[1]][groupId[2]] ), " modules of not excluded odd\n" );
		for triple in subgroupTriplesTypeB[groupId[1]][groupId[2]] do
			dimH1 := fixedPointDimensionRealModule( V, Representative( triple[1] ), G );
			dimH2 := fixedPointDimensionRealModule( V, Representative( triple[2] ), G );
			dimP := fixedPointDimensionRealModule( V, Representative( triple[3] ), G );
			if dimH1+dimH2 = dimP and dimH1*dimH2 > 0 then
				Print( "one type B\n" );
				RemoveSet( modulesNotExcludedOne[groupId[1]][groupId[2]], V );
				break;
			fi;
		od;
		if Size( index2SubgroupIntersection[groupId[1]][groupId[2]] ) > 0 then
			if fixedPointDimensionRealModule( V, index2SubgroupIntersection[groupId[1]][groupId[2]], G ) > 0 then
				Print( "one index 2\n" );
				RemoveSet( modulesNotExcludedOne[groupId[1]][groupId[2]], V );
			fi;
		fi;
		i := i+1;
	od;
end;

# Main function to call
computeMNOneOliverGroupsUpToOrder := function( n, order )
	local GOli;
	init( n, order );
	Display(groupsOddList);
	computeModulesNotExcludedOddGivenList( groupsOddList );
	for GOli in oliverGroups do
		if Order( GOli ) <= order then
			Print( "G = ", IdGroup( GOli ), "\n" );
			computeModulesNotExcludedOne( GOli );
		fi;
	od;
end;
