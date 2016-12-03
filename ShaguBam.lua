SLASH_SHAGUBAM1, SLASH_SHAGUBAM2, SLASH_SHAGUBAM3 = "/shagubam", "/sb", "/bam"
SlashCmdList["SHAGUBAM"] = function(message)
	local cmd = { }
	for c in string.gfind(message, "[^ ]+") do
		table.insert(cmd, string.lower(c))
	end

  if cmd[1] == "self" then
    ShaguBamSettings = "SELF"
  elseif cmd[1] == "emote" then
    ShaguBamSettings = "EMOTE"
  elseif cmd[1] == "say" then
    ShaguBamSettings = "SAY"
  elseif cmd[1] == "yell" then
    ShaguBamSettings = "YELL"
  elseif cmd[1] == "group" then
    ShaguBamSettings = "GROUP"
  elseif cmd[1] == "raid" then
    ShaguBamSettings = "RAID"
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ffccShaguBam|r usage:")
    DEFAULT_CHAT_FRAME:AddMessage("/bam [self, emote, say, yell, group, raid]")
  end

  if not ShaguBamSettings then 
    ShaguBamSettings = "EMOTE" 
  end
  DEFAULT_CHAT_FRAME:AddMessage("-> outut set to '" .. string.lower(ShaguBamSettings) .. "'")
  
end
ShaguBam = CreateFrame("Frame", nil)
ShaguBamRecord = {}
ShaguBam:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
ShaguBam:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
ShaguBam:RegisterEvent("PLAYER_ENTERING_WORLD");

function ShaguBam:PlaySound()
  PlaySoundFile("Interface\\AddOns\\ShaguBam\\bam.ogg")
end

ShaguBam:SetScript("OnEvent", function ()
  if not ShaguBamSettings then
    ShaguBamSettings = "EMOTE"
  end

	if event == "PLAYER_ENTERING_WORLD" then
		if GetLocale() == "deDE" then
		  ShaguBam.spell = "(.+) trifft (.+) kritisch: (%d+) .+%."
		  ShaguBam.weapon = "Ihr trefft (.+) kritisch für (%d+) .+%."
		else
	  	ShaguBam.spell = "Your (.+) crits (.+) for (%d+)"
		  ShaguBam.weapon = "You crit (.+) for (%d+)"
	  end
    return
  end

  for spell, mob, damage in string.gfind(arg1, ShaguBam.spell) do
    local damage = tonumber(damage)
    if not ShaguBamRecord[spell] or ShaguBamRecord[spell] < damage then
      ShaguBamRecord[spell] = damage
      if ShaguBamSettings == "SELF" then
        DEFAULT_CHAT_FRAME:AddMessage("Bam! " .. spell .. " crit for " .. damage .. "!")
      else
        SendChatMessage("Bam! " .. spell .. " crit for " .. damage .. "!", ShaguBamSettings)
      end
      ShaguBam:PlaySound()
    end
  end

  for mob, damage in string.gfind(arg1, ShaguBam.weapon) do
    local damage = tonumber(damage)
    if not ShaguBamRecord["auto"] or ShaguBamRecord["auto"] < damage then
      ShaguBamRecord["auto"] = damage
      if ShaguBamSettings == "SELF" then
        DEFAULT_CHAT_FRAME:AddMessage("Bam! Autohit crit for " .. damage .. "!")
      else
        SendChatMessage("Bam! Autohit crit for " .. damage .. "!", ShaguBamSettings)
      end
      ShaguBam:PlaySound()
    end
  end
end)
