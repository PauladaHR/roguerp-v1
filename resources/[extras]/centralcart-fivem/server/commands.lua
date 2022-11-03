Command = {}

Command.ban = function(framework, user_id)
  if framework == "CREATIVE" or framework == "CREATIVE4" or framework == "CREATIVE3" then
    async(function()
      vRP.kick(user_id, "Você foi expulso da cidade pois pediu reembolso do produto.")
    end)
    do return end
  end

  if framework == "VRP" or framework == "VRPEX" then
    local source = vRP.getUserSource(user_id)

    if source then
      vRP.kick(source, "Você foi expulso da cidade pois pediu reembolso do produto.")
    end
    do return end
  end
end

Command.group = function(framework, user_id, argument)
  if framework == "CREATIVE" or framework == "CREATIVE4" then
    async(function()
      vRP.setPermission(user_id, argument)
    end)
    do return end
  end

  if framework == "CREATIVE3" then
    vRP.insertPermission(vRP.getUserSource(user_id), argument)
    do return end
  end

  if framework == "VRP" or framework == "VRPEX" then
    vRP.addUserGroup(user_id, argument)
    do return end
  end
end

Command.ungroup = function(framework, user_id, argument)
  if framework == "CREATIVE" or framework == "CREATIVE4" then
    async(function()
      vRP.remPermission(user_id, argument)
    end)
    do return end
  end

  if framework == "CREATIVE3" then
    vRP.removePermission(vRP.getUserSource(user_id), argument)
    do return end
  end

  if framework == "VRP" or framework == "VRPEX" then
    vRP.removeUserGroup(user_id, argument)
    do return end
  end
end

Command.addMoney = function(framework, user_id, argument)
  if framework == "CREATIVE" then
    async(function()
      vRP.addBank(user_id, tonumber(argument), "Private")
    end)
    do return end
  end

  if framework == "CREATIVE4" or framework == "CREATIVE3" then
    vRP.addBank(user_id, tonumber(argument))
    do return end
  end

  if framework == "VRP" or framework == "VRPEX" then
    vRP.giveBankMoney(user_id, tonumber(argument))
    do return end
  end
end

Command.removeMoney = function(framework, user_id, argument)
  if framework == "CREATIVE" then
    async(function()
      vRP.delBank(user_id, tonumber(argument), "Private")
    end)
    do return end
  end

  if framework == "CREATIVE4" or framework == "CREATIVE3" then
    vRP.delBank(user_id, tonumber(argument))
    do return end
  end

  if framework == "VRP" or framework == "VRPEX" then
    vRP.setBankMoney(user_id, vRP.getBankMoney(user_id) - tonumber(argument))
    do return end
  end
end

Command.addInventory = function(framework, user_id, argument, amount)
  if framework == "CREATIVE" then
    async(function()
      vRP.generateItem(user_id, argument, amount, false)
    end)
    do return end
  end

  if framework == "VRP" or framework == "VRPEX" or framework == "CREATIVE4" or framework == "CREATIVE3" then
    vRP.giveInventoryItem(user_id, argument, amount, false)
    do return end
  end
end

Command.addHome = function(framework, user_id, argument)
  if framework == "CREATIVE" then
    async(function()
      vRP.execute("propertys/buying",
        { name = argument, user_id = user_id, interior = "Middle", price = 125000,
          residents = 2, vault = 50, fridge = 10, tax = os.time() })
    end)
    do return end
  end

  if framework == "CREATIVE4" then
    async(function()
      vRP.execute("propertys/buying",
        { name = argument, user_id = user_id, interior = "Middle", price = 125000,
          residents = 2, vault = 50, fridge = 10, tax = os.time(), contract = 1 })
    end)
    do return end
  end

  if framework == "CREATIVE3" then
    vRP.execute("vRP/add_permissions", {
      home = argument, user_id = user_id
    })
    do return end
  end

  if framework == "VRP" then
    local number = vRP.findFreeNumber(argument, 1000)
    vRP.setUserAddress(user_id, argument, number)
    do return end
  end

  if framework == "VRPEX" then
    async(function()
      vRP.execute("homes/buy_permissions", { home = argument, user_id = user_id, tax = os.time() })
    end)
    do return end
  end
end

Command.remHome = function(framework, user_id, argument)
  if framework == "CREATIVE" or framework == "CREATIVE4" then
    async(function()
      vRP.execute("propertys/removePermissions", {
        user_id = user_id,
        name = argument
      })
    end)
    do return end
  end

  if framework == "CREATIVE3" then
    vRP.execute("vRP/rem_permissions", { user_id = user_id, home = argument })
    do return end
  end

  if framework == "VRP" then
    vRP.removeUserAddress(user_id, argument)
    do return end
  end

  if framework == "VRPEX" then
    vRP.execute("homes/rem_permissions", {
      home = argument, user_id = user_id
    })
    do return end
  end
end


return Command
