{
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.android_sdk.accept_license = true;
      };
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        toolsVersion = "26.1.1";
        platformToolsVersion = "31.0.2";
        buildToolsVersions = [ "30.0.2" ];
        includeEmulator = false;
        emulatorVersion = "30.3.4";
        platformVersions = [ "28" "29" "30"  ];
        includeSources = false;
        includeSystemImages = false;
        systemImageTypes = [ "google_apis_playstore"  ];
        abiVersions = [ "armeabi-v7a" "arm64-v8a"  ];
        cmakeVersions = [ "3.10.2"  ];
        includeNDK = true;
        ndkVersion = "22.0.7026061";
        useGoogleAPIs = false;
        useGoogleTVAddOns = false;
        includeExtras = [
          "extras;google;gcm"
        ];
      };
    in
      {
        devShell.x86_64-linux =
          pkgs.mkShell rec {
            ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
            ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";
            nativeBuildInputs = [ pkgs.openjdk8 ];
          };
      };
}
