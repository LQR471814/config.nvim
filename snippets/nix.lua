local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s({ trig = "cuda-flake-shell" }, fmta([[
		{
		  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		  outputs =
			{ self, nixpkgs }:
			let
			  system = "x86_64-linux";
			  pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
				config.cudaSupport = true; # Critical: tells nixpkgs to prefer CUDA versions
			  };
			in
			{
			  devShells.${system}.default =
				let
				  libs = with pkgs; [
					cudaPackages.cudatoolkit
					cudaPackages.cudnn
					linuxKernel.packages.linux_6_18.nvidia_x11
				  ];
				in
				pkgs.mkShell {
				  name = "cuda-env";
				  packages =
					(with pkgs; [
					  gnumake
					  gcc
					])
					++ libs;
				  # Nixpkgs now automates much of the LD_LIBRARY_PATH via 'autoAddDriverRunpath'
				  # but a shellHook is often still needed for user-installed pip packages.
				  shellHook = ''
					export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
					export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath libs}:$LD_LIBRARY_PATH"
					echo "Devshell activated."
				  '';
				};
			};
		}
	]], {})),
	s({ trig = "flake-shell" }, fmta([[
		{
		  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		  outputs =
			{ self, nixpkgs }:
			let
			  system = "x86_64-linux";
			  pkgs = import nixpkgs {
				inherit system;
			  };
			in
			{
			  devShells.${system}.default =
				let
				  libs = with pkgs; [ ];
				in
				pkgs.mkShell {
				  name = "devenv";
				  buildInputs = libs;
				  nativeBuildInputs =
					(with pkgs; [
					  pkg-config
					  <>
					]);
				  shellHook = ''
					export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath libs}:$LD_LIBRARY_PATH"
					echo "Devshell activated."
				  '';
				};
			};
		}
	]], { i(1) })),
	s({ trig = "shell" }, fmta([[
		{
		  pkgs ? import <<nixpkgs>> { },
		}:

		pkgs.mkShell {
		  name = "<>";

		  buildInputs = with pkgs; [
		    <>
		  ];

		  shellHook = ''
		    <>
		  '';
		}
    ]], {
		i(1, ""),
		i(2, ""),
		i(3, ""),
	})),
}
