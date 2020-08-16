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

quotientGroup := function( G, N )
	return Image( NaturalHomomorphismByNormalSubgroup( G, N ) );
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
