local slim = vim.uv.os_gethostname() == "raspberrypi"

require("lqr471814.set")
require("lqr471814.lazy")({
	slim = slim,
})
