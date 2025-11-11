# In order to debug "efficiently", repeatedly run 
# Read("C:\\Users\\Dyrektor\\Desktop\\Kamil\\one_fixed_point_spheres_scripts\\workshop_script.g");
# in GAP

# To define SL(2,5)xC4, run: G := DirectProduct(SL(2,5),CyclicGroup(7));

OFPFrobeniusSchurIndicator := function( chi, G )
  return Sum( ConjugacyClasses( G ),
  cl -> ( Size( cl ) * ( Representative(cl)^2 )^chi ) / Order( G ) );
end;

OFPLexSmallerTuples := function( tuple )
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

OFPRealIrreducibles := function( G, all_complex )
  local realIrreducibles, dimensionsRealModules, realIrrOfDim, complexEquivalent,
  realIrrNr, realIrrNrReversed, i, trivialModule, ir, row, it, sizex;
  realIrreducibles := [];
  dimensionsRealModules := [];
  realIrrOfDim := [];
  complexEquivalent := NewDictionary( [], true );
  realIrrNr := NewDictionary( [], true );
  realIrrNrReversed := NewDictionary( 1, true );
  i := 1;
  trivialModule := List( ConjugacyClasses( G ), cl -> 1 );
  it := 1;
  sizex := Size(Irr(G));
  for ir in Irr( G ) do
    Print(it, " ", sizex, "\n");
    it := it+1;
    if OFPFrobeniusSchurIndicator( ir, G ) = 1 or all_complex = true then
      row := List( ConjugacyClasses( G ), cl -> Representative( cl )^ir );
    else
      row := List( ConjugacyClasses( G ), cl -> 2*RealPart( Representative( cl )^ir ) );
    fi;
    if (row <> trivialModule and not (row in realIrreducibles)) or all_complex = true then
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

OFPModulesGivenDimension := function( dim, G, realIrr )
  local summandOccurrencesInGivenPartition, partition, summand, summands, restrictions,
  ir, restup, unorderedTuples, result, multiplicities, tempModule, temp, i, it, sizex;
  summandOccurrencesInGivenPartition := [];
  result := [];
  # Consider each partition of dim into summands being the dimensions of nontrivial real irredudcibles
  it := 0;
  sizex := Size(RestrictedPartitions( dim, realIrr.dimensionsRealModules ));
  for partition in RestrictedPartitions( dim, realIrr.dimensionsRealModules ) do
    # Print(it, " ", sizex, "\n");
    it := it+1;
    # Count the numbers of occurences of each summand in the current partition.
    for i in realIrr.dimensionsRealModules do
      summandOccurrencesInGivenPartition[i] := 0;
    od;
    for summand in partition do
      summandOccurrencesInGivenPartition[summand] := summandOccurrencesInGivenPartition[summand]+1;
    od;
    # Consider all choices of irreducibles of dimension equal to given summand with its number
    # of occurences in the decomposition of dim defined by the current partition.
    restrictions := [];
    unorderedTuples := [];
    summands := Set( partition );
    for summand in summands do
      unorderedTuples[summand] := UnorderedTuples( realIrr.realIrrOfDim[summand],
      summandOccurrencesInGivenPartition[summand] );
      Add( restrictions, Size( unorderedTuples[summand] ) );
    od;
    # Use an auxiliary combinatoric object responsible for iterating over all choices of irreducibles
    # for all summands in the current partition.
    for restup in OFPLexSmallerTuples( restrictions ) do
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

OFPFixedPointDimensionIrr := function( ir, H, G )
  local result, h;
  result := Sum( H, h-> h^ir )/ Order( H );
  if OFPFrobeniusSchurIndicator( ir, G ) <> 1 then
    return 2*result;
  else
    return result;
  fi;
end;

OFPFixedPointDimensionRealModule := function( realModule, H, G, complexEquivalent )
  return Sum( realModule,
              irrComponent -> OFPFixedPointDimensionIrr( LookupDictionary( complexEquivalent,
                                                                        irrComponent[1] ), H, G )
                              *irrComponent[2] );
end;

OFPGroupGeneratedBySubgroups := function( H1, H2 )
  return Group( Union( SmallGeneratingSet( H1 ), SmallGeneratingSet( H2 ) ) );
end;

OFPIsOliver := function( G )
  local N, H, idx;
  for H in NormalSubgroups( G ) do
    idx := IndexNC( G, H );
    if IsPrimePowerInt( idx ) or IsOne( idx ) then
      for N in NormalSubgroups( H ) do
        if IsPGroup( N ) and IsCyclic( H/N ) then
          return false;
        fi;
      od;
    fi;
  od;
  return true;
end;

# this modification didnt accelerate
OFPSubgroupTriplesA := function( G )
  local conjugacy_cl_sgbps, clH1, clH2, clP, H1, H2, P, conjugacy_cl_sgps_ids, considered_cls_sgbps_idies, 
        clH1_id, clH2_id, clP_id, result, it, sizex;
  conjugacy_cl_sgbps := ConjugacyClassesSubgroups( G );
  conjugacy_cl_sgps_ids := NewDictionary( [], true );
  considered_cls_sgbps_idies := [];
  result := [];
  it := 1;
  for clH1 in conjugacy_cl_sgbps do
    AddDictionary( conjugacy_cl_sgps_ids, clH1, it );
    it := it+1;
  od;
  it := 1;
  sizex := Size(conjugacy_cl_sgbps);
  for clH1 in conjugacy_cl_sgbps do
    Print(it," ",sizex,"\n");
    it := it+1;
    for clH2 in Filtered( conjugacy_cl_sgbps, clH -> Order( Representative(clH)) <= Order(Representative(clH1)) ) do
      for H1 in clH1 do
        for H2 in clH2 do
          if Order(H1)*Order(H2) > 1 then
            if Order( OFPGroupGeneratedBySubgroups( H1, H2 ) ) = Order( G ) and not OFPIsOliver( H1 ) and not OFPIsOliver( H2 ) then
              clH1_id := LookupDictionary( conjugacy_cl_sgps_ids, clH1 );
              clH2_id := LookupDictionary( conjugacy_cl_sgps_ids, clH2 );
              for clP in ConjugacyClassesSubgroups( Intersection( H1, H2 ) ) do
                P := Representative( clP );
                if IsPGroup( P ) then
                  clP_id := LookupDictionary( conjugacy_cl_sgps_ids, ConjugacyClassSubgroups( G, P ) );
                  if not ([clH1_id, clH2_id, clP_id] in considered_cls_sgbps_idies) then
                    Add( result, Immutable([ConjugacyClassSubgroups( G, H1 ), ConjugacyClassSubgroups( G, H2 ), ConjugacyClassSubgroups( G, P )]) );
                    AddSet( considered_cls_sgbps_idies, [clH1_id, clH2_id, clP_id] );
                  fi;
                fi;
              od;
            fi;
          fi;
        od;
      od;
    od;
  od;

  return result;
  # return Set( result );
end;

OFPModulesNotExcludedOdd := function( G, modulesGivenDimension, subgroupTriples )
  local realModule, triple, dimH1, dimH2, dimP, H, check, realIrr, rankD, result;
	realIrr := OFPRealIrreducibles( G );
	result := Set( modulesGivenDimension );
	for realModule in modulesGivenDimension do
		for triple in subgroupTriples.subgroupTriplesTypeA do
			if OFPFixedPointDimensionRealModule( realModule, Representative( triple[3] ),
																				G, realIrr.complexEquivalent ) = 0 then
				RemoveSet( result, realModule );
				break;
			fi;
		od;
	od;
	return result;
end;
