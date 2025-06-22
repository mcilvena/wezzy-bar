local M = {}

function M.new(component_type)
  local component = {
    type = component_type,
    name = component_type,
    config = {},
  }

  function component:configure(config)
    self.config = config or {}
    return self
  end

  function component:render(context)
    error("render method must be implemented by component: " .. self.type)
  end

  function component:get_config(key, default)
    return self.config[key] or default
  end

  return component
end

return M
