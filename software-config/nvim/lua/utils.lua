local M = {};

function M:github(owner, repo)
  return string.format("https://kkgithub.com/%s/%s", owner, repo)
end

return M;
