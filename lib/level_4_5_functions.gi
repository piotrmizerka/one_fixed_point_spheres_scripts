# Level 4 function.
# Let G be a group.
# The function below computes the list MN_odd( givenDim, G ) of real G-modules - for the explanation,
# see my PhD thesis [2], p. 43. We know that the modules in that list cannot occur at tangent
# spaces at fixed point for odd fixed point actions of G on spheres of the same dimension dim.
# Apart from dim and G, the additional parameters are:
# - modulesGivenDimension - the list of real G-modules of given (implicitly) dimension,
# - groupsExcludedOdd - the list of idies of groups (intentionally not admitting odd fixed point acgtions on spheres),
# - subgroupTriples - the output of SubgroupTriples( G ).
InstallGlobalFunction( OFPModulesNotExcludedOdd,
                      function( G, modulesGivenDimension, groupsExcludedOdd, subgroupTriples )
  local realModule, triple, dimH1, dimH2, dimP, H, check, realIrr, rankD, result;
	for H in OFPIndex2SubgroupsSatisfyingProposition29( G ) do
		if IdGroup( H ) in groupsExcludedOdd then
			return [];
		fi;
	od;
	realIrr := OFPRealIrreducibles( G );
	rankD := OFPRankD( G, realIrr.realIrreducibles, realIrr.complexEquivalent );
	result := Set( modulesGivenDimension );
	for realModule in modulesGivenDimension do
		check := false;
		for triple in subgroupTriples.subgroupTriplesTypeA do
			if OFPFixedPointDimensionRealModule( realModule, Representative( triple[3] ),
																				G, realIrr.complexEquivalent ) = 0 then
				RemoveSet( result, realModule );
				check := true;
				break;
			fi;
		od;
		if check = false and rankD = Size( realIrr.realIrreducibles ) then
			for triple in subgroupTriples.subgroupTriplesTypeB do
				dimH1 := OFPFixedPointDimensionRealModule( realModule, Representative( triple[1] ),
																								G, realIrr.complexEquivalent );
				dimH2 := OFPFixedPointDimensionRealModule( realModule, Representative( triple[2] ),
																								G, realIrr.complexEquivalent );
				dimP := OFPFixedPointDimensionRealModule( realModule, Representative( triple[3] ),
																								G, realIrr.complexEquivalent );
				if dimH1+dimH2 = dimP and dimH1*dimH2 > 0 then
					RemoveSet( result, realModule );
					break;
				fi;
			od;
		fi;
	od;
	return result;
end );

# Level 5 function - the main function to call.
# For all Oliver groups up to a given order, computes the list of modules for which
#	the strategy was not able to exclude one fixed point actions on spheres. It also tells which
# ones from these modules are faithful and saves them in a separate list.
# Input:
# - dim - the dimension of spheres to consider,
# - order - the maximal order of Oliver groups to consider.
# Output is a record consisting of 4 the following lists:
# - modulesNotExcludedOne - a two dimensional table - in the groupId index contains all the modules
#		for which the strategy was not able to exclude one fixed point actions on S^n of SmallGroup(groupId),
# - modulesNotExcludedOdd - a two dimensional table - in the groupId index contains all the modules
#		for which the strategy was not able to exclude actions S^dim of SmallGroup(groupId) with odd
#		number of fixed points,
# - faithfulModulesNotExcludedOne - the list of sublists of the lists above containing faithful modules,
# - modulesGivenDimension - a two dimensional table - in the groupId index contains all the modules
#		of dimension dim.
InstallGlobalFunction( OFPModulesNotExcludedOneOliverGroupsUpToOrder, function( dim, order )
  local G, notExcludedModule, idGroup, idGroup2, oliverGroups, subgroupTriples, modulesGivenDimension,
        modulesNotExcludedOdd, groupsExcludedOdd, modulesNotExcludedOne, faithfulModulesNotExcludedOne,
        quotientGroup;

  modulesNotExcludedOdd := List( [1..order], i -> [] );
  modulesNotExcludedOne := List( [1..order], i -> [] );
  faithfulModulesNotExcludedOne := List( [1..order], i -> [] );
  modulesGivenDimension := List( [1..order], i -> [] );

  oliverGroups := OFPOliverGroupsUpToOrder( order );
  subgroupTriples := List( [1..order], i -> [] );

  # Computing modules not excluded odd ###############################
  groupsExcludedOdd := [];
  for G in oliverGroups do
    idGroup := IdGroup( G );
    modulesGivenDimension[idGroup[1]][idGroup[2]] := OFPModulesGivenDimension( dim, G );
    subgroupTriples[idGroup[1]][idGroup[2]] := OFPSubgroupTriples( G );
    modulesNotExcludedOdd[idGroup[1]][idGroup[2]] := OFPModulesNotExcludedOdd(
      G, modulesGivenDimension[idGroup[1]][idGroup[2]],
      groupsExcludedOdd, subgroupTriples[idGroup[1]][idGroup[2]] );
    if Size( modulesNotExcludedOdd[idGroup[1]][idGroup[2]] ) = 0 then
      Add( groupsExcludedOdd, IdGroup( G ) );
    fi;
  od;
  ####################################################################

  # Computing modules not excluded one - first stage ##################
  for G in oliverGroups do
    idGroup := IdGroup( G );
    modulesNotExcludedOne[idGroup[1]][idGroup[2]] := OFPModulesNotExcludedOne(
    G, modulesNotExcludedOdd[idGroup[1]][idGroup[2]],
    subgroupTriples[idGroup[1]][idGroup[2]].subgroupTriplesTypeB );
    faithfulModulesNotExcludedOne[idGroup[1]][idGroup[2]] := Filtered(
      modulesNotExcludedOne[idGroup[1]][idGroup[2]],
      notExcludedModule -> OFPIsFaithful( notExcludedModule, G ) );
  od;
  ####################################################################

  # Computing modules not excluded one - second stage - using the information
  # about the excluded faithful modules ##################################
  for G in oliverGroups do
    idGroup := IdGroup( G );
    for notExcludedModule in Immutable( modulesNotExcludedOne[idGroup[1]][idGroup[2]] ) do
      quotientGroup := G/OFPModuleKernel( notExcludedModule, G );
      if OFPIsOliver( quotientGroup ) then
        idGroup2 := IdGroup( quotientGroup );
        if Size( faithfulModulesNotExcludedOne[idGroup2[1]][idGroup2[2]] ) = 0 then
          RemoveSet( modulesNotExcludedOne[idGroup[1]][idGroup[2]], notExcludedModule );
        fi;
      else
        RemoveSet( modulesNotExcludedOne[idGroup[1]][idGroup[2]], notExcludedModule );
      fi;
    od;
  od;
  ####################################################################

  return rec( modulesNotExcludedOne := modulesNotExcludedOne,
              modulesNotExcludedOdd := modulesNotExcludedOdd,
              faithfulModulesNotExcludedOne := faithfulModulesNotExcludedOne,
              modulesGivenDimension := modulesGivenDimension );
end );

# Level 5 function.
# For a given group G computes the list of modules for which
#	the strategy was not able to exclude one fixed point actions on spheres. It also tells which
# ones from these modules are faithful and saves them in a separate list.
# Input:
# - dim - the dimension of spheres to consider,
# - G - the group to consider,
# - groupsExcludedOdd - the list of idies of groups (intentionally not admitting odd fixed point acgtions on spheres).
# Output is a record consisting of 4 the following lists:
# - modulesNotExcludedOne - contains all the modules for which the strategy was not able
#   to exclude one fixed point actions on S^n of G,
# - modulesNotExcludedOdd - contains all the modules for which the strategy was not able
#   to exclude actions S^dim of G with odd number of fixed points,
# - faithfulModulesNotExcludedOne - the sublists of the list above containing faithful modules,
# - modulesGivenDimension - contains all the characters of nontrivial real G-modules of dimension dim.
InstallGlobalFunction( OFPModulesNotExcludedOneSpecificGroup, function( dim, G, groupsExcludedOdd )
  local modulesGivenDimension, subgroupTriples, modulesNotExcludedOdd, modulesNotExcludedOne, faithfulModulesNotExcludedOne;
  modulesGivenDimension := OFPModulesGivenDimension( dim, G );
  subgroupTriples := OFPSubgroupTriples( G );
  modulesNotExcludedOdd := OFPModulesNotExcludedOdd( G, modulesGivenDimension, groupsExcludedOdd, subgroupTriples );
  modulesNotExcludedOne := OFPModulesNotExcludedOne( G, modulesNotExcludedOdd, subgroupTriples.subgroupTriplesTypeB );
  faithfulModulesNotExcludedOne := Filtered( modulesNotExcludedOne, notExcludedModule -> OFPIsFaithful( notExcludedModule, G ) );
  return rec( modulesNotExcludedOne := modulesNotExcludedOne,
              modulesNotExcludedOdd := modulesNotExcludedOdd,
              faithfulModulesNotExcludedOne := faithfulModulesNotExcludedOne,
              modulesGivenDimension := modulesGivenDimension );
end );
