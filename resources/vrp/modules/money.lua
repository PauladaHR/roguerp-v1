-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.addBank(user_id,amount)
	if amount > 0 then
		vRP.execute("vRP/add_bank",{ id = parseInt(user_id), bank = parseInt(amount) })

		local source = vRP.getUserSource(user_id)
		if source then
			TriggerClientEvent("itensNotify",source,{ "+","dollars",vRP.format(amount),"Dólares" })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setBank(user_id,amount)
	if amount >= 0 then
		vRP.execute("vRP/set_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.delBank(user_id,amount)
	if amount > 0 then
		vRP.execute("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getBank(user_id)
	local consult = vRP.getInformation(user_id)
	if consult[1] then
		return consult[1].bank
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.paymentBank(user_id,amount)
	if amount > 0 then
		local consult = vRP.getInformation(user_id)
		if consult[1] then
			if consult[1].bank >= amount then
				vRP.execute("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })

				local source = vRP.getUserSource(user_id)
				if source then
					TriggerClientEvent("itensNotify",source,{ "-","dollars",vRP.format(amount),"Dólares" })
				end
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.paymentFull(user_id,amount)
	if amount > 0 then
		if vRP.tryGetInventoryItem(user_id,"dollars",amount,true) then
			return true
		else
			local consult = vRP.getInformation(user_id)
			if consult[1] then
				if consult[1].bank >= amount then
					vRP.execute("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })

					local source = vRP.getUserSource(user_id)
					if source then
						TriggerClientEvent("itensNotify",source,{ "-","dollars",vRP.format(amount),"Dólares" })
					end
					return true
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWCASH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.withdrawCash(user_id,amount)
	if amount > 0 then
		local consult = vRP.getInformation(user_id)
		if consult[1] then
			if consult[1].bank >= amount then
				vRP.giveInventoryItem(user_id,"dollars",amount,true)
				vRP.execute("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setFines(user_id,price,nuser_id,text)
	vRP.execute("vRP/add_fines",{ user_id = user_id, nuser_id = tostring(nuser_id), date = os.date("%d.%m.%Y"), price = price, text = tostring(text) })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getFines(user_id)
	return vRP.query("vRP/get_fines",{ user_id = user_id })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userPremium(user_id)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		local consult = vRP.getInfos(identity.steam)
		if consult[1] and os.time() >= (consult[1].premium+24*consult[1].predays*60*60) then
			return false
		else
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPREMIUM2
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.premiumSteam(steam)
	local consult = vRP.getInfos(steam)
	if consult[1] and os.time() >= (consult[1].premium+24*consult[1].predays*60*60) then
		return false
	else
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasClass(user_id,class)
	local consult = vRP.query("vRP/get_class",{ id = user_id, class = tostring(class) })
	if consult[1] then
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PHONE BANK
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.setBankMoney = vRP.setBank
vRP.getBankMoney = vRP.getBank
vRP.giveBankMoney = vRP.addBank
vRP.giveMoney = vRP.addBank
vRP.tryFullPayment = vRP.paymentFull
vRP.tryPayment = vRP.paymentFull