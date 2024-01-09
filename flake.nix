{
	inputs = {
		nixpkgs = {
			url = "github:nixos/nixpkgs/nixos-unstable";
		};
		flake-utils = {
			url = "github:numtide/flake-utils";
		};
	};
	outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
		let
			pkgs = import nixpkgs {
				inherit system;
			};
			cpp-template = (with pkgs; stdenv.mkDerivation {
					name = "cpp-project";
					src = ./.;
					nativeBuildInputs = [
						clang
						cmake
					];
					buildInputs = [
					];
					buildPhase = "make -j $NIX_BUILD_CORES";
					installPhase = ''
						mkdir -p $out/bin
						mkdir -p $out/files
						mv ./cpp-project $out/bin
						mv ./* $out/files
					'';
				}
			);
		in rec {
			defaultApp = flake-utils.lib.mkApp {
				drv = defaultPackage;
			};
			defaultPackage = cpp-template;
			devShell = pkgs.mkShell {
				packages = with pkgs; [
					cmake
				];
			};
		}
	);
}
