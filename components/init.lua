local M = {}

local available_components = {
  clock = require("components.clock"),
}

function M.create_component(component_name, config)
  -- Skip tabs component entirely - tabs are now always in native tab bar
  if component_name == "tabs" then
    return nil
  end

  local component_module = available_components[component_name]

  if not component_module then
    error("Unknown component: " .. component_name)
  end

  local component = component_module.new()
  component:configure(config)

  return component
end

function M.get_available_components()
  local names = {}
  for name, _ in pairs(available_components) do
    table.insert(names, name)
  end
  return names
end

return M
