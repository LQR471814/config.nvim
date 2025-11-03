return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        local keymap = require("lqr471814.lib.keymap")

        keymap:map({ "n", "x" }, "<leader>M", function()
            mc.matchAddCursor(-1)
        end, "Add prev new cursor by word or selection.")
        keymap:map({ "n", "x" }, "<leader>N", function()
            mc.matchSkipCursor(-1)
        end, "Skip the prev cursor added.")
        keymap:map({ "n", "x" }, "<leader>m", function()
            mc.matchAddCursor(1)
        end, "Add next new cursor by word or selection.")
        keymap:map({ "n", "x" }, "<leader>n", function()
            mc.matchSkipCursor(1)
        end, "Skip the next cursor added.")

        keymap:map("x", "S", mc.splitCursors, "Split visual selection into multiple cursors by regex.")
        keymap:map("n", "<leader>cm", mc.splitCursors, "Restore cursors.")
        keymap:map("n", "<leader>ca", mc.splitCursors, "Align cursor columns.")
        keymap:map("n", "ga", mc.addCursorOperator,
            "Adds a cursor to the start of each line in following cursor movement.")

        -- keymap layer only when multiple cursors exist
        mc.addKeymapLayer(function(set)
            set({ "n", "x" }, "N", function()
                mc.matchAddCursor(-1)
            end)
            set({ "n", "x" }, "n", function()
                mc.matchAddCursor(1)
            end)

            set({ "n", "x" }, "<leader>cx", mc.deleteCursor)

            set("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)
    end
}
