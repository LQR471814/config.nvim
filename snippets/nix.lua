local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
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
