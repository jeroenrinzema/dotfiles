return {
  { "f-person/git-blame.nvim" },

  {
    "ray-x/go.nvim",
    config = function()
      require('go').setup()
    end,
  },
}
