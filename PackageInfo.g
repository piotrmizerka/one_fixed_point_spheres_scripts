SetPackageInfo( rec(
  PackageName := "OneFPActions", # convention - all fucntions from this package start with 'OFP'
  Version := "1.0",
  Subtitle := "An algorithm for excluding smooth one fixed point actions of finite groups on spheres",
  Date := "28/10/2020",
  SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/piotrmizerka/one_fixed_point_spheres_scripts",
  ),
  PackageDoc := rec(
      BookName  := "One fixed point actions on spheres",
      SixFile   := "doc/manual.six",
      Autoload  := false ),
  Dependencies := rec(
      GAP       := ">=4.7",
      NeededOtherPackages := [ ],
      SuggestedOtherPackages := [ ] ),
  AvailabilityTest := ReturnTrue,
  TestFile := "tst/testall.g",
   ) );
