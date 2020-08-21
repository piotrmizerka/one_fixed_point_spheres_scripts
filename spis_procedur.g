QuotientGroup := function( G, N )
IsOliver := function( G )
OliverGroupsUpToOrder := function( order )
FrobeniusSchurIndicator := function( chi, G )
RealIrreducibles := function( G )
RealModuleCharacters := function( realModule, G )
IsFaithful := function( realModule, G )
realModuleDimension := function( realModule, G ) - usunac
RestrictedTuples := function( restrictions )
ModulesGivenDimension := function( dim, G )
FixedPointDimensionIrr := function( ir, H, G )
FixedPointDimensionRealModule := function( realModule, H, G )
TableFixedPointDimension := function( G )
Index2StrategyData := function( groupList )
GroupByGeneratingSubsets := function( H1, H2 )
SubgroupTriples := function( G )
RankD := function( G )
Initialize := function( n, order )

ModulesNotExcludedOdd := function( G, applyIndex2Strategy )
computeModulesNotExcludedOddGivenList := function( groupList, applyIndex2Strategy )
ModulesNotExcludedOne := function( G, applyIndex2Strategy )
ModulesNotExcludedOneOliverGroupsUpToOrder := function( n, order, applyIndex2Strategy )

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

complexEquivalent := NewDictionary( [], true );
realIrreducibles := [];
dimensionsRealModules := [];
realIrrOfDim := [];
numberRealIrrOfDim := [];
realIrrNr := NewDictionary( [], true );
realIrrNrReversed := NewDictionary( 1, true );
conjugacyClassesSubgroups := NewDictionary( SmallGroup( 1,1 ), true );
groupsOddList := [];
groupsOddList2 := [];

SatisfiesProposition29 := function( G )
