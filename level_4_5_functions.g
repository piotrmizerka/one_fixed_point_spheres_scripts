# To load this file from the project directory (assuming GAP is launched in this directory), call
# Read( Filename( [DirectoryCurrent()], "level_4_5_functions.g" ) );

Read( Filename( [DirectoryCurrent()], "level_2_3_functions.g" ) );

# Level 4 function.
# The function below initializes most of the data required for the exlcusion algorithm.
# The precise specification is given below.
# Input - a list of the following objects (in that order):
# - n - the dimension of spheres to consider,
# - order - the upper bound for the order of Oliver groups to consider,
# - oliverGroups - a list of Oliver groups (intentionally) to consider (assumed to be ordered increasingly by the order),
# Output - a list of the following objects (in that order):
# - subgroupTriplesTypeA - the list of the first list from the output of the level 2 function SubgroupTriples,
#   for each group from oliverGroups (indexed by IdGroup),
# - subgroupTriplesTypeB - the list of the second list from the output of the level 2 function SubgroupTriples,
#   for each group from oliverGroups (indexed by IdGroup),
# - rankD - the list of the ranks of the matrix D_G for each G in olivergroups,
#	  for the explanation see my PhD thesis [2], pp. 40 ODNOSNIK,
# - nontrivialRealIrreduciblesNumber - a list of integers (intentionally the number
#		of real irreducible representations of G minus one - the trivial character),
#   for each group from oliverGroups,
# - modulesGivenDimension - the of the lists of real G-modules of dimension n for all G in oliverGroups.
Initialize := function( n, order, oliverGroups )
	local GOli, groupId, i, subgroupTriples, rankD, result, realIrr, modulesGivenDimension,
        groupsOddList, groupsOddList2, index2StrategyData, subgroupTriplesTypeA, subgroupTriplesTypeB,
				nontrivialRealIrreduciblesNumber;

	modulesGivenDimension := [];
	subgroupTriplesTypeA := [];
	subgroupTriplesTypeB := [];
	rankD := [];
	nontrivialRealIrreduciblesNumber := [];
  result := [];

	for i in [60..order] do
		modulesGivenDimension[i] := [];
		subgroupTriplesTypeA[i] := [];
		subgroupTriplesTypeB[i] := [];
		rankD[i] := [];
		nontrivialRealIrreduciblesNumber[i] := [];
	od;
	for GOli in oliverGroups do
		Print( "Initializing SG", IdGroup( GOli ), " \n" );
    groupId := IdGroup( GOli );
		realIrr := RealIrreducibles( GOli );
		modulesGivenDimension[groupId] := ModulesGivenDimension( n, GOli, realIrr[1], realIrr[2], realIrr[3], realIrr[5], realIrr[6] );
		nontrivialRealIrreduciblesNumber[groupId[1]][groupId[2]] := Size( realIrr[1] );
		subgroupTriples := SubgroupTriples( GOli );
    subgroupTriplesTypeA[groupId] := subgroupTriples[1];
    subgroupTriplesTypeA[groupId] := subgroupTriples[1];
		rankD[groupId] := RankD( GOli, realIrr[1], realIrr[4] );
	od;
  result[1] := subgroupTriplesTypeA;
  result[2] := subgroupTriplesTypeB;
  result[3] := rankD;
  result[4] := nontrivialRealIrreduciblesNumber;
  result[5] := modulesGivenDimension;
  return result;
end;

# Level 5 function - the main function to call.
# For all Oliver groups up to a given order, computes the list of modules for which
#	the strategy was not able to exclude one fixed point actions on spheres. It also tells which
# ones from these modules are faithful and saves them in a separate list.
# Input:
# - n -the dimension of spheres to consider,
# - order the maximal order of Oliver groups to consider.
# Output is an object (a list) consisting of two lists (in that order):
# - modulesNotExcludedOne - a two dimensional table - in the groupId index contains all the modules
#		for which the strategy was not able to exclude one fixed point actions on S^n of SmallGroup(groupId),
# - faithfulModulesNotExcludedOne - the list of sublist of the lists above containing faithful modules.
ModulesNotExcludedOneOliverGroupsUpToOrder := function( n, order )
	local GOli, G, notExcludedModule, idGroup, tempModules, oliverGroups, i,
				initData, subgroupTriplesTypeA, subgroupTriplesTypeB, rankD,
				nontrivialRealIrreduciblesNumber, modulesGivenDimension,
				index2StrategyData, index2Subgroups, index2SubgroupIntersection,
				groupsOddList2, groupsOddList, modulesNotExcludedOdd, groupsExcludedOdd,
				modulesNotExcludedOne, faithfulModulesNotExcludedOne, result;

	oliverGroups := OliverGroupsUpToOrder( order );
	initData := Initialize( n, order );
	subgroupTriplesTypeA := initData[1];
	subgroupTriplesTypeB := initData[2];
	rankD := initData[3];
	nontrivialRealIrreduciblesNumber := initData[4];
	modulesGivenDimension := initData[5];

	index2StrategyData := Index2StrategyData( oliverGroups );
	index2Subgroups := index2StrategyData[1];
	index2SubgroupIntersection := index2StrategyData[2];
	groupsOddList2 := index2StrategyData[3];

	modulesNotExcludedOdd := [];
	modulesNotExcludedOne := [];
	faithfulModulesNotExcludedOne := [];
	for i in [60..order] do
		modulesNotExcludedOdd[i] := [];
		modulesNotExcludedOne[i] := [];
		faithfulModulesNotExcludedOne[i] := [];
	od;

	# Computing modules not excluded odd ###############################
	groupsExcludedOdd := [];
	for G in oliverGroups do
		idGroup := IdGroup( G );
		#Print( "Odd G = ", idGroup, "\n" );
		modulesNotExcludedOdd[idGroup] := ModulesNotExcludedOdd( G, modulesGivenDimension, groupsExcludedOdd, index2Subgroups, rankD, nontrivialRealIrreduciblesNumber, subgroupTriplesTypeA, subgroupTriplesTypeB );
		if Size( modulesNotExcludedOdd[idGroup] ) = 0 then
				Add( groupsExcludedOdd, G );
		fi;
	od;
	####################################################################


	for GOli in oliverGroups do
		idGroup := IdGroup( GOli );
		#Print( "\nOdd G = ", IdGroup( GOli ), "\n" );
		#Display( modulesNotExcludedOdd[idGroup[1]][idGroup[2]] );
		if Order( GOli ) <= order then
			#Print( "One G = ", IdGroup( GOli ), "\n" );
			modulesNotExcludedOne[idGroup] := ModulesNotExcludedOne( GOli, modulesNotExcludedOdd[idGroup], index2SubgroupIntersection[idGroup], subgroupTriplesTypeB[idGroup] );
			#Display( modulesNotExcludedOne[idGroup[1]][idGroup[2]] );
			for notExcludedModule in modulesNotExcludedOne[idGroup] do
					if IsFaithful( notExcludedModule, GOli ) = true then
							Add( faithfulModulesNotExcludedOne[idGroup], notExcludedModule );
					fi;
			od;
			#Print( "\nG = ", idGroup, "\n" );
			#Display( faithfulModulesNotExcludedOne[idGroup] );
		fi;
	od;
	result := [];
	result[1] := modulesNotExcludedOne;
	result[2] := faithfulModulesNotExcludedOne;
	return result;
end;
