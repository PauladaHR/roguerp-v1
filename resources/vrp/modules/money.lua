-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.addBank(user_id,amount)
	if amount > 0 then
		vRP.query("vRP/add_bank",{ id = parseInt(user_id), bank = parseInt(amount) })

		local source = vRP.getUserSource(user_id)
		if source then
			TriggerClientEvent("itensNotify",source,{ "+","dollars",parseFormat(amount),"Dólares" })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setBank(user_id,amount)
	if amount >= 0 then
		vRP.query("vRP/set_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.delBank(user_id,amount)
	if amount > 0 then
		vRP.query("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
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
				vRP.query("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })

				local source = vRP.getUserSource(user_id)
				if source then
					TriggerClientEvent("itensNotify",source,{ "-","dollars",parseFormat(amount),"Dólares" })
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
					vRP.query("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })

					local source = vRP.getUserSource(user_id)
					if source then
						TriggerClientEvent("itensNotify",source,{ "-","dollars",parseFormat(amount),"Dólares" })
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
				vRP.query("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
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
	vRP.query("vRP/add_fines",{ user_id = user_id, nuser_id = tostring(nuser_id), date = os.date("%d.%m.%Y"), price = price, text = tostring(text) })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getFines(user_id)
	return vRP.query("vRP/get_fines",{ user_id = user_id })
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