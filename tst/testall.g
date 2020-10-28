# To run the test open gap in tst directory and run
# Read( Filename( DirectoryCurrent(), "testall.g" ) );

LoadPackage( "OneFPActions" );
dirs := DirectoriesPackageLibrary( "OneFPActions", "tst" );
#TestDirectory( dirs, rec( exitGAP := true ) );
TestDirectory( dirs, rec( exitGAP := false ) );
